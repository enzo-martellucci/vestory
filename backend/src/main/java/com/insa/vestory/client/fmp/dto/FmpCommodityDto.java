package com.insa.vestory.client.fmp.dto;

public record FmpCommodityDto(
        String symbol,
        String name,
        String exchange,
        String tradeMonth,
        String currency
) {
}