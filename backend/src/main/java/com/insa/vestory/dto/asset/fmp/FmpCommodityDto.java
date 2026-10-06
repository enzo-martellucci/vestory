package com.insa.vestory.dto.asset.fmp;

public record FmpCommodityDto(
        String symbol,
        String name,
        String exchange,
        String tradeMonth,
        String currency
) {
}