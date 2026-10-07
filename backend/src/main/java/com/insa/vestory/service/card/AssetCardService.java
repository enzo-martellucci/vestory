package com.insa.vestory.service.card;

import com.insa.vestory.dto.card.AssetCardResponseDto;
import com.insa.vestory.mapper.AssetCardMapper;
import com.insa.vestory.repository.AssetCardRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@RequiredArgsConstructor
public class AssetCardService {

    private final AssetCardRepository assetCardRepository;
    private final AssetCardMapper assetCardMapper;

    @Transactional(readOnly = true)
    public List<AssetCardResponseDto> getAllCards() {
        return assetCardMapper.toResponses(assetCardRepository.findAllByOrderByCollectionNumberAsc());
    }

    @Transactional(readOnly = true)
    public List<AssetCardResponseDto> getCardsRanking() {
        return assetCardMapper.toResponses(assetCardRepository.findAllByOrderByRarityScoreDesc());
    }
}
