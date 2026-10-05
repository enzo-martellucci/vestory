package com.insa.vestory.controller;

import com.insa.vestory.client.TwelveDataClient;
import com.insa.vestory.dto.twelvedata.*;
import com.insa.vestory.service.FinancialAssetImportService;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/twelve-data")
public class TwelveDataController {

    private final TwelveDataClient twelveDataClient;

    public TwelveDataController(
            TwelveDataClient twelveDataClient
    ) {
        this.twelveDataClient = twelveDataClient;
    }

    @GetMapping("/stock/{symbol}")
    public TwelveDataResponse<TwelveDataStockDto> getStock(
            @PathVariable String symbol,
            @RequestParam(required = false) String micCode
    ) {
        return twelveDataClient.getStock(symbol, micCode);
    }

    @GetMapping("/etf/{symbol}")
    public TwelveDataResponse<TwelveDataEtfDto> getEtf(
            @PathVariable String symbol,
            @RequestParam(required = false) String micCode
    ) {
        return twelveDataClient.getEtf(symbol, micCode);
    }

    @GetMapping("/crypto")
    public TwelveDataResponse<TwelveDataCryptoDto> getCrypto(
            @RequestParam String symbol
    ) {
        return twelveDataClient.getCrypto(symbol);
    }

    @GetMapping("/forex")
    public TwelveDataResponse<TwelveDataForexDto> getForex(
            @RequestParam String symbol
    ) {
        return twelveDataClient.getForex(symbol);
    }

    @GetMapping("/commodity")
    public TwelveDataResponse<TwelveDataCommodityDto> getCommodity(
            @RequestParam String symbol
    ) {
        return twelveDataClient.getCommodity(symbol);
    }


}