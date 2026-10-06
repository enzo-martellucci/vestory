package com.insa.vestory.service.card;

import com.insa.vestory.client.FmpClient;
import com.insa.vestory.client.TwelveDataClient;
import com.insa.vestory.dto.card.CardRarityUpdateResult;
import com.insa.vestory.dto.card.RarityMarketData;
import com.insa.vestory.dto.card.FmpCompanyProfileDto;
import com.insa.vestory.dto.card.FmpQuoteDto;
import com.insa.vestory.dto.card.TwelveDataForexPairDto;
import com.insa.vestory.model.entity.AssetCard;
import com.insa.vestory.model.entity.FinancialAsset;
import com.insa.vestory.model.enums.AssetType;
import com.insa.vestory.model.enums.CardRarity;
import com.insa.vestory.repository.AssetCardRepository;

import jakarta.transaction.Transactional;

import org.springframework.stereotype.Service;
import org.springframework.web.client.HttpClientErrorException;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;
import java.util.function.Function;
import java.util.stream.Collectors;

@Service
public class CardRarityUpdateService {

    private static final double MINIMUM_DATA_COVERAGE = 0.80;

    private final AssetCardRepository assetCardRepository;

    private final CardRarityService cardRarityService;

    private final FmpClient fmpClient;
    private final TwelveDataClient twelveDataClient;

    public CardRarityUpdateService(
            AssetCardRepository assetCardRepository,
            CardRarityService cardRarityService,
            FmpClient fmpClient,
            TwelveDataClient twelveDataClient
    ) {

        this.assetCardRepository =
                assetCardRepository;

        this.cardRarityService =
                cardRarityService;

        this.fmpClient =
                fmpClient;

        this.twelveDataClient =
                twelveDataClient;
    }

    @Transactional
    public CardRarityUpdateResult syncRarities() {

        List<AssetCard> cards =
                assetCardRepository.findAll();

        if (cards.isEmpty()) {

            throw new IllegalStateException(
                    "No AssetCard available"
            );
        }

        List<FinancialAsset> assets =
                cards.stream()
                        .map(
                                AssetCard::getFinancialAsset
                        )
                        .toList();

        List<String> unavailableSymbols =
                new ArrayList<>();

        /*
         * STOCK / ETF / CRYPTO / COMMODITY
         */
        Map<String, RarityMarketData> marketData =
                loadMarketData(
                        assets,
                        unavailableSymbols
                );

        /*
         * FOREX
         */
        Map<String, TwelveDataForexPairDto> forexPairs =
                loadForexPairs();

        int availableCount =
                countAvailableMarketData(
                        assets,
                        marketData,
                        forexPairs,
                        unavailableSymbols
                );

        /*
         * Protection importante :
         *
         * si l'API est globalement indisponible,
         * on ne remplace pas toutes les raretés
         * par des scores mauvais.
         */
        double coverage =
                (double) availableCount
                        / assets.size();

        if (coverage < MINIMUM_DATA_COVERAGE) {

            throw new IllegalStateException(
                    "Not enough market data to update rarities. "
                            + "Coverage: "
                            + Math.round(coverage * 100)
                            + "%"
            );
        }

        /*
         * Calcul des scores.
         */
        Map<UUID, Double> scores =
                cardRarityService.calculateScores(
                        assets,
                        marketData,
                        forexPairs
                );

        /*
         * Attribution finale des raretés.
         */
        Map<UUID, CardRarity> rarities =
                cardRarityService.assignRarities(
                        assets,
                        scores
                );

        /*
         * Mise à jour des AssetCard existantes.
         *
         * Aucune carte n'est recréée.
         */
        for (AssetCard card : cards) {

            UUID assetId =
                    card
                            .getFinancialAsset()
                            .getId();

            card.setRarityScore(
                    scores.getOrDefault(
                            assetId,
                            0.0
                    )
            );

            card.setRarity(
                    rarities.get(
                            assetId
                    )
            );
        }

        assetCardRepository.saveAll(
                cards
        );

        return buildResult(
                cards,
                availableCount,
                unavailableSymbols
        );
    }

    private Map<String, RarityMarketData>
    loadMarketData(
            List<FinancialAsset> assets,
            List<String> unavailableSymbols
    ) {

        Map<String, RarityMarketData> result =
                new HashMap<>();

        for (FinancialAsset asset : assets) {

            /*
             * Le FOREX est traité séparément
             * par Twelve Data.
             */
            if (asset.getAssetType()
                    == AssetType.FOREX) {

                continue;
            }

            String symbol =
                    cardRarityService
                            .normalizeSymbol(
                                    asset.getSymbol()
                            );

            try {

                switch (asset.getAssetType()) {

                    /*
                     * STOCK / ETF
                     *
                     * On utilise FMP /profile.
                     */
                    case STOCK, ETF -> {

                        FmpCompanyProfileDto profile =
                                fmpClient
                                        .getCompanyProfile(
                                                symbol
                                        );

                        result.put(
                                symbol,
                                new RarityMarketData(
                                        profile.marketCap(),
                                        profile.volume()
                                )
                        );
                    }

                    /*
                     * CRYPTO / COMMODITY
                     *
                     * On utilise FMP /quote.
                     *
                     * Si un symbole est premium,
                     * il sera simplement ignoré.
                     */
                    case CRYPTO, COMMODITY -> {

                        FmpQuoteDto quote =
                                fmpClient
                                        .getQuote(
                                                symbol
                                        );

                        result.put(
                                symbol,
                                new RarityMarketData(
                                        quote.marketCap(),
                                        quote.volume()
                                )
                        );
                    }

                    default -> {
                    }
                }

            } catch (HttpClientErrorException e) {

                /*
                 * 429 = quota FMP épuisé.
                 *
                 * Là on arrête immédiatement :
                 * continuer les 200 appels serait inutile.
                 */
                if (e.getStatusCode().value() == 429) {

                    throw new IllegalStateException(
                            "FMP API limit reached. "
                                    + "Rarity update cancelled.",
                            e
                    );
                }

                /*
                 * Exemple :
                 * PLUSD -> 402 premium.
                 *
                 * On ne fait pas planter tout le sync.
                 */
                unavailableSymbols.add(
                        asset.getSymbol()
                                + " [FMP]"
                );

            } catch (Exception e) {

                unavailableSymbols.add(
                        asset.getSymbol()
                                + " [FMP]"
                );
            }
        }

        return result;
    }

    private Map<String, TwelveDataForexPairDto>
    loadForexPairs() {

        try {

            return twelveDataClient
                    .getForexPairs()
                    .stream()
                    .filter(pair ->
                            pair.symbol() != null
                    )
                    .collect(
                            Collectors.toMap(

                                    pair ->
                                            cardRarityService
                                                    .normalizeForexSymbol(
                                                            pair.symbol()
                                                    ),

                                    Function.identity(),

                                    (first, second) ->
                                            first
                            )
                    );

        } catch (Exception e) {

            /*
             * On laisse le contrôle de couverture
             * décider si on peut continuer.
             */
            return Map.of();
        }
    }

    private int countAvailableMarketData(
            List<FinancialAsset> assets,
            Map<String, RarityMarketData> marketData,
            Map<String, TwelveDataForexPairDto> forexPairs,
            List<String> unavailableSymbols
    ) {

        int available =
                0;

        for (FinancialAsset asset : assets) {

            if (asset.getAssetType()
                    == AssetType.FOREX) {

                String symbol =
                        cardRarityService
                                .normalizeForexSymbol(
                                        asset.getSymbol()
                                );

                if (forexPairs.containsKey(
                        symbol
                )) {

                    available++;

                } else {

                    unavailableSymbols.add(
                            asset.getSymbol()
                                    + " [Twelve Data]"
                    );
                }

            } else {

                String symbol =
                        cardRarityService
                                .normalizeSymbol(
                                        asset.getSymbol()
                                );

                if (marketData.containsKey(
                        symbol
                )) {

                    available++;
                }
            }
        }

        return available;
    }

    private CardRarityUpdateResult buildResult(
            List<AssetCard> cards,
            int marketDataAvailable,
            List<String> unavailableSymbols
    ) {

        int common = 0;
        int rare = 0;
        int epic = 0;
        int legendary = 0;

        for (AssetCard card : cards) {

            switch (card.getRarity()) {

                case COMMON ->
                        common++;

                case RARE ->
                        rare++;

                case EPIC ->
                        epic++;

                case LEGENDARY ->
                        legendary++;
            }
        }

        return new CardRarityUpdateResult(

                cards.size(),

                cards.size(),

                common,
                rare,
                epic,
                legendary,

                marketDataAvailable,

                cards.size()
                        - marketDataAvailable,

                unavailableSymbols
                        .stream()
                        .distinct()
                        .sorted()
                        .toList()
        );
    }
}