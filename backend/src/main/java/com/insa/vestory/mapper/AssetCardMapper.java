package com.insa.vestory.mapper;

import com.insa.vestory.dto.card.AssetCardResponseDto;
import com.insa.vestory.model.entity.AssetCard;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;

import java.util.List;

@Mapper
public interface AssetCardMapper {

    @Mapping(target = "financialAssetId", source = "financialAsset.id")
    @Mapping(target = "symbol", source = "financialAsset.symbol")
    @Mapping(target = "name", source = "financialAsset.name")
    @Mapping(target = "assetType", source = "financialAsset.assetType")
    @Mapping(target = "logoUrl", source = "financialAsset.logoUrl")
    @Mapping(target = "description", source = "financialAsset.description")
    AssetCardResponseDto toResponse(AssetCard card);

    List<AssetCardResponseDto> toResponses(List<AssetCard> cards);
}
