package com.insa.vestory.constant;

public enum PackSource {
    WELCOME,
    DAILY,
    SHOP,
    QUIZ;

    public boolean isFree() {
        return this != SHOP;
    }
}
