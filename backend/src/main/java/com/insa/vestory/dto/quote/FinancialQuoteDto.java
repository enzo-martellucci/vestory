package com.insa.vestory.dto.quote;

import com.insa.vestory.model.enums.AssetType;

import java.time.Instant;
import java.util.UUID;

public record FinancialQuoteDto(

        UUID financialAssetId,

        String symbol,
        String name,
        AssetType assetType,

        String currency,
        String exchange,

        Double price,

        Double open,
        Double high,
        Double low,
        Double previousClose,

        Double change,
        Double changePercent,

        Double volume,

        boolean marketOpen,

        Instant timestamp,

        String provider

) {
}