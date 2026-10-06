package com.insa.vestory.repository;

import com.insa.vestory.entity.AuthProvider;
import com.insa.vestory.entity.Identity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.util.Optional;
import java.util.UUID;

public interface IdentityRepository extends JpaRepository<Identity, UUID> {

    @Query("select i from Identity i join fetch i.user u where i.provider = :provider and (u.username = :identifier or u.email = :identifier)")
    Optional<Identity> findByProviderAndIdentifier(AuthProvider provider, String identifier);
}
