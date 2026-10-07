package com.insa.vestory.controller;

import com.insa.vestory.dto.quote.FinancialHistoryDto;
import com.insa.vestory.dto.quote.FinancialQuoteDto;
import com.insa.vestory.service.quote.MarketDataService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.UUID;

@RestController
@RequestMapping("/api/market")
@RequiredArgsConstructor
public class FinancialMarketController {

    private final MarketDataService marketDataService;

    @GetMapping("/assets/{financialAssetId}/quote")
    public FinancialQuoteDto getQuote(@PathVariable UUID financialAssetId) {
        return marketDataService.getQuote(financialAssetId);
    }

    @GetMapping("/assets/{financialAssetId}/history")
    public FinancialHistoryDto getHistory(@PathVariable UUID financialAssetId) {
        return marketDataService.getHistory(financialAssetId);
    }
}
