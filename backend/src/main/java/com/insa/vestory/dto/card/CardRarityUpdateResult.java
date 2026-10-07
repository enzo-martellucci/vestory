package com.insa.vestory.dto.card;

import java.util.List;

public record CardRarityUpdateResult(
        int total,
        int marketDataAvailable,
        int marketDataUnavailable,
        List<String> unavailableSymbols,
        RarityDistribution rarities
) {
}
