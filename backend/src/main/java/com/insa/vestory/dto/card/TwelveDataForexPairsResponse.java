package com.insa.vestory.dto.card;

import java.util.List;

public record TwelveDataForexPairsResponse(

        Integer count,

        List<TwelveDataForexPairDto> data,

        String status

) {
}