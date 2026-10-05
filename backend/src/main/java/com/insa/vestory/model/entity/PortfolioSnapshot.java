//package com.insa.vestory.model.entity;
//
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
//        name = "portfolio_snapshots",
//        indexes = {
//                @Index(
//                        name = "idx_portfolio_snapshot_portfolio",
//                        columnList = "portfolio_id"
//                ),
//                @Index(
//                        name = "idx_portfolio_snapshot_date",
//                        columnList = "captured_at"
//                )
//        }
//)
//public class PortfolioSnapshot {
//
//    @Id
//    @GeneratedValue(strategy = GenerationType.UUID)
//    private UUID id;
//
//    @ManyToOne(fetch = FetchType.LAZY, optional = false)
//    @JoinColumn(name = "portfolio_id", nullable = false)
//    private Portfolio portfolio;
//
//    // Argent disponible au moment du snapshot.
//    @Column(
//            name = "cash_value",
//            nullable = false,
//            precision = 19,
//            scale = 4
//    )
//    private BigDecimal cashValue;
//
//    // Valeur totale des actifs détenus.
//    @Column(
//            name = "assets_value",
//            nullable = false,
//            precision = 19,
//            scale = 4
//    )
//    private BigDecimal assetsValue;
//
//    // cashValue + assetsValue.
//    @Column(
//            name = "total_value",
//            nullable = false,
//            precision = 19,
//            scale = 4
//    )
//    private BigDecimal totalValue;
//
//    // Date à laquelle la valeur du portefeuille a été enregistrée.
//    @Column(name = "captured_at", nullable = false)
//    private Instant capturedAt;
//
//    @PrePersist
//    public void onCreate() {
//        capturedAt = Instant.now();
//    }
//}