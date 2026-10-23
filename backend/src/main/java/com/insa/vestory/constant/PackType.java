package com.insa.vestory.constant;

import lombok.Getter;

import java.util.Map;

@Getter
public enum PackType {
    STANDARD(200,
            Map.of(
                    Rarity.COMMON, 0.70,
                    Rarity.RARE, 0.22,
                    Rarity.EPIC, 0.07,
                    Rarity.LEGENDARY, 0.01
            ),
            Map.of(
                    Rarity.COMMON, 0.80,
                    Rarity.RARE, 0.16,
                    Rarity.EPIC, 0.035,
                    Rarity.LEGENDARY, 0.005
            )),
    PREMIUM(1500,
            Map.of(
                    Rarity.COMMON, 0.40,
                    Rarity.RARE, 0.40,
                    Rarity.EPIC, 0.16,
                    Rarity.LEGENDARY, 0.04
            ),
            Map.of(
                    Rarity.COMMON, 0.55,
                    Rarity.RARE, 0.33,
                    Rarity.EPIC, 0.10,
                    Rarity.LEGENDARY, 0.02
            )),
    ELITE(10000,
            Map.of(
                    Rarity.RARE, 0.50,
                    Rarity.EPIC, 0.40,
                    Rarity.LEGENDARY, 0.10
            ),
            Map.of(
                    Rarity.RARE, 0.60,
                    Rarity.EPIC, 0.34,
                    Rarity.LEGENDARY, 0.06
            ));

    private final int price;
    private final Map<Rarity, Double> shopOdds;
    private final Map<Rarity, Double> freeOdds;

    PackType(int price, Map<Rarity, Double> shopOdds, Map<Rarity, Double> freeOdds) {
        this.price = price;
        this.shopOdds = shopOdds;
        this.freeOdds = freeOdds;
    }

    public double oddsOf(Rarity rarity, PackSource source) {
        Map<Rarity, Double> odds = source.isFree() ? freeOdds : shopOdds;
        return odds.getOrDefault(rarity, 0.0);
    }
}
