package com.insa.vestory.dto.player;

import com.insa.vestory.dto.card.CardResponseDto;

import java.time.Instant;

public record OwnedCardDto(
        CardResponseDto card,
        boolean favorite,
        Instant firstObtainedAt,
        Instant lastObtainedAt
) {
}