package com.insa.vestory.constant;

import lombok.Getter;

@Getter
public enum Rarity {
    COMMON(2),
    RARE(10),
    EPIC(50),
    LEGENDARY(100);

    private final int duplicateGems;

    Rarity(int duplicateGems) {
        this.duplicateGems = duplicateGems;
    }
}
