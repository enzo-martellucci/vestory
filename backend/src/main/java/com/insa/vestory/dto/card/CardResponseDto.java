package com.insa.vestory.dto.card;

import com.insa.vestory.constant.AssetType;
import com.insa.vestory.constant.CardRarity;

import java.util.UUID;

public record CardResponseDto(
    UUID id,
    int collectionNumber,
    CardRarity rarity,
    double rarityScore,
    boolean enabled,
    Long assetId,
    String symbol,
    String name,
    AssetType assetType,
    String country,
    String sector,
    String logoUrl,
    String description
) {
}
