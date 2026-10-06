package com.insa.vestory.controller;

import com.insa.vestory.dto.quote.FinancialQuoteDto;
import com.insa.vestory.service.quote.FinancialMarketService;

import org.springframework.web.bind.annotation.*;

import java.util.UUID;

@RestController
@RequestMapping("/api/market")
public class FinancialMarketController {

    private final FinancialMarketService financialMarketService;

    public FinancialMarketController(
            FinancialMarketService financialMarketService
    ) {

        this.financialMarketService =
                financialMarketService;
    }

    @GetMapping("/assets/{financialAssetId}/quote")
    public FinancialQuoteDto getQuote(
            @PathVariable UUID financialAssetId
    ) {

        return financialMarketService
                .getQuote(
                        financialAssetId
                );
    }
}