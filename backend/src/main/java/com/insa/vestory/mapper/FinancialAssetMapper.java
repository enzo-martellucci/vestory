package com.insa.vestory.mapper;

import com.insa.vestory.dto.asset.FinancialAssetResponseDto;
import com.insa.vestory.model.entity.FinancialAsset;
import org.mapstruct.Mapper;

import java.util.List;

@Mapper
public interface FinancialAssetMapper {

    FinancialAssetResponseDto toResponse(FinancialAsset asset);

    List<FinancialAssetResponseDto> toResponses(List<FinancialAsset> assets);
}
