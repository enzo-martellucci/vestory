package com.insa.vestory.dto.twelvedata;

import com.fasterxml.jackson.annotation.JsonProperty;

public record TwelveDataStockDto(
        String symbol,
        String name,
        String currency,
        String exchange,

        @JsonProperty("mic_code")
        String micCode,

        String country,
        String type
) {
}
