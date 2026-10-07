package com.insa.vestory.controller;

import com.insa.vestory.dto.card.AssetCardResponseDto;
import com.insa.vestory.dto.asset.CardGenerationResult;
import com.insa.vestory.dto.card.CardRarityUpdateResult;
import com.insa.vestory.service.card.AssetCardGenerationService;
import com.insa.vestory.service.card.AssetCardService;
import com.insa.vestory.service.card.CardRarityUpdateService;

import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/cards")
public class AssetCardController {

    private final AssetCardGenerationService assetCardGenerationService;
    private final AssetCardService assetCardService;
    private final CardRarityUpdateService cardRarityUpdateService;

    public AssetCardController(
            AssetCardGenerationService assetCardGenerationService,
            AssetCardService assetCardService,
            CardRarityUpdateService cardRarityUpdateService
    ) {

        this.assetCardGenerationService = assetCardGenerationService;
        this.assetCardService = assetCardService;
        this.cardRarityUpdateService = cardRarityUpdateService;
    }

    /* Crée les AssetCard manquantes. */
    @PostMapping("/sync")
    public CardGenerationResult syncCards() {
        return assetCardGenerationService.syncCards();
    }

    /* Recalcule uniquement les raretés. */
    @PostMapping("/rarities/sync")
    public CardRarityUpdateResult syncRarities() {
        return cardRarityUpdateService.syncRarities();
    }

    /* Liste les cartes. */
    @GetMapping
    public List<AssetCardResponseDto> getAllCards() {
        return assetCardService.getAllCards();
    }

    @GetMapping("/ranking")
    public List<AssetCardResponseDto> getCardsRanking() {
        return assetCardService.getCardsRanking();
    }
}