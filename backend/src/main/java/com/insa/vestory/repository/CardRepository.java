package com.insa.vestory.repository;

import com.insa.vestory.entity.Card;
import org.springframework.data.jpa.repository.EntityGraph;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.UUID;

public interface CardRepository extends JpaRepository<Card, UUID> {

    @Override
    @EntityGraph(attributePaths = "asset")
    List<Card> findAll();

    @EntityGraph(attributePaths = "asset")
    List<Card> findAllByOrderByCollectionNumberAsc();

    @EntityGraph(attributePaths = "asset")
    List<Card> findAllByOrderByRarityScoreDesc();
}
