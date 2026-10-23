package com.insa.vestory.repository;

import com.insa.vestory.constant.AssetType;
import com.insa.vestory.entity.Asset;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface AssetRepository extends JpaRepository<Asset, Long> {

    boolean existsBySymbolAndType(String symbol, AssetType type);

    List<Asset> findAllByOrderByIdAsc();
}
