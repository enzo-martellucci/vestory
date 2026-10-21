package com.insa.vestory.model.entity;

import com.insa.vestory.entity.User;
import com.insa.vestory.model.enums.PackSource;
import com.insa.vestory.model.enums.PackType;
import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

import java.time.Instant;
import java.util.UUID;

@Entity
@Table(name = "user_packs")
@Getter
@Setter
public class UserPack {

    @Id
    @GeneratedValue
    private UUID id;

    @ManyToOne(optional = false, fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 20)
    private PackType type;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 20)
    private PackSource source;

    @Column(nullable = false)
    private Instant obtainedAt;

    private Instant openedAt;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "asset_card_id")
    private AssetCard card;
}