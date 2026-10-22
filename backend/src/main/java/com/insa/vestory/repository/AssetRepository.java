package com.insa.vestory.repository;

import com.insa.vestory.constant.AssetType;
import com.insa.vestory.entity.Asset;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.UUID;

public interface AssetRepository extends JpaRepository<Asset, UUID> {

    boolean existsBySymbolAndAssetType(String symbol, AssetType assetType);

    List<Asset> findAllByEnabledTrueOrderBySymbolAsc();

    List<Asset> findAllByOrderBySymbolAsc();
}
