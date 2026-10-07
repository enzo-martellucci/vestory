package com.insa.vestory.controller;

import com.insa.vestory.dto.asset.FinancialAssetCountDto;
import com.insa.vestory.dto.asset.FinancialAssetDeleteResult;
import com.insa.vestory.dto.asset.FinancialAssetImportResult;
import com.insa.vestory.dto.asset.FinancialAssetResponseDto;
import com.insa.vestory.service.asset.FinancialAssetService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/api/financial-assets")
@RequiredArgsConstructor
public class FinancialAssetController {

    private final FinancialAssetService financialAssetService;

    @GetMapping
    public List<FinancialAssetResponseDto> getAll() {
        return financialAssetService.getAll();
    }

    @GetMapping("/count")
    public FinancialAssetCountDto count() {
        return financialAssetService.count();
    }

    @PostMapping("/import")
    public FinancialAssetImportResult importFinancialAssets() {
        return financialAssetService.importAll();
    }

    @DeleteMapping
    public FinancialAssetDeleteResult deleteAll() {
        return financialAssetService.deleteAll();
    }
}
