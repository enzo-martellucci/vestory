package com.insa.vestory.service.asset;

import com.insa.vestory.dto.asset.FinancialAssetCountDto;
import com.insa.vestory.dto.asset.FinancialAssetDeleteResult;
import com.insa.vestory.dto.asset.FinancialAssetImportResult;
import com.insa.vestory.dto.asset.FinancialAssetResponseDto;
import com.insa.vestory.mapper.FinancialAssetMapper;
import com.insa.vestory.repository.FinancialAssetRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@RequiredArgsConstructor
public class FinancialAssetService {

    private final FinancialAssetRepository financialAssetRepository;
    private final FinancialAssetImportService financialAssetImportService;
    private final FinancialAssetMapper financialAssetMapper;

    @Transactional(readOnly = true)
    public List<FinancialAssetResponseDto> getAll() {
        return financialAssetMapper.toResponses(financialAssetRepository.findAllByOrderBySymbolAsc());
    }

    public FinancialAssetCountDto count() {
        return new FinancialAssetCountDto(financialAssetRepository.count());
    }

    public FinancialAssetImportResult importAll() {
        long before = financialAssetRepository.count();
        financialAssetImportService.importAll();
        long after = financialAssetRepository.count();
        return new FinancialAssetImportResult(before, after, after - before);
    }

    @Transactional
    public FinancialAssetDeleteResult deleteAll() {
        long count = financialAssetRepository.count();
        financialAssetRepository.deleteAllInBatch();
        return new FinancialAssetDeleteResult(count, financialAssetRepository.count());
    }
}
