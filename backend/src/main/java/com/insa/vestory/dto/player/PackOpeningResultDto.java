package com.insa.vestory.dto.player;

import com.insa.vestory.constant.PackType;
import com.insa.vestory.dto.asset.AssetResponseDto;

import java.util.UUID;

public record PackOpeningResultDto(
        UUID packId,
        PackType packType,
        AssetResponseDto asset,
        boolean newAsset,
        int gemsEarned,
        int totalGems
) {
}