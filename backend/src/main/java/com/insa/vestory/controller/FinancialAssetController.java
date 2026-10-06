package com.insa.vestory.controller;

import com.insa.vestory.model.entity.FinancialAsset;
import com.insa.vestory.repository.FinancialAssetRepository;
import com.insa.vestory.service.FinancialAssetImportService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/financial-assets")
public class FinancialAssetController {

    private final FinancialAssetRepository financialAssetRepository;
    private final FinancialAssetImportService importService;

    public FinancialAssetController(
            FinancialAssetRepository financialAssetRepository,
            FinancialAssetImportService importService
    ) {
        this.financialAssetRepository = financialAssetRepository;
        this.importService = importService;
    }

    @GetMapping
    public List<FinancialAsset> getAll() {
        return financialAssetRepository.findAll();
    }

    @GetMapping("/count")
    public Map<String, Long> count() {
        return Map.of("count", financialAssetRepository.count());
    }

    @PostMapping("/import")
    public ResponseEntity<Map<String, Object>> importFinancialAssets() throws Exception {
        long before = financialAssetRepository.count();
        importService.importAll();
        long after = financialAssetRepository.count();

        return ResponseEntity.ok(Map.of("before", before, "after", after, "imported", after - before)
        );
    }

    @DeleteMapping
    public ResponseEntity<Map<String, Long>> deleteAll() {
        long count = financialAssetRepository.count();
        financialAssetRepository.deleteAllInBatch();

        return ResponseEntity.ok(
                Map.of("deleted", count, "remaining", financialAssetRepository.count())
        );
    }
}