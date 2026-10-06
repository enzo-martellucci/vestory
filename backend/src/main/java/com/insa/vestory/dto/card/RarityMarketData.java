package com.insa.vestory.dto.card;

import java.math.BigDecimal;

public record RarityMarketData(
        BigDecimal marketCap,
        BigDecimal volume
) {
}