package com.insa.vestory.model.enums;

import lombok.Getter;

import java.util.Map;

@Getter
public enum PackType {
    STANDARD(150, Map.of(
            CardRarity.COMMON, 0.60,
            CardRarity.RARE, 0.27,
            CardRarity.EPIC, 0.10,
            CardRarity.LEGENDARY, 0.03
    )),
    PREMIUM(400, Map.of(
            CardRarity.RARE, 0.65,
            CardRarity.EPIC, 0.28,
            CardRarity.LEGENDARY, 0.07
    )),
    ELITE(1000, Map.of(
            CardRarity.EPIC, 0.75,
            CardRarity.LEGENDARY, 0.25
    ));

    private final int price;
    private final Map<CardRarity, Double> odds;

    PackType(int price, Map<CardRarity, Double> odds) {
        this.price = price;
        this.odds = odds;
    }

    public double oddsOf(CardRarity rarity) {
        return odds.getOrDefault(rarity, 0.0);
    }
}