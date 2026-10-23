package com.insa.vestory.dto.player;

import com.insa.vestory.constant.PackType;
import jakarta.validation.constraints.NotNull;

public record BuyPackRequest(
        @NotNull(message = "Pack type is required")
        PackType type
) {
}