package com.insa.vestory.repository;

import com.insa.vestory.model.entity.FinancialAsset;
import com.insa.vestory.model.enums.AssetType;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.UUID;

public interface FinancialAssetRepository extends JpaRepository<FinancialAsset, UUID> {

    boolean existsBySymbolAndAssetType(String symbol, AssetType assetType);

    List<FinancialAsset> findAllByEnabledTrueOrderBySymbolAsc();

    List<FinancialAsset> findAllByOrderBySymbolAsc();
}
