package com.insa.vestory.model.entity;
import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

import java.time.Instant;
import java.util.UUID;

@Entity
@Table(
        name = "user_cards",
        uniqueConstraints = @UniqueConstraint(
                columnNames = {"user_id", "asset_card_id"}
        )
)
@Getter @Setter
public class UserCard {

    @Id
    @GeneratedValue
    private UUID id;

    @ManyToOne(optional = false)
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    @ManyToOne(optional = false)
    @JoinColumn(name = "asset_card_id", nullable = false)
    private AssetCard card;

    private int quantity;

    private boolean favorite;

    private Instant firstObtainedAt;

    private Instant lastObtainedAt;
}