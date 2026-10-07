package com.insa.vestory.service.card.rarity;

import com.insa.vestory.model.entity.FinancialAsset;
import com.insa.vestory.model.enums.AssetType;
import com.insa.vestory.model.enums.CardRarity;
import org.springframework.stereotype.Component;

import java.math.BigDecimal;
import java.util.Comparator;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.UUID;
import java.util.function.Function;
import java.util.stream.Collectors;

@Component
public class RarityCalculator {

    private static final double LEGENDARY_SHARE = 0.10;
    private static final double EPIC_SHARE = 0.15;
    private static final double RARE_SHARE = 0.25;

    private static final double MARKET_CAP_WEIGHT = 0.80;
    private static final double VOLUME_WEIGHT = 0.20;

    private static final double COMMODITY_FALLBACK_SCORE = 50.0;

    public Map<UUID, Double> computeScores(List<FinancialAsset> assets, Map<UUID, RarityMarketData> marketData) {
        Map<UUID, Double> scores = new HashMap<>();

        assets.stream()
                .collect(Collectors.groupingBy(FinancialAsset::getAssetType))
                .forEach((type, group) -> {
                    if (type == AssetType.FOREX)
                        group.forEach(asset -> scores.put(asset.getId(), forexScore(marketData.get(asset.getId()))));
                    else
                        scores.putAll(computeMarketScores(type, group, marketData));
                });

        return scores;
    }

    public Map<UUID, CardRarity> assignRarities(List<FinancialAsset> assets, Map<UUID, Double> scores) {
        List<FinancialAsset> ranked = assets.stream()
                .sorted(Comparator.comparingDouble((FinancialAsset asset) -> scores.getOrDefault(asset.getId(), 0.0))
                        .reversed()
                        .thenComparing(FinancialAsset::getSymbol))
                .toList();

        int total = ranked.size();
        int legendaryLimit = (int) Math.round(total * LEGENDARY_SHARE);
        int epicLimit = legendaryLimit + (int) Math.round(total * EPIC_SHARE);
        int rareLimit = epicLimit + (int) Math.round(total * RARE_SHARE);

        Map<UUID, CardRarity> rarities = new HashMap<>();
        for (int rank = 0; rank < total; rank++)
            rarities.put(ranked.get(rank).getId(), rarityForRank(rank, legendaryLimit, epicLimit, rareLimit));

        return rarities;
    }

    private Map<UUID, Double> computeMarketScores(AssetType type, List<FinancialAsset> group, Map<UUID, RarityMarketData> marketData) {
        List<RarityMarketData> available = group.stream()
                .map(asset -> marketData.get(asset.getId()))
                .filter(Objects::nonNull)
                .toList();
        List<BigDecimal> marketCaps = positiveValues(available, RarityMarketData::marketCap);
        List<BigDecimal> volumes = positiveValues(available, RarityMarketData::volume);

        Map<UUID, Double> scores = new HashMap<>();
        for (FinancialAsset asset : group) {
            RarityMarketData data = marketData.get(asset.getId());
            scores.put(asset.getId(), data == null ? fallbackScore(type) : round(marketScore(type, data, marketCaps, volumes)));
        }

        return scores;
    }

    private double marketScore(AssetType type, RarityMarketData data, List<BigDecimal> marketCaps, List<BigDecimal> volumes) {
        double volumeScore = percentile(data.volume(), volumes);
        boolean usesMarketCap = type != AssetType.COMMODITY && isPositive(data.marketCap()) && !marketCaps.isEmpty();

        if (!usesMarketCap)
            return volumeScore;

        return percentile(data.marketCap(), marketCaps) * MARKET_CAP_WEIGHT + volumeScore * VOLUME_WEIGHT;
    }

    private double fallbackScore(AssetType type) {
        return type == AssetType.COMMODITY ? COMMODITY_FALLBACK_SCORE : 0.0;
    }

    private double forexScore(RarityMarketData data) {
        if (data == null || data.forexGroup() == null)
            return 0.0;

        return switch (data.forexGroup().trim().toUpperCase()) {
            case "MAJOR" -> 100.0;
            case "MINOR" -> 70.0;
            case "EXOTIC" -> 40.0;
            case "EXOTIC-CROSS" -> 20.0;
            default -> 0.0;
        };
    }

    private CardRarity rarityForRank(int rank, int legendaryLimit, int epicLimit, int rareLimit) {
        if (rank < legendaryLimit)
            return CardRarity.LEGENDARY;
        if (rank < epicLimit)
            return CardRarity.EPIC;
        if (rank < rareLimit)
            return CardRarity.RARE;
        return CardRarity.COMMON;
    }

    private List<BigDecimal> positiveValues(List<RarityMarketData> data, Function<RarityMarketData, BigDecimal> extractor) {
        return data.stream()
                .map(extractor)
                .filter(this::isPositive)
                .toList();
    }

    private double percentile(BigDecimal value, List<BigDecimal> values) {
        if (!isPositive(value) || values.isEmpty())
            return 0;
        if (values.size() == 1)
            return 100;

        long below = values.stream()
                .filter(other -> other.compareTo(value) < 0)
                .count();

        return (double) below / (values.size() - 1) * 100.0;
    }

    private boolean isPositive(BigDecimal value) {
        return value != null && value.signum() > 0;
    }

    private double round(double value) {
        return Math.round(value * 100.0) / 100.0;
    }
}
