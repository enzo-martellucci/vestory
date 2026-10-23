package com.insa.vestory.service.card;

import com.insa.vestory.client.MarketDataUnavailableException;
import com.insa.vestory.constant.CardRarity;
import com.insa.vestory.dto.card.CardGenerationResult;
import com.insa.vestory.dto.card.CardRarityUpdateResult;
import com.insa.vestory.dto.card.RarityDistribution;
import com.insa.vestory.entity.Asset;
import com.insa.vestory.entity.Card;
import com.insa.vestory.repository.AssetRepository;
import com.insa.vestory.repository.CardRepository;
import com.insa.vestory.service.card.rarity.RarityCalculator;
import com.insa.vestory.service.card.rarity.RarityMarketDataLoader;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.server.ResponseStatusException;

import java.time.Instant;
import java.util.*;
import java.util.function.Function;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class CardSyncService {

    private static final double MINIMUM_DATA_COVERAGE = 0.80;

    private final AssetRepository assetRepository;
    private final CardRepository cardRepository;
    private final RarityMarketDataLoader rarityMarketDataLoader;
    private final RarityCalculator rarityCalculator;

    @Transactional
    public CardGenerationResult syncCards() {
        List<Asset> assets = assetRepository.findAllByOrderBySymbolAsc();
        if (assets.isEmpty())
            throw new ResponseStatusException(HttpStatus.CONFLICT, "No asset, run the import first");

        List<Card> existingCards = cardRepository.findAll();
        Map<Long, Card> cardsByAssetId = existingCards.stream()
            .collect(Collectors.toMap(card -> card.getAsset().getId(), Function.identity()));
        Set<Long> enabledAssetIds = assets.stream().map(Asset::getId).collect(Collectors.toSet());

        int nextCollectionNumber = existingCards.stream().mapToInt(Card::getCollectionNumber).max().orElse(0) + 1;
        int created = 0;
        int reactivated = 0;
        int disabled = 0;

        for (Asset asset : assets) {
            Card card = cardsByAssetId.get(asset.getId());
            if (card == null) {
                cardsByAssetId.put(asset.getId(), newCard(asset, nextCollectionNumber++));
                created++;
            } else if (!card.isEnabled()) {
                card.setEnabled(true);
                reactivated++;
            }
        }

        for (Card card : existingCards)
            if (card.isEnabled() && !enabledAssetIds.contains(card.getAsset().getId())) {
                card.setEnabled(false);
                disabled++;
            }

        List<Card> savedCards = cardRepository.saveAll(cardsByAssetId.values());
        List<Card> enabledCards = savedCards.stream().filter(Card::isEnabled).toList();

        return new CardGenerationResult(enabledCards.size(), created, reactivated, disabled, distribution(enabledCards));
    }

    public CardRarityUpdateResult syncRarities() {
        List<Card> cards = cardRepository.findAll();
        if (cards.isEmpty())
            throw new ResponseStatusException(HttpStatus.CONFLICT, "No card available, run the card sync first");

        List<Asset> assets = cards.stream().map(Card::getAsset).toList();
        RarityMarketDataLoader.Result marketData = rarityMarketDataLoader.load(assets);

        int available = marketData.data().size();
        double coverage = (double) available / assets.size();
        if (coverage < MINIMUM_DATA_COVERAGE)
            throw new MarketDataUnavailableException("Not enough market data to update rarities (coverage: " + Math.round(coverage * 100) + "%)");

        Map<Long, Double> scores = rarityCalculator.computeScores(assets, marketData.data());
        Map<Long, CardRarity> rarities = rarityCalculator.assignRarities(assets, scores);

        for (Card card : cards) {
            Long assetId = card.getAsset().getId();
            card.setRarityScore(scores.getOrDefault(assetId, 0.0));
            card.setRarity(rarities.get(assetId));
        }
        cardRepository.saveAll(cards);

        return new CardRarityUpdateResult(
            cards.size(),
            available,
            cards.size() - available,
            marketData.unavailableSymbols(),
            distribution(cards)
        );
    }

    private Card newCard(Asset asset, int collectionNumber) {
        Card card = new Card();
        card.setAsset(asset);
        card.setCollectionNumber(collectionNumber);
        card.setRarity(CardRarity.COMMON);
        card.setRarityScore(0.0);
        card.setEnabled(true);
        card.setCreatedAt(Instant.now());
        return card;
    }

    private RarityDistribution distribution(Collection<Card> cards) {
        Map<CardRarity, Long> counts = cards.stream()
            .collect(Collectors.groupingBy(Card::getRarity, Collectors.counting()));

        return new RarityDistribution(
            counts.getOrDefault(CardRarity.COMMON, 0L),
            counts.getOrDefault(CardRarity.RARE, 0L),
            counts.getOrDefault(CardRarity.EPIC, 0L),
            counts.getOrDefault(CardRarity.LEGENDARY, 0L)
        );
    }
}
