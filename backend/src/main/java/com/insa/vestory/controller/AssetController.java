package com.insa.vestory.controller;

import com.insa.vestory.dto.asset.AssetCountDto;
import com.insa.vestory.dto.asset.AssetDeleteResult;
import com.insa.vestory.dto.asset.AssetImportResult;
import com.insa.vestory.dto.asset.AssetResponseDto;
import com.insa.vestory.service.asset.FinancialAssetService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/assets")
@RequiredArgsConstructor
public class AssetController {

    private final FinancialAssetService financialAssetService;

    @GetMapping
    public List<AssetResponseDto> getAll() {
        return financialAssetService.getAll();
    }

    @GetMapping("/count")
    public AssetCountDto count() {
        return financialAssetService.count();
    }

    @PostMapping("/import")
    public AssetImportResult importFinancialAssets() {
        return financialAssetService.importAll();
    }

    @DeleteMapping
    public AssetDeleteResult deleteAll() {
        return financialAssetService.deleteAll();
    }
}
