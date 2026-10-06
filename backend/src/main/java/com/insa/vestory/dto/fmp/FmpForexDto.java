package com.insa.vestory.dto.fmp;

public record FmpForexDto(
        String symbol,
        String fromCurrency,
        String toCurrency,
        String fromName,
        String toName
) {
}