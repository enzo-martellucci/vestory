package com.insa.vestory.service.asset;

import com.insa.vestory.dto.asset.AssetResponseDto;
import com.insa.vestory.mapper.AssetMapper;
import com.insa.vestory.repository.AssetRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@RequiredArgsConstructor
public class AssetService {

    private final AssetRepository assetRepository;
    private final AssetImportService assetImportService;
    private final AssetMapper assetMapper;

    @Transactional(readOnly = true)
    public List<AssetResponseDto> getAll() {
        return assetMapper.toResponses(assetRepository.findAllByOrderBySymbolAsc());
    }

    public void importAll() {
        assetImportService.importAll();
    }

    @Transactional
    public void deleteAll() {
        assetRepository.deleteAllInBatch();
    }
}
