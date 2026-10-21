package com.insa.vestory.dto.player;

import com.insa.vestory.dto.card.AssetCardResponseDto;
import com.insa.vestory.model.enums.PackType;

import java.util.UUID;

public record PackOpeningResultDto(
        UUID packId,
        PackType packType,
        AssetCardResponseDto card,
        boolean newCard,
        int gemsEarned,
        int totalGems
) {
}