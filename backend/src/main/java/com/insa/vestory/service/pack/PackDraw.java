package com.insa.vestory.service.pack;

import com.insa.vestory.constant.CardRarity;
import com.insa.vestory.entity.Card;

public record PackDraw(Card card, CardRarity rarity) {
}