package com.insa.vestory.dto.quote;

import java.util.List;

public record FinancialHistoryDto(

        Long financialAssetId,
        String symbol,
        String currency, List<FinancialHistoryPointDto> points

) {
}