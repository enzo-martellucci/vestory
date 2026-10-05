//package com.insa.vestory.model.entity;
//
//import com.insa.vestory.model.enums.InvestmentTransactionType;
//import jakarta.persistence.*;
//import lombok.Getter;
//import lombok.NoArgsConstructor;
//import lombok.Setter;
//
//import java.math.BigDecimal;
//import java.time.Instant;
//import java.util.UUID;
//
//@Entity
//@Getter
//@Setter
//@NoArgsConstructor
//@Table(
//        name = "investment_transactions",
//        indexes = {
//                @Index(
//                        name = "idx_transaction_portfolio",
//                        columnList = "portfolio_id"
//                ),
//                @Index(
//                        name = "idx_transaction_asset",
//                        columnList = "financial_asset_id"
//                )
//        }
//)
//public class InvestmentTransaction {
//
//    @Id
//    @GeneratedValue(strategy = GenerationType.UUID)
//    private UUID id;
//
//    @ManyToOne(fetch = FetchType.LAZY, optional = false)
//    @JoinColumn(name = "portfolio_id", nullable = false)
//    private Portfolio portfolio;
//
//    @ManyToOne(fetch = FetchType.LAZY, optional = false)
//    @JoinColumn(name = "financial_asset_id", nullable = false)
//    private FinancialAsset financialAsset;
//
//    @Enumerated(EnumType.STRING)
//    @Column(nullable = false, length = 10)
//    private InvestmentTransactionType type;
//
//    // Quantité achetée ou vendue.
//    @Column(
//            nullable = false,
//            precision = 30,
//            scale = 12
//    )
//    private BigDecimal quantity;
//
//    // Prix d'une unité au moment de la transaction.
//    @Column(
//            name = "unit_price",
//            nullable = false,
//            precision = 24,
//            scale = 10
//    )
//    private BigDecimal unitPrice;
//
//    // Montant total de la transaction.
//    // Exemple : 0.5 × 200 € = 100 €
//    @Column(
//            name = "total_amount",
//            nullable = false,
//            precision = 19,
//            scale = 4
//    )
//    private BigDecimal totalAmount;
//
//    // Devise utilisée pour la transaction.
//    @Column(nullable = false, length = 10)
//    private String currency;
//
//    @Column(name = "executed_at", nullable = false)
//    private Instant executedAt;
//
//    @PrePersist
//    public void onCreate() {
//        executedAt = Instant.now();
//    }
//}