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
        name = "user_cards",
        uniqueConstraints = {
                @UniqueConstraint(
                        name = "uk_user_card",
                        columnNames = {"user_id", "card_id"}
                )
        },
        indexes = {
                @Index(name = "idx_user_card_user", columnList = "user_id")
        }
)
public class UserCard {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "user_id", nullable = false)
    private AppUser user;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "card_id", nullable = false)
    private Card card;

    // Date à laquelle le joueur a débloqué la carte.
    @Column(name = "obtained_at", nullable = false)
    private Instant obtainedAt;

    @PrePersist
    public void onCreate() {
        obtainedAt = Instant.now();
    }
}