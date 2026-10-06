package com.insa.vestory.dto.card;

import java.util.List;

public record CardRarityUpdateResult(

        int total,
        int updated,

        int common,
        int rare,
        int epic,
        int legendary,

        int marketDataAvailable,
        int marketDataUnavailable,

        List<String> unavailableSymbols

) {
}