package com.insa.vestory.repository;

import com.insa.vestory.model.entity.PlayerProfile;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;
import java.util.UUID;

public interface PlayerProfileRepository extends JpaRepository<PlayerProfile, UUID> {

    Optional<PlayerProfile> findByUserId(UUID userId);
}