package com.insa.vestory.service.card;

import com.insa.vestory.dto.card.CardResponseDto;
import com.insa.vestory.mapper.CardMapper;
import com.insa.vestory.repository.CardRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@RequiredArgsConstructor
public class CardService {

    private final CardRepository cardRepository;
    private final CardMapper cardMapper;

    @Transactional(readOnly = true)
    public List<CardResponseDto> getAllCards() {
        return cardMapper.toResponses(cardRepository.findAllByOrderByCollectionNumberAsc());
    }

    @Transactional(readOnly = true)
    public List<CardResponseDto> getCardsRanking() {
        return cardMapper.toResponses(cardRepository.findAllByOrderByRarityScoreDesc());
    }
}
