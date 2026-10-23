package com.insa.vestory.dto.player;

import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Positive;

public record AddGemsRequest(
        @NotNull(message = "Amount is required")
        @Positive(message = "Amount must be positive")
        @Max(value = 100000, message = "Amount must be at most 100000")
        Integer amount
) {
}
