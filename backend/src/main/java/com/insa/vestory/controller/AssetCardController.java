package com.insa.vestory.controller;

import com.insa.vestory.dto.card.AssetCardResponseDto;
import com.insa.vestory.dto.card.CardGenerationResult;
import com.insa.vestory.dto.card.CardRarityUpdateResult;
import com.insa.vestory.service.card.AssetCardService;
import com.insa.vestory.service.card.CardSyncService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/api/cards")
@RequiredArgsConstructor
public class AssetCardController {

    private final AssetCardService assetCardService;
    private final CardSyncService cardSyncService;

    @GetMapping
    public List<AssetCardResponseDto> getAllCards() {
        return assetCardService.getAllCards();
    }

    @GetMapping("/ranking")
    public List<AssetCardResponseDto> getCardsRanking() {
        return assetCardService.getCardsRanking();
    }

    @PostMapping("/sync")
    public CardGenerationResult syncCards() {
        return cardSyncService.syncCards();
    }

    @PostMapping("/rarities/sync")
    public CardRarityUpdateResult syncRarities() {
        return cardSyncService.syncRarities();
    }
}
