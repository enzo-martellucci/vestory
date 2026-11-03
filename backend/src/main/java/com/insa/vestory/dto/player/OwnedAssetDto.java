package com.insa.vestory.dto.player;

import com.insa.vestory.dto.asset.AssetResponseDto;

import java.time.Instant;

public record OwnedAssetDto(
        AssetResponseDto asset,
        boolean favorite,
        Instant firstObtainedAt,
        Instant lastObtainedAt
) {
}
