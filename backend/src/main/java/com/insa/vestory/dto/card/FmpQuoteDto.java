package com.insa.vestory.dto.card;

import java.math.BigDecimal;

public record FmpQuoteDto(

        String symbol,

        BigDecimal price,

        BigDecimal change,

        BigDecimal changePercentage,

        BigDecimal open,

        BigDecimal previousClose,

        BigDecimal dayLow,

        BigDecimal dayHigh,

        BigDecimal yearLow,

        BigDecimal yearHigh,

        BigDecimal volume,

        BigDecimal marketCap,

        Long timestamp

) {
}