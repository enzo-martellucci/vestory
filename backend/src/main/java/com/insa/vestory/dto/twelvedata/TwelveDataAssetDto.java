package com.insa.vestory.dto.twelvedata;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class TwelveDataAssetDto {

    private String symbol;
    private String name;

    private String currency;
    private String exchange;
    private String country;

    private String type;

    private String currency_base;
    private String currency_quote;

    private String category;
    private String description;
}