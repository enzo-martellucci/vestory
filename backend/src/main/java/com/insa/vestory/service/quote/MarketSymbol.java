package com.insa.vestory.service.quote;

import com.insa.vestory.constant.AssetType;
import com.insa.vestory.entity.Asset;

import java.util.Map;

record MarketSymbol(String symbol, String micCode, String trackedBy) {

    private static final Map<String, MarketSymbol> COMMODITIES = Map.of(
        "GCUSD", new MarketSymbol("XAU/USD", null, null),
        "SIUSD", new MarketSymbol("XAG/USD", null, null),
        "PLUSD", etf("PPLT"),
        "PAUSD", etf("PALL"),
        "CLUSD", etf("USO"),
        "BZUSD", etf("BNO"),
        "HGUSD", etf("CPER"),
        "NGUSD", etf("UNG")
    );

    static MarketSymbol of(Asset asset) {
        if (asset.getType() != AssetType.COMMODITY)
            return new MarketSymbol(asset.getSymbol(), asset.getMicCode(), null);

        return COMMODITIES.getOrDefault(asset.getSymbol().toUpperCase(), new MarketSymbol(asset.getSymbol(), null, null));
    }

    private static MarketSymbol etf(String symbol) {
        return new MarketSymbol(symbol, "ARCX", symbol);
    }

    String fmpSymbol(Asset asset) {
        return trackedBy != null ? trackedBy : asset.getSymbol();
    }
}
