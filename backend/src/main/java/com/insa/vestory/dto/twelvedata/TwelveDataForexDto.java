package com.insa.vestory.dto.twelvedata;

import com.fasterxml.jackson.annotation.JsonProperty;

public record TwelveDataForexDto(
        String symbol,

        @JsonProperty("currency_group")
        String currencyGroup,

        @JsonProperty("currency_base")
        String currencyBase,

        @JsonProperty("currency_quote")
        String currencyQuote
) {
}