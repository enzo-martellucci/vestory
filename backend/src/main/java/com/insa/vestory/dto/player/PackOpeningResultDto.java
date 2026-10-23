package com.insa.vestory.dto.player;

import com.insa.vestory.constant.PackType;
import com.insa.vestory.dto.card.CardResponseDto;

import java.util.UUID;

public record PackOpeningResultDto(
        UUID packId,
        PackType packType,
        CardResponseDto card,
        boolean newCard,
        int gemsEarned,
        int totalGems
) {
}