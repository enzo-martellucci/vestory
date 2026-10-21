package com.insa.vestory.model.enums;

public enum PackSource {
    WELCOME,
    DAILY,
    SHOP,
    QUIZ;

    public boolean isFree() {
        return this != SHOP;
    }
}
