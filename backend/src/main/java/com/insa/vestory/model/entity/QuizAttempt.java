//package com.insa.vestory.model.entity;
//
//import com.insa.vestory.model.enums.QuizDifficulty;
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
//        name = "quiz_attempts",
//        uniqueConstraints = {
//                @UniqueConstraint(
//                        name = "uk_daily_quiz",
//                        columnNames = {
//                                "user_id",
//                                "quiz_date",
//                                "difficulty"
//                        }
//                )
//        },
//        indexes = {
//                @Index(name = "idx_quiz_attempt_user", columnList = "user_id")
//        }
//)
//public class QuizAttempt {
//    @Id
//    @GeneratedValue(strategy = GenerationType.UUID)
//    private UUID id;
//
//    @ManyToOne(fetch = FetchType.LAZY, optional = false)
//    @JoinColumn(name = "user_id", nullable = false)
//    private AppUser user;
//
//    @Enumerated(EnumType.STRING)
//    @Column(nullable = false, length = 20)
//    private QuizDifficulty difficulty;
//
//    // Jour auquel correspond le quiz quotidien.
//    @Column(name = "quiz_date", nullable = false)
//    private LocalDate quizDate;
//
//    @Column(name = "total_questions", nullable = false)
//    private int totalQuestions = 5;
//
//    @Column(name = "correct_answers", nullable = false)
//    private int correctAnswers = 0;
//
//    @Column(name = "gems_awarded", nullable = false)
//    private int gemsAwarded = 0;
//
//    @Column(nullable = false)
//    private boolean completed = false;
//
//    @Column(name = "started_at", nullable = false)
//    private Instant startedAt;
//
//    @Column(name = "completed_at")
//    private Instant completedAt;
//
//    @PrePersist
//    public void onCreate() {
//        startedAt = Instant.now();
//    }
//}