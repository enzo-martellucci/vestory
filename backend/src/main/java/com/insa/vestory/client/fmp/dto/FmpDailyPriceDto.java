package com.insa.vestory.client.fmp.dto;

import java.math.BigDecimal;

public record FmpDailyPriceDto(
        String symbol,
        String date,
        BigDecimal price,
        BigDecimal volume
) {
}
