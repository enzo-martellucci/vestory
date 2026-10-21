package com.insa.vestory.model.enums;

import lombok.Getter;

@Getter
public enum CardRarity {
    COMMON(15),
    RARE(40),
    EPIC(120),
    LEGENDARY(400);

    private final int duplicateGems;

    CardRarity(int duplicateGems) {
        this.duplicateGems = duplicateGems;
    }

}