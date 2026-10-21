package com.insa.vestory.mapper;

import com.insa.vestory.dto.asset.AssetResponseDto;
import com.insa.vestory.entity.Asset;
import org.mapstruct.Mapper;

import java.util.List;

@Mapper
public interface AssetMapper {

    AssetResponseDto toResponse(Asset asset);

    List<AssetResponseDto> toResponses(List<Asset> assets);
}
