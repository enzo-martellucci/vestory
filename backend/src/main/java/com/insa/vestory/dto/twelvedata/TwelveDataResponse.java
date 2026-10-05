package com.insa.vestory.dto.twelvedata;

import java.util.List;

public record TwelveDataResponse<T>(
        List<T> data,
        int count,
        String status
) {
}
