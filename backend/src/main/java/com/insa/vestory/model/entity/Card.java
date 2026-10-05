package com.insa.vestory.model.entity;

import com.insa.vestory.model.enums.CardRarity;
import jakarta.persistence.*;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.time.Instant;
import java.util.UUID;

@Entity
@Getter
@Setter
@NoArgsConstructor
@Table(
        name = "cards",
        uniqueConstraints = {
                @UniqueConstraint(
                        name = "uk_card_financial_asset",
                        columnNames = "financial_asset_id"
                )
        },
        indexes = {
                @Index(name = "idx_card_rarity", columnList = "rarity")
        }
)
public class Card {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    // Actif représenté par la carte.
    @OneToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "financial_asset_id", nullable = false)
    private FinancialAsset financialAsset;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 20)
    private CardRarity rarity;

    @Column(nullable = false)
    private boolean enabled = true;

    @Column(name = "created_at", nullable = false)
    private Instant createdAt;

    @Column(name = "updated_at", nullable = false)
    private Instant updatedAt;

    @PrePersist
    public void onCreate() {
        Instant now = Instant.now();
        createdAt = now;
        updatedAt = now;
    }

    @PreUpdate
    public void onUpdate() {
        updatedAt = Instant.now();
    }
}