//package com.insa.vestory.model.entity;
//
//import com.insa.vestory.model.enums.QuizDifficulty;
//import jakarta.persistence.*;
//import lombok.Getter;
//import lombok.NoArgsConstructor;
//import lombok.Setter;
//
//import java.time.Instant;
//import java.util.UUID;
//
//@Entity
//@Getter
//@Setter
//@NoArgsConstructor
//@Table(
//        name = "questions",
//        indexes = {
//                @Index(name = "idx_question_difficulty", columnList = "difficulty")
//        }
//)
//public class Question {
//
//    @Id
//    @GeneratedValue(strategy = GenerationType.UUID)
//    private UUID id;
//
//    @Enumerated(EnumType.STRING)
//    @Column(nullable = false, length = 20)
//    private QuizDifficulty difficulty;
//
//    @Column(nullable = false, columnDefinition = "TEXT")
//    private String text;
//
//    // Explication pédagogique affichée après la réponse.
//    @Column(nullable = false, columnDefinition = "TEXT")
//    private String explanation;
//
//    // Ex : ACTION, ETF, DIVIDEND, RISK, CASH_FLOW...
//    @Column(length = 100)
//    private String category;
//
//    @Column(nullable = false)
//    private boolean enabled = true;
//
//    @Column(name = "created_at", nullable = false)
//    private Instant createdAt;
//
//    @Column(name = "updated_at", nullable = false)
//    private Instant updatedAt;
//
//    @PrePersist
//    public void onCreate() {
//        Instant now = Instant.now();
//        createdAt = now;
//        updatedAt = now;
//    }
//
//    @PreUpdate
//    public void onUpdate() {
//        updatedAt = Instant.now();
//    }
//}