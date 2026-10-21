package com.insa.vestory.service.pack;

import com.insa.vestory.model.entity.AssetCard;
import com.insa.vestory.model.enums.CardRarity;

public record PackDraw(AssetCard card, CardRarity rarity) {
}