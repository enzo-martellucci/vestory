package com.insa.vestory.repository;

import com.insa.vestory.entity.RefreshToken;
import com.insa.vestory.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;

import java.time.Instant;
import java.util.Optional;
import java.util.UUID;

public interface RefreshTokenRepository extends JpaRepository<RefreshToken, UUID> {

    Optional<RefreshToken> findByTokenHash(String tokenHash);

    @Modifying
    @Query("update RefreshToken t set t.revokedAt = :revokedAt where t.user = :user and t.revokedAt is null")
    void revokeAllActiveByUser(User user, Instant revokedAt);
}
