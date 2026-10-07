package com.insa.vestory.dto.quote;

import java.util.List;
import java.util.UUID;

public record FinancialHistoryDto(

        UUID financialAssetId,
        String symbol,
        String currency, List<FinancialHistoryPointDto> points

) {
}