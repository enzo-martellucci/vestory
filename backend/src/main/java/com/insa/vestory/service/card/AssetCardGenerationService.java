package com.insa.vestory.service.card;

import com.insa.vestory.dto.asset.CardGenerationResult;
import com.insa.vestory.model.entity.AssetCard;
import com.insa.vestory.model.entity.FinancialAsset;
import com.insa.vestory.model.enums.CardRarity;
import com.insa.vestory.repository.AssetCardRepository;
import com.insa.vestory.repository.FinancialAssetRepository;

import jakarta.transaction.Transactional;

import org.springframework.stereotype.Service;

import java.time.Instant;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;
import java.util.Map;
import java.util.UUID;
import java.util.function.Function;
import java.util.stream.Collectors;

@Service
public class AssetCardGenerationService {

    private final FinancialAssetRepository financialAssetRepository;
    private final AssetCardRepository assetCardRepository;

    public AssetCardGenerationService(
            FinancialAssetRepository financialAssetRepository,
            AssetCardRepository assetCardRepository
    ) {
        this.financialAssetRepository =
                financialAssetRepository;

        this.assetCardRepository =
                assetCardRepository;
    }

    @Transactional
    public CardGenerationResult syncCards() {

        List<FinancialAsset> assets =
                financialAssetRepository
                        .findAll()
                        .stream()
                        .filter(FinancialAsset::isEnabled)
                        .sorted(
                                Comparator.comparing(
                                        FinancialAsset::getSymbol
                                )
                        )
                        .toList();

        if (assets.isEmpty()) {
            throw new IllegalStateException(
                    "No FinancialAsset available"
            );
        }

        /*
         * Cartes déjà présentes.
         *
         * Clé = FinancialAsset.id
         */
        Map<UUID, AssetCard> existingCards =
                assetCardRepository
                        .findAll()
                        .stream()
                        .collect(
                                Collectors.toMap(
                                        card ->
                                                card
                                                        .getFinancialAsset()
                                                        .getId(),

                                        Function.identity()
                                )
                        );

        /*
         * On ne change jamais les anciens
         * collectionNumber.
         */
        int nextCollectionNumber =
                existingCards
                        .values()
                        .stream()
                        .mapToInt(
                                AssetCard::getCollectionNumber
                        )
                        .max()
                        .orElse(0)
                        + 1;

        int created = 0;
        int updated = 0;

        List<AssetCard> cardsToSave =
                new ArrayList<>();

        for (FinancialAsset asset : assets) {

            AssetCard card =
                    existingCards.get(
                            asset.getId()
                    );

            /*
             * Si aucune carte n'existe pour cet actif,
             * on la crée.
             */
            if (card == null) {

                card = new AssetCard();

                card.setFinancialAsset(asset);

                card.setCollectionNumber(
                        nextCollectionNumber++
                );

                /*
                 * Valeurs temporaires.
                 *
                 * Le système de rareté sera
                 * développé indépendamment.
                 */
                card.setRarity(
                        CardRarity.COMMON
                );

                card.setRarityScore(
                        0.0
                );

                card.setEnabled(true);

                card.setCreatedAt(
                        Instant.now()
                );

                created++;

            } else {

                /*
                 * La carte existe déjà.
                 *
                 * On ne recrée rien et on ne change
                 * ni son ID ni son numéro de collection.
                 */
                card.setEnabled(true);

                updated++;
            }

            cardsToSave.add(card);
        }

        assetCardRepository.saveAll(
                cardsToSave
        );

        return buildResult(
                cardsToSave,
                created,
                updated
        );
    }

    private CardGenerationResult buildResult(
            List<AssetCard> cards,
            int created,
            int updated
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

        return new CardGenerationResult(
                cards.size(),
                created,
                updated,
                common,
                rare,
                epic,
                legendary
        );
    }
}