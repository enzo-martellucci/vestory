package com.insa.vestory.repository;

import com.insa.vestory.model.entity.AssetCard;
import org.springframework.data.jpa.repository.EntityGraph;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.UUID;

public interface AssetCardRepository extends JpaRepository<AssetCard, UUID> {

    @Override
    @EntityGraph(attributePaths = "financialAsset")
    List<AssetCard> findAll();

    @EntityGraph(attributePaths = "financialAsset")
    List<AssetCard> findAllByOrderByCollectionNumberAsc();

    @EntityGraph(attributePaths = "financialAsset")
    List<AssetCard> findAllByOrderByRarityScoreDesc();
}
