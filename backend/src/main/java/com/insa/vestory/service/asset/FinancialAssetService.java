package com.insa.vestory.service.asset;

import com.insa.vestory.dto.asset.AssetCountDto;
import com.insa.vestory.dto.asset.AssetDeleteResult;
import com.insa.vestory.dto.asset.AssetImportResult;
import com.insa.vestory.dto.asset.AssetResponseDto;
import com.insa.vestory.mapper.AssetMapper;
import com.insa.vestory.repository.AssetRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@RequiredArgsConstructor
public class FinancialAssetService {

    private final AssetRepository assetRepository;
    private final FinancialAssetImportService financialAssetImportService;
    private final AssetMapper assetMapper;

    @Transactional(readOnly = true)
    public List<AssetResponseDto> getAll() {
        return assetMapper.toResponses(assetRepository.findAllByOrderBySymbolAsc());
    }

    public AssetCountDto count() {
        return new AssetCountDto(assetRepository.count());
    }

    public AssetImportResult importAll() {
        long before = assetRepository.count();
        financialAssetImportService.importAll();
        long after = assetRepository.count();
        return new AssetImportResult(before, after, after - before);
    }

    @Transactional
    public AssetDeleteResult deleteAll() {
        long count = assetRepository.count();
        assetRepository.deleteAllInBatch();
        return new AssetDeleteResult(count, assetRepository.count());
    }
}
