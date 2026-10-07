package com.insa.vestory.dto.quote;

import java.time.Instant;

public record FinancialHistoryPointDto(

        Instant timestamp,
        Double price

) {
}