package com.insa.vestory.model.entity;

import com.insa.vestory.model.enums.CardRarity;
import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

import java.time.Instant;
import java.util.UUID;

@Entity
@Table(name = "asset_cards")
@Getter
@Setter
public class AssetCard {

    @Id
    @GeneratedValue
    private UUID id;

    @OneToOne(optional = false)
    @JoinColumn(name = "financial_asset_id", unique = true, nullable = false)
    private FinancialAsset financialAsset;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private CardRarity rarity;

    private double rarityScore;

    private int collectionNumber;

    private boolean enabled = true;

    private Instant createdAt;
}