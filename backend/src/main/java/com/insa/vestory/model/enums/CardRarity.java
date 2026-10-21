package com.insa.vestory.model.enums;

import lombok.Getter;

@Getter
public enum CardRarity {
    COMMON(2),
    RARE(10),
    EPIC(50),
    LEGENDARY(100);

    private final int duplicateGems;

    CardRarity(int duplicateGems) {
        this.duplicateGems = duplicateGems;
    }

}