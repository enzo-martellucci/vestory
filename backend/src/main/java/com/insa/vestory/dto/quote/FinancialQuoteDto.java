package com.insa.vestory.dto.quote;

import com.insa.vestory.model.enums.AssetType;

import java.math.BigDecimal;
import java.time.Instant;
import java.util.UUID;

public record FinancialQuoteDto(

        UUID financialAssetId,

        String symbol,
        String name,
        AssetType assetType,

        BigDecimal price,

        BigDecimal open,
        BigDecimal high,
        BigDecimal low,
        BigDecimal previousClose,

        BigDecimal change,
        BigDecimal changePercent,

        BigDecimal volume,

        boolean marketOpen,

        Instant timestamp,

        String provider

) {
}