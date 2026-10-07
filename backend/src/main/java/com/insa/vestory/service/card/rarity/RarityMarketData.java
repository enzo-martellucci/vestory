package com.insa.vestory.service.card.rarity;

import java.math.BigDecimal;

public record RarityMarketData(BigDecimal marketCap, BigDecimal volume, String forexGroup) {

    public static RarityMarketData ofMarket(BigDecimal marketCap, BigDecimal volume) {
        return new RarityMarketData(marketCap, volume, null);
    }

    public static RarityMarketData ofForex(String forexGroup) {
        return new RarityMarketData(null, null, forexGroup);
    }
}
