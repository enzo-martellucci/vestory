package com.insa.vestory.service.card;

import com.insa.vestory.client.MarketDataUnavailableException;
import com.insa.vestory.dto.card.CardGenerationResult;
import com.insa.vestory.dto.card.CardRarityUpdateResult;
import com.insa.vestory.dto.card.RarityDistribution;
import com.insa.vestory.model.entity.AssetCard;
import com.insa.vestory.model.entity.FinancialAsset;
import com.insa.vestory.model.enums.CardRarity;
import com.insa.vestory.repository.AssetCardRepository;
import com.insa.vestory.repository.FinancialAssetRepository;
import com.insa.vestory.service.card.rarity.RarityCalculator;
import com.insa.vestory.service.card.rarity.RarityMarketDataLoader;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.server.ResponseStatusException;

import java.time.Instant;
import java.util.Collection;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.UUID;
import java.util.function.Function;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class CardSyncService {

    private static final double MINIMUM_DATA_COVERAGE = 0.80;

    private final FinancialAssetRepository financialAssetRepository;
    private final AssetCardRepository assetCardRepository;
    private final RarityMarketDataLoader rarityMarketDataLoader;
    private final RarityCalculator rarityCalculator;

    @Transactional
    public CardGenerationResult syncCards() {
        List<FinancialAsset> assets = financialAssetRepository.findAllByEnabledTrueOrderBySymbolAsc();
        if (assets.isEmpty())
            throw new ResponseStatusException(HttpStatus.CONFLICT, "No enabled financial asset, run the import first");

        List<AssetCard> existingCards = assetCardRepository.findAll();
        Map<UUID, AssetCard> cardsByAssetId = existingCards.stream()
                .collect(Collectors.toMap(card -> card.getFinancialAsset().getId(), Function.identity()));
        Set<UUID> enabledAssetIds = assets.stream().map(FinancialAsset::getId).collect(Collectors.toSet());

        int nextCollectionNumber = existingCards.stream().mapToInt(AssetCard::getCollectionNumber).max().orElse(0) + 1;
        int created = 0;
        int reactivated = 0;
        int disabled = 0;

        for (FinancialAsset asset : assets) {
            AssetCard card = cardsByAssetId.get(asset.getId());
            if (card == null) {
                cardsByAssetId.put(asset.getId(), newCard(asset, nextCollectionNumber++));
                created++;
            } else if (!card.isEnabled()) {
                card.setEnabled(true);
                reactivated++;
            }
        }

        for (AssetCard card : existingCards)
            if (card.isEnabled() && !enabledAssetIds.contains(card.getFinancialAsset().getId())) {
                card.setEnabled(false);
                disabled++;
            }

        List<AssetCard> savedCards = assetCardRepository.saveAll(cardsByAssetId.values());
        List<AssetCard> enabledCards = savedCards.stream().filter(AssetCard::isEnabled).toList();

        return new CardGenerationResult(enabledCards.size(), created, reactivated, disabled, distribution(enabledCards));
    }

    public CardRarityUpdateResult syncRarities() {
        List<AssetCard> cards = assetCardRepository.findAll();
        if (cards.isEmpty())
            throw new ResponseStatusException(HttpStatus.CONFLICT, "No card available, run the card sync first");

        List<FinancialAsset> assets = cards.stream().map(AssetCard::getFinancialAsset).toList();
        RarityMarketDataLoader.Result marketData = rarityMarketDataLoader.load(assets);

        int available = marketData.data().size();
        double coverage = (double) available / assets.size();
        if (coverage < MINIMUM_DATA_COVERAGE)
            throw new MarketDataUnavailableException("Not enough market data to update rarities (coverage: " + Math.round(coverage * 100) + "%)");

        Map<UUID, Double> scores = rarityCalculator.computeScores(assets, marketData.data());
        Map<UUID, CardRarity> rarities = rarityCalculator.assignRarities(assets, scores);

        for (AssetCard card : cards) {
            UUID assetId = card.getFinancialAsset().getId();
            card.setRarityScore(scores.getOrDefault(assetId, 0.0));
            card.setRarity(rarities.get(assetId));
        }
        assetCardRepository.saveAll(cards);

        return new CardRarityUpdateResult(
                cards.size(),
                available,
                cards.size() - available,
                marketData.unavailableSymbols(),
                distribution(cards)
        );
    }

    private AssetCard newCard(FinancialAsset asset, int collectionNumber) {
        AssetCard card = new AssetCard();
        card.setFinancialAsset(asset);
        card.setCollectionNumber(collectionNumber);
        card.setRarity(CardRarity.COMMON);
        card.setRarityScore(0.0);
        card.setEnabled(true);
        card.setCreatedAt(Instant.now());
        return card;
    }

    private RarityDistribution distribution(Collection<AssetCard> cards) {
        Map<CardRarity, Long> counts = cards.stream()
                .collect(Collectors.groupingBy(AssetCard::getRarity, Collectors.counting()));

        return new RarityDistribution(
                counts.getOrDefault(CardRarity.COMMON, 0L),
                counts.getOrDefault(CardRarity.RARE, 0L),
                counts.getOrDefault(CardRarity.EPIC, 0L),
                counts.getOrDefault(CardRarity.LEGENDARY, 0L)
        );
    }
}
