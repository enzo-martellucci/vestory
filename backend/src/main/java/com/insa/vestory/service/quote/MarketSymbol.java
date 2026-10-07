package com.insa.vestory.service.quote;

import com.insa.vestory.model.entity.FinancialAsset;
import com.insa.vestory.model.enums.AssetType;
import org.springframework.http.HttpStatus;
import org.springframework.web.server.ResponseStatusException;

import java.util.Map;

record MarketSymbol(String symbol, String micCode) {

    private static final Map<String, String> COMMODITY_SYMBOLS = Map.of(
            "GCUSD", "XAU/USD",
            "SIUSD", "XAG/USD",
            "PLUSD", "XPT/USD",
            "PAUSD", "XPD/USD",
            "CLUSD", "WTI/USD",
            "BZUSD", "XBR/USD",
            "HGUSD", "HG1"
    );

    static MarketSymbol of(FinancialAsset asset) {
        if (asset.getAssetType() != AssetType.COMMODITY)
            return new MarketSymbol(asset.getSymbol(), asset.getMicCode());

        String symbol = COMMODITY_SYMBOLS.get(asset.getSymbol().toUpperCase());
        if (symbol == null)
            throw new ResponseStatusException(HttpStatus.NOT_IMPLEMENTED, "Commodity symbol is not mapped yet: " + asset.getSymbol());

        return new MarketSymbol(symbol, null);
    }
}
