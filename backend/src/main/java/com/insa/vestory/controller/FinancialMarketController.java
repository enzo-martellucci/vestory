package com.insa.vestory.controller;

import com.insa.vestory.dto.quote.FinancialHistoryDto;
import com.insa.vestory.dto.quote.FinancialQuoteDto;
import com.insa.vestory.service.quote.MarketDataService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/market")
@RequiredArgsConstructor
public class FinancialMarketController {

    private final MarketDataService marketDataService;

    @GetMapping("/assets/{id}/quote")
    public FinancialQuoteDto getQuote(@PathVariable Long id) {
        return marketDataService.getQuote(id);
    }

    @GetMapping("/assets/{id}/history")
    public FinancialHistoryDto getHistory(@PathVariable Long id) {
        return marketDataService.getHistory(id);
    }
}
