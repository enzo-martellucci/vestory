package com.insa.vestory.service.card;
import com.insa.vestory.dto.asset.AssetCardResponseDto;
import com.insa.vestory.model.entity.AssetCard;
import com.insa.vestory.model.entity.FinancialAsset;
import com.insa.vestory.repository.AssetCardRepository;
import org.springframework.stereotype.Service;

import java.util.List;

// lit les cartes déjà créées
@Service
public class AssetCardService {

    private final AssetCardRepository assetCardRepository;

    public AssetCardService(AssetCardRepository assetCardRepository) {
        this.assetCardRepository = assetCardRepository;
    }

    public List<AssetCardResponseDto> getAllCards() {

        return assetCardRepository.findAll().stream().map(card -> {

                    FinancialAsset asset = card.getFinancialAsset();

                    return new AssetCardResponseDto(
                            card.getId(),
                            card.getCollectionNumber(),
                            card.getRarity(),
                            card.getRarityScore(),
                            card.isEnabled(),

                            asset.getId(),
                            asset.getSymbol(),
                            asset.getName(),
                            asset.getAssetType(),
                            asset.getLogoUrl()
                    );
                })
                .toList();
    }

    public List<AssetCardResponseDto> getCardsRanking() {

        return assetCardRepository
                .findAll()
                .stream()
                .sorted(
                        java.util.Comparator
                                .comparingDouble(
                                        AssetCard::getRarityScore
                                )
                                .reversed()
                )
                .map(card -> {

                    FinancialAsset asset =
                            card.getFinancialAsset();

                    return new AssetCardResponseDto(
                            card.getId(),
                            card.getCollectionNumber(),
                            card.getRarity(),
                            card.getRarityScore(),
                            card.isEnabled(),

                            asset.getId(),
                            asset.getSymbol(),
                            asset.getName(),
                            asset.getAssetType(),
                            asset.getLogoUrl()
                    );
                })
                .toList();
    }
}
