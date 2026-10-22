package com.insa.vestory.dto.asset;

import com.insa.vestory.constant.AssetType;

import java.util.UUID;

public record AssetResponseDto(
    UUID id,
    String symbol,
    String micCode,
    String name,
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
