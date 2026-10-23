package com.insa.vestory.repository;

import com.insa.vestory.entity.UserAsset;
import org.springframework.data.jpa.repository.EntityGraph;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

public interface UserAssetRepository extends JpaRepository<UserAsset, UUID> {

    Optional<UserAsset> findByUserIdAndAssetId(UUID userId, Long assetId);

    @EntityGraph(attributePaths = "asset")
    List<UserAsset> findAllByUserIdOrderByAssetIdAsc(UUID userId);
}
