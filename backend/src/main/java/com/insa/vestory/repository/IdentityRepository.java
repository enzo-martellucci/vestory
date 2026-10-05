package com.insa.vestory.repository;

import com.insa.vestory.entity.Identity;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.UUID;

public interface IdentityRepository extends JpaRepository<Identity, UUID> {
}
