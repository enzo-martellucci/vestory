package com.insa.vestory.repository;

import com.insa.vestory.entity.UserPack;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

public interface UserPackRepository extends JpaRepository<UserPack, UUID> {

    List<UserPack> findAllByUserIdAndOpenedAtIsNullOrderByObtainedAtAsc(UUID userId);

    Optional<UserPack> findByIdAndUserId(UUID id, UUID userId);
}