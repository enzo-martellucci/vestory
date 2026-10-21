package com.insa.vestory.dto.player;

import com.insa.vestory.dto.card.AssetCardResponseDto;

import java.time.Instant;

public record OwnedCardDto(
        AssetCardResponseDto card,
        boolean favorite,
        Instant firstObtainedAt,
        Instant lastObtainedAt
) {
}