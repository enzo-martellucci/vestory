package com.insa.vestory.mapper;

import com.insa.vestory.dto.card.CardResponseDto;
import com.insa.vestory.entity.Card;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;

import java.util.List;

@Mapper
public interface CardMapper {

    @Mapping(target = "assetId", source = "asset.id")
    @Mapping(target = "symbol", source = "asset.symbol")
    @Mapping(target = "name", source = "asset.name")
    @Mapping(target = "assetType", source = "asset.assetType")
    @Mapping(target = "country", source = "asset.country")
    @Mapping(target = "sector", source = "asset.sector")
    @Mapping(target = "logoUrl", source = "asset.logoUrl")
    @Mapping(target = "description", source = "asset.description")
    CardResponseDto toResponse(Card card);

    List<CardResponseDto> toResponses(List<Card> cards);
}
