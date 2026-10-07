package com.insa.vestory.dto.asset;

import com.insa.vestory.model.enums.AssetType;

import java.util.UUID;

public record FinancialAssetResponseDto(
        UUID id,
        String symbol,
        String micCode,
        String name,
        String brandName,
        AssetType assetType,
        String exchange,
        String country,
        String currency,
        String sector,
        String industry,
        String website,
        String description,
        String logoUrl,
        boolean enabled
) {
}
