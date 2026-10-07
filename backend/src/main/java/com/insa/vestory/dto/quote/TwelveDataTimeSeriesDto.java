package com.insa.vestory.dto.quote;

import java.util.List;

public record TwelveDataTimeSeriesDto(

        List<TwelveDataTimeSeriesValueDto> values,

        String status,
        String message

) {
}