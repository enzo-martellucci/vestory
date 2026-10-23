package com.insa.vestory.dto.asset;

import com.insa.vestory.constant.AssetType;
import com.insa.vestory.constant.Rarity;

public record AssetResponseDto(
    Long id,
    String symbol,
    String name,
    AssetType type,
    Rarity rarity,
    String micCode,
    String exchange,
    String country,
    String currency,
    String sector,
    String industry,
    String description,
    String logoUrl
) {
}
