package com.insa.vestory.controller.test;

import com.insa.vestory.client.FmpClient;
import com.insa.vestory.dto.fmp.FmpCommodityDto;
import com.insa.vestory.dto.fmp.FmpCompanyProfileDto;
import com.insa.vestory.dto.fmp.FmpForexDto;
import org.springframework.web.bind.annotation.*;
import tools.jackson.databind.JsonNode;

import java.util.List;

@RestController
@RequestMapping("/api/test/fmp")
public class FmpController {

    private final FmpClient fmpClient;

    public FmpController(FmpClient fmpClient) {
        this.fmpClient = fmpClient;
    }

    @GetMapping("/{symbol}")
    public FmpCompanyProfileDto getProfile(
            @PathVariable String symbol
    ) {
        return fmpClient.getCompanyProfile(symbol);
    }

    @GetMapping("/forex")
    public List<FmpForexDto> getForex() {
        return fmpClient.getForexList();
    }

    @GetMapping("/commodities")
    public List<FmpCommodityDto> getCommodities() {
        return fmpClient.getCommodityList();
    }


}