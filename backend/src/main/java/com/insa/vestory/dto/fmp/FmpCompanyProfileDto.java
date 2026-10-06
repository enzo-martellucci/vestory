package com.insa.vestory.dto.fmp;

public record FmpCompanyProfileDto(

        String symbol,
        String companyName,

        String currency,

        String exchange,
        String exchangeFullName,

        String industry,
        String sector,

        String website,
        String description,

        String country,

        String image,

        String isin,
        String cusip,
        String cik,

        String ipoDate,

        boolean isEtf,
        boolean isActivelyTrading,
        boolean isAdr,
        boolean isFund

) {
}