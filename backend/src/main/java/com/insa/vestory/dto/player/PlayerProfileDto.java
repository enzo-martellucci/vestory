package com.insa.vestory.dto.player;

import java.time.Instant;
import java.util.List;

public record PlayerProfileDto(
        int gems,
        List<UserPackDto> unopenedPacks,
        boolean dailyPackAvailable,
        Instant nextDailyPackAt
) {
}