package com.insa.vestory.client.twelvedata.dto;

import java.util.List;

public record TwelveDataForexPairsResponse(

        Integer count,

        List<TwelveDataForexPairDto> data,

        String status

) {
}