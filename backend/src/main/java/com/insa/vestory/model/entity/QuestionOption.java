//package com.insa.vestory.model.entity;
//
//import jakarta.persistence.*;
//import lombok.Getter;
//import lombok.NoArgsConstructor;
//import lombok.Setter;
//
//import java.util.UUID;
//
//@Entity
//@Getter
//@Setter
//@NoArgsConstructor
//@Table(
//        name = "question_options",
//        uniqueConstraints = {
//                @UniqueConstraint(
//                        name = "uk_question_option_position",
//                        columnNames = {"question_id", "position"}
//                )
//        }
//)
//public class QuestionOption {
//
//    @Id
//    @GeneratedValue(strategy = GenerationType.UUID)
//    private UUID id;
//
//    @ManyToOne(fetch = FetchType.LAZY, optional = false)
//    @JoinColumn(name = "question_id", nullable = false)
//    private Question question;
//
//    // Position d'affichage : 1, 2, 3 ou 4.
//    @Column(nullable = false)
//    private int position;
//
//    @Column(nullable = false, columnDefinition = "TEXT")
//    private String text;
//
//    @Column(nullable = false)
//    private boolean correct;
//}