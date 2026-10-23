package com.insa.vestory.entity;

import com.insa.vestory.constant.AssetType;
import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

@Entity
@Getter
@Setter
@Table(
    indexes = {
        @Index(name = "idx_asset_symbol", columnList = "symbol"),
        @Index(name = "idx_asset_type", columnList = "type")
    }
)
public class Asset {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, length = 50)
    private String symbol;

    @Column(nullable = false)
    private String name;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 30)
    private AssetType type;

    @Column(length = 10)
    private String micCode;

    @Column(length = 100)
    private String exchange;

    @Column(length = 100)
    private String country;

    @Column(length = 10)
    private String currency;

    @Column(length = 100)
    private String sector;

    @Column(length = 150)
    private String industry;

    @Column(columnDefinition = "TEXT")
    private String description;

    @Column(length = 500)
    private String logoUrl;
}
