//package com.insa.vestory.model.entity;
//
//import com.insa.vestory.model.enums.PackSource;
//import com.insa.vestory.model.enums.UserPackStatus;
//import jakarta.persistence.*;
//import lombok.Getter;
//import lombok.NoArgsConstructor;
//import lombok.Setter;
//
//import java.time.Instant;
//import java.time.LocalDate;
//import java.util.UUID;
//
//@Entity
//@Getter
//@Setter
//@NoArgsConstructor
//@Table(
//        name = "user_packs",
//        indexes = {
//                @Index(name = "idx_user_pack_user", columnList = "user_id"),
//                @Index(name = "idx_user_pack_status", columnList = "status")
//        }
//)
//public class UserPack {
//
//    @Id
//    @GeneratedValue(strategy = GenerationType.UUID)
//    private UUID id;
//
//    @ManyToOne(fetch = FetchType.LAZY, optional = false)
//    @JoinColumn(name = "user_id", nullable = false)
//    private AppUser user;
//
//    @ManyToOne(fetch = FetchType.LAZY, optional = false)
//    @JoinColumn(name = "pack_type_id", nullable = false)
//    private PackType packType;
//
//    // Origine du pack : bienvenue, quotidien, quiz, boutique...
//    @Enumerated(EnumType.STRING)
//    @Column(nullable = false, length = 20)
//    private PackSource source;
//
//    @Enumerated(EnumType.STRING)
//    @Column(nullable = false, length = 20)
//    private UserPackStatus status = UserPackStatus.AVAILABLE;
//
//    // Utile notamment pour les packs quotidiens.
//    @Column(name = "grant_date")
//    private LocalDate grantDate;
//
//    @Column(name = "opened_at")
//    private Instant openedAt;
//
//    // Prix réellement payé par le joueur.
//    // 0 pour les packs gratuits.
//    @Column(name = "gem_cost_paid", nullable = false)
//    private int gemCostPaid = 0;
//
//    @Column(name = "created_at", nullable = false)
//    private Instant createdAt;
//
//    @PrePersist
//    public void onCreate() {
//        createdAt = Instant.now();
//    }
//}