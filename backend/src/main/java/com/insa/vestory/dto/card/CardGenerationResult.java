package com.insa.vestory.dto.card;

public record CardGenerationResult(
        int total,
        int created,
        int reactivated,
        int disabled,
        RarityDistribution rarities
) {
}
