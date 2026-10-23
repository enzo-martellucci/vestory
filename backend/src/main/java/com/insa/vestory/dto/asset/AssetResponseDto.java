package com.insa.vestory.dto.asset;

import com.insa.vestory.constant.AssetType;

public record AssetResponseDto(
    Long id,
    String symbol,
    String name,
    AssetType type,
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
