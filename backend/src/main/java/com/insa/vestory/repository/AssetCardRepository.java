package com.insa.vestory.repository;

import com.insa.vestory.model.entity.AssetCard;

import org.springframework.data.jpa.repository.JpaRepository;

import java.util.UUID;

public interface AssetCardRepository extends JpaRepository<AssetCard, UUID> {
}