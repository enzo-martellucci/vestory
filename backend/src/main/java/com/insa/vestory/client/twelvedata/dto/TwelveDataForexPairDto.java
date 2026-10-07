package com.insa.vestory.client.twelvedata.dto;

import com.fasterxml.jackson.annotation.JsonProperty;

public record TwelveDataForexPairDto(

        String symbol,

        @JsonProperty("currency_group")
        String currencyGroup,

        @JsonProperty("currency_base")
        String currencyBase,

        @JsonProperty("currency_quote")
        String currencyQuote

) {
}