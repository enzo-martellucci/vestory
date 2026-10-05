package com.insa.vestory.model.entity;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.math.BigDecimal;
import java.time.Instant;
import java.util.UUID;

@Entity
@Getter
@Setter
@NoArgsConstructor
@Table(
        name = "portfolio_positions",
        uniqueConstraints = {
                @UniqueConstraint(
                        name = "uk_portfolio_asset",
                        columnNames = {
                                "portfolio_id",
                                "financial_asset_id"
                        }
                )
        },
        indexes = {
                @Index(
                        name = "idx_portfolio_position_portfolio",
                        columnList = "portfolio_id"
                )
        }
)
public class PortfolioPosition {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "portfolio_id", nullable = false)
    private Portfolio portfolio;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "financial_asset_id", nullable = false)
    private FinancialAsset financialAsset;

    // Quantité actuellement possédée.
    // Peut être fractionnaire : 0.5 action, 0.001 BTC...
    @Column(
            nullable = false,
            precision = 30,
            scale = 12
    )
    private BigDecimal quantity = BigDecimal.ZERO;

    // Prix moyen d'achat d'une unité de l'actif.
    @Column(
            name = "average_buy_price",
            nullable = false,
            precision = 24,
            scale = 10
    )
    private BigDecimal averageBuyPrice = BigDecimal.ZERO;

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