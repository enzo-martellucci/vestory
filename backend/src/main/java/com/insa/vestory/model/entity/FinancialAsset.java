package com.insa.vestory.model.entity;
import com.insa.vestory.model.enums.AssetType;
import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

import java.time.Instant;
import java.util.UUID;

@Entity
@Getter
@Setter
@Table(
       name = "financial_assets",
       indexes = {
               @Index(name = "idx_financial_asset_symbol", columnList = "symbol"),
               @Index(name = "idx_financial_asset_type", columnList = "asset_type")
       }
)
public class FinancialAsset {

   @Id
   @GeneratedValue(strategy = GenerationType.UUID)
   private UUID id;

   @Column(nullable = false, length = 50)
   private String symbol;

   @Column(nullable = false, length = 255)
   private String name;

   // Enum stockée en texte dans la base (ex: "STOCK", "CRYPTO")
   @Enumerated(EnumType.STRING)
   @Column(name = "asset_type", nullable = false, length = 30)
   private AssetType assetType;

   // bourse où il est négocié
   @Column(length = 100)
   private String exchange;

   // pays d'origine
   @Column(length = 100)
   private String country;

   // devise utilisée (ex: EUR, USD)
   @Column(length = 10)
   private String currency;

   // secteur économique
   @Column(length = 100)
   private String sector;

   @Column(columnDefinition = "TEXT")
   private String description;

   @Column(name = "logo_url", length = 500)
   private String logoUrl;

   @Column(nullable = false)
   private boolean enabled = true;

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