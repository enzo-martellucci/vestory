package com.insa.vestory.dto.card;

import com.insa.vestory.model.enums.AssetType;
import com.insa.vestory.model.enums.CardRarity;

import java.util.UUID;

public record AssetCardResponseDto(

        UUID id,
        int collectionNumber,
        CardRarity rarity,
        double rarityScore,
        boolean enabled,

        UUID financialAssetId,
        String symbol,
        String name,
        AssetType assetType,
        String logoUrl,
        String description

) {
}