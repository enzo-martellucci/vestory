package com.insa.vestory.model.entity;

import com.insa.vestory.model.enums.CardRarity;
import com.insa.vestory.model.enums.PackTier;
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
        name = "pack_types",
        uniqueConstraints = {
                @UniqueConstraint(
                        name = "uk_pack_tier",
                        columnNames = "tier"
                )
        }
)
public class PackType {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 20)
    private PackTier tier;

    @Column(nullable = false, length = 100)
    private String name;

    // Prix du pack en Gemmes.
    @Column(name = "gem_cost", nullable = false)
    private int gemCost;

    // Nombre de cartes contenues dans le pack.
    @Column(name = "card_count", nullable = false)
    private int cardCount = 3;

    // Rareté minimale garantie dans ce pack.
    @Enumerated(EnumType.STRING)
    @Column(name = "minimum_guaranteed_rarity", length = 20)
    private CardRarity minimumGuaranteedRarity;

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