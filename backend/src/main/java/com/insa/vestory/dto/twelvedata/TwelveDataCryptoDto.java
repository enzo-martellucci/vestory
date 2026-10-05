package com.insa.vestory.dto.twelvedata;

import com.fasterxml.jackson.annotation.JsonProperty;

import java.util.List;

public record TwelveDataCryptoDto(
        String symbol,

        @JsonProperty("available_exchanges")
        List<String> availableExchanges,

        @JsonProperty("currency_base")
        String currencyBase,

        @JsonProperty("currency_quote")
        String currencyQuote
) {
}