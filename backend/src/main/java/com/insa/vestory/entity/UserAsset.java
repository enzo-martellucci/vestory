package com.insa.vestory.entity;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

import java.time.Instant;
import java.util.UUID;

@Entity
@Table(
    name = "user_assets",
    uniqueConstraints = @UniqueConstraint(
        columnNames = {"user_id", "asset_id"}
    )
)
@Getter
@Setter
public class UserAsset {

    @Id
    @GeneratedValue
    private UUID id;

    @ManyToOne(optional = false)
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    @ManyToOne(optional = false)
    @JoinColumn(name = "asset_id", nullable = false)
    private Asset asset;

    private int quantity;

    private boolean favorite;

    private Instant firstObtainedAt;

    private Instant lastObtainedAt;
}
