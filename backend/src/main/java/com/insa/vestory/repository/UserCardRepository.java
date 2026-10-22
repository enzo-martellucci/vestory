package com.insa.vestory.repository;

import com.insa.vestory.entity.UserCard;
import org.springframework.data.jpa.repository.EntityGraph;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

public interface UserCardRepository extends JpaRepository<UserCard, UUID> {

    Optional<UserCard> findByUserIdAndCardId(UUID userId, UUID cardId);

    @EntityGraph(attributePaths = {"card", "card.asset"})
    List<UserCard> findAllByUserIdOrderByCardCollectionNumberAsc(UUID userId);
}