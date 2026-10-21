package com.insa.vestory.entity;

import com.insa.vestory.constant.CardRarity;
import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

import java.time.Instant;
import java.util.UUID;

@Entity
@Getter
@Setter
public class Card {

    @Id
    @GeneratedValue
    private UUID id;

    @OneToOne(optional = false)
    @JoinColumn(name = "asset_id", unique = true, nullable = false)
    private Asset asset;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private CardRarity rarity;

    private double rarityScore;

    private int collectionNumber;

    private boolean enabled = true;

    private Instant createdAt;
}