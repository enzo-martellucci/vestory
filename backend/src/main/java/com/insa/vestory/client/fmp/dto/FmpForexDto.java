package com.insa.vestory.client.fmp.dto;

public record FmpForexDto(
        String symbol,
        String fromCurrency,
        String toCurrency,
        String fromName,
        String toName
) {
}