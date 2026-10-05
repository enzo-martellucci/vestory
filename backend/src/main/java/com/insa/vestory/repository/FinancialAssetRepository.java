package com.insa.vestory.repository;

import com.insa.vestory.model.entity.FinancialAsset;
import com.insa.vestory.model.enums.AssetType;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;
import java.util.UUID;

public interface FinancialAssetRepository extends JpaRepository<FinancialAsset, UUID> {

    Optional<FinancialAsset> findBySymbolAndAssetType(String symbol, AssetType assetType);
    boolean existsBySymbolAndAssetType(String symbol, AssetType assetType);
}