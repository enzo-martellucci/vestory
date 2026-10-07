package com.insa.vestory.client.twelvedata.dto;

import java.util.List;

public record TwelveDataTimeSeriesDto(

        List<TwelveDataTimeSeriesValueDto> values,

        String status,
        String message

) {
}