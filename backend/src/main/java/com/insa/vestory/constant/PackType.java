package com.insa.vestory.constant;

import lombok.Getter;

import java.util.Map;

@Getter
public enum PackType {
    STANDARD(200,
            Map.of(
                    CardRarity.COMMON, 0.70,
                    CardRarity.RARE, 0.22,
                    CardRarity.EPIC, 0.07,
                    CardRarity.LEGENDARY, 0.01
            ),
            Map.of(
                    CardRarity.COMMON, 0.80,
                    CardRarity.RARE, 0.16,
                    CardRarity.EPIC, 0.035,
                    CardRarity.LEGENDARY, 0.005
            )),
    PREMIUM(1500,
            Map.of(
                    CardRarity.COMMON, 0.40,
                    CardRarity.RARE, 0.40,
                    CardRarity.EPIC, 0.16,
                    CardRarity.LEGENDARY, 0.04
            ),
            Map.of(
                    CardRarity.COMMON, 0.55,
                    CardRarity.RARE, 0.33,
                    CardRarity.EPIC, 0.10,
                    CardRarity.LEGENDARY, 0.02
            )),
    ELITE(10000,
            Map.of(
                    CardRarity.RARE, 0.50,
                    CardRarity.EPIC, 0.40,
                    CardRarity.LEGENDARY, 0.10
            ),
            Map.of(
                    CardRarity.RARE, 0.60,
                    CardRarity.EPIC, 0.34,
                    CardRarity.LEGENDARY, 0.06
            ));

    private final int price;
    private final Map<CardRarity, Double> shopOdds;
    private final Map<CardRarity, Double> freeOdds;

    PackType(int price, Map<CardRarity, Double> shopOdds, Map<CardRarity, Double> freeOdds) {
        this.price = price;
        this.shopOdds = shopOdds;
        this.freeOdds = freeOdds;
    }

    public double oddsOf(CardRarity rarity, PackSource source) {
        Map<CardRarity, Double> odds = source.isFree() ? freeOdds : shopOdds;
        return odds.getOrDefault(rarity, 0.0);
    }
}
