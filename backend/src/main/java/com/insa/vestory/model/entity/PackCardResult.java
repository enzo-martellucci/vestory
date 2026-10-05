package com.insa.vestory.model.entity;

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
        name = "pack_card_results",
        uniqueConstraints = {
                @UniqueConstraint(
                        name = "uk_pack_card_slot",
                        columnNames = {"user_pack_id", "slot_index"}
                )
        }
)
public class PackCardResult {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "user_pack_id", nullable = false)
    private UserPack userPack;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "card_id", nullable = false)
    private Card card;

    // Position de la carte dans le pack : 1, 2 ou 3.
    @Column(name = "slot_index", nullable = false)
    private int slotIndex;

    // true si le joueur possédait déjà la carte.
    @Column(nullable = false)
    private boolean duplicate;

    // Nombre de Gemmes obtenues si doublon.
    @Column(name = "gems_awarded", nullable = false)
    private int gemsAwarded = 0;

    @Column(name = "created_at", nullable = false)
    private Instant createdAt;

    @PrePersist
    public void onCreate() {
        createdAt = Instant.now();
    }
}