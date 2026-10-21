package com.insa.vestory.entity;

import com.insa.vestory.constant.AssetType;
import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;

import java.time.Instant;
import java.util.UUID;

@Entity
@Getter
@Setter
@Table(
    indexes = {
        @Index(name = "idx_asset_symbol", columnList = "symbol"),
        @Index(name = "idx_asset_type", columnList = "asset_type")
    }
)
public class Asset {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    @Column(nullable = false, length = 50)
    private String symbol;

    @Column(nullable = false)
    private String name;

    @Column(length = 10)
    private String micCode;

    @Column(length = 150)
    private String industry;

    @Column(length = 500)
    private String website;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 30)
    private AssetType assetType;

    @Column(length = 100)
    private String exchange;

    @Column(length = 100)
    private String country;

    @Column(length = 10)
    private String currency;

    @Column(length = 100)
    private String sector;

    @Column(columnDefinition = "TEXT")
    private String description;

    @Column(length = 500)
    private String logoUrl;

    @Column(nullable = false)
    private boolean enabled = true;

    @Column(nullable = false)
    @CreationTimestamp
    private Instant createdAt;

    @Column(nullable = false)
    @UpdateTimestamp
    private Instant updatedAt;
}