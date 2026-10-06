package com.insa.vestory.dto.quote;

import com.fasterxml.jackson.annotation.JsonProperty;

public record TwelveDataQuoteDto(

        String symbol,
        String name,
        String exchange,

        @JsonProperty("mic_code")
        String micCode,

        String currency,
        String datetime,
        Long timestamp,

        String open,
        String high,
        String low,
        String close,
        String volume,

        @JsonProperty("previous_close")
        String previousClose,

        String change,

        @JsonProperty("percent_change")
        String percentChange,

        @JsonProperty("is_market_open")
        Boolean marketOpen,

        // Error handling fields
        Integer code,
        String status,
        String message

) {
}