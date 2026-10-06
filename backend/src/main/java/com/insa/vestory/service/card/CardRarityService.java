package com.insa.vestory.service.card;

import com.insa.vestory.dto.card.RarityMarketData;
import com.insa.vestory.dto.card.TwelveDataForexPairDto;
import com.insa.vestory.model.entity.FinancialAsset;
import com.insa.vestory.model.enums.AssetType;
import com.insa.vestory.model.enums.CardRarity;

import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.util.Comparator;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.UUID;
import java.util.stream.Collectors;

@Service
public class CardRarityService {

    public Map<UUID, Double> calculateScores(
            List<FinancialAsset> assets,
            Map<String, RarityMarketData> marketData,
            Map<String, TwelveDataForexPairDto> forexPairs
    ) {

        Map<UUID, Double> scores =
                new HashMap<>();

        Map<AssetType, List<FinancialAsset>> byType =
                assets.stream()
                        .collect(
                                Collectors.groupingBy(
                                        FinancialAsset::getAssetType
                                )
                        );

        for (
                Map.Entry<
                        AssetType,
                        List<FinancialAsset>
                        > entry
                : byType.entrySet()
        ) {

            AssetType type =
                    entry.getKey();

            List<FinancialAsset> group =
                    entry.getValue();

            /*
             * FOREX
             */
            if (type == AssetType.FOREX) {

                calculateForexScores(
                        group,
                        forexPairs,
                        scores
                );

                continue;
            }

            List<BigDecimal> marketCaps =
                    group.stream()
                            .map(asset ->
                                    marketDataFor(
                                            asset,
                                            marketData
                                    )
                            )
                            .filter(
                                    Objects::nonNull
                            )
                            .map(
                                    RarityMarketData::marketCap
                            )
                            .filter(
                                    this::isPositive
                            )
                            .toList();

            List<BigDecimal> volumes =
                    group.stream()
                            .map(asset ->
                                    marketDataFor(
                                            asset,
                                            marketData
                                    )
                            )
                            .filter(
                                    Objects::nonNull
                            )
                            .map(
                                    RarityMarketData::volume
                            )
                            .filter(
                                    this::isPositive
                            )
                            .toList();

            for (FinancialAsset asset : group) {

                RarityMarketData data =
                        marketDataFor(
                                asset,
                                marketData
                        );

                /*
                 * Provider indisponible / symbole premium.
                 *
                 * On donne 0 plutôt que de planter.
                 */
                if (data == null) {

                    double fallbackScore =
                            type == AssetType.COMMODITY
                                    ? 50.0
                                    : 0.0;

                    scores.put(
                            asset.getId(),
                            fallbackScore
                    );

                    continue;
                }

                double volumeScore =
                        percentile(
                                data.volume(),
                                volumes
                        );

                double score;

                /*
                 * STOCK / ETF / CRYPTO
                 */
                if (
                        type == AssetType.STOCK
                                || type == AssetType.ETF
                                || type == AssetType.CRYPTO
                ) {

                    if (
                            isPositive(
                                    data.marketCap()
                            )
                                    && !marketCaps.isEmpty()
                    ) {

                        double marketCapScore =
                                percentile(
                                        data.marketCap(),
                                        marketCaps
                                );

                        score =
                                (marketCapScore * 0.80)
                                        + (volumeScore * 0.20);

                    } else {

                        score =
                                volumeScore;
                    }

                } else {

                    /*
                     * COMMODITY
                     */
                    score =
                            volumeScore;
                }

                scores.put(
                        asset.getId(),
                        round(score)
                );
            }
        }

        return scores;
    }

    private void calculateForexScores(
            List<FinancialAsset> assets,
            Map<String, TwelveDataForexPairDto> forexPairs,
            Map<UUID, Double> scores
    ) {

        for (FinancialAsset asset : assets) {

            String symbol =
                    normalizeForexSymbol(
                            asset.getSymbol()
                    );

            TwelveDataForexPairDto pair =
                    forexPairs.get(
                            symbol
                    );

            /*
             * Si Twelve Data ne possède pas la paire,
             * score de secours = 0.
             */
            if (pair == null) {

                scores.put(
                        asset.getId(),
                        0.0
                );

                continue;
            }

            scores.put(
                    asset.getId(),
                    scoreForexGroup(
                            pair.currencyGroup()
                    )
            );
        }
    }

    public Map<UUID, CardRarity> assignRarities(
            List<FinancialAsset> assets,
            Map<UUID, Double> scores
    ) {

        List<FinancialAsset> ranked =
                assets.stream()
                        .sorted(
                                Comparator
                                        .comparingDouble(
                                                (FinancialAsset asset) ->
                                                        scores.getOrDefault(
                                                                asset.getId(),
                                                                0.0
                                                        )
                                        )
                                        .reversed()
                                        .thenComparing(
                                                FinancialAsset::getSymbol
                                        )
                        )
                        .toList();

        int total =
                ranked.size();

        int legendaryCount =
                (int) Math.round(
                        total * 0.10
                );

        int epicCount =
                (int) Math.round(
                        total * 0.15
                );

        int rareCount =
                (int) Math.round(
                        total * 0.25
                );

        Map<UUID, CardRarity> rarities =
                new HashMap<>();

        for (int i = 0; i < total; i++) {

            CardRarity rarity;

            if (i < legendaryCount) {

                rarity =
                        CardRarity.LEGENDARY;

            } else if (
                    i
                            < legendaryCount
                            + epicCount
            ) {

                rarity =
                        CardRarity.EPIC;

            } else if (
                    i
                            < legendaryCount
                            + epicCount
                            + rareCount
            ) {

                rarity =
                        CardRarity.RARE;

            } else {

                rarity =
                        CardRarity.COMMON;
            }

            rarities.put(
                    ranked
                            .get(i)
                            .getId(),
                    rarity
            );
        }

        return rarities;
    }

    private double percentile(
            BigDecimal value,
            List<BigDecimal> values
    ) {

        if (
                !isPositive(value)
                        || values.isEmpty()
        ) {

            return 0;
        }

        if (values.size() == 1) {

            return 100;
        }

        long below =
                values.stream()
                        .filter(v ->
                                v.compareTo(value) < 0
                        )
                        .count();

        return (
                (double) below
                        / (values.size() - 1)
        ) * 100.0;
    }

    private RarityMarketData marketDataFor(
            FinancialAsset asset,
            Map<String, RarityMarketData> marketData
    ) {

        return marketData.get(
                normalizeSymbol(
                        asset.getSymbol()
                )
        );
    }

    private boolean isPositive(
            BigDecimal value
    ) {

        return value != null
                && value.signum() > 0;
    }

    public String normalizeSymbol(
            String symbol
    ) {

        return symbol
                .replace("/", "")
                .trim()
                .toUpperCase();
    }

    public String normalizeForexSymbol(
            String symbol
    ) {

        return symbol
                .trim()
                .toUpperCase();
    }

    private double scoreForexGroup(
            String currencyGroup
    ) {

        if (currencyGroup == null) {

            return 0;
        }

        return switch (
                currencyGroup
                        .trim()
                        .toUpperCase()
                ) {

            case "MAJOR" ->
                    100.0;

            case "MINOR" ->
                    70.0;

            case "EXOTIC" ->
                    40.0;

            case "EXOTIC-CROSS" ->
                    20.0;

            default ->
                    0.0;
        };
    }

    private double round(
            double value
    ) {

        return Math.round(
                value * 100.0
        ) / 100.0;
    }
}