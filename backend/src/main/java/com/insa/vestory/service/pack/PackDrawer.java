package com.insa.vestory.service.pack;

import com.insa.vestory.model.entity.AssetCard;
import com.insa.vestory.model.enums.CardRarity;
import com.insa.vestory.model.enums.PackSource;
import com.insa.vestory.model.enums.PackType;
import org.springframework.stereotype.Component;

import java.security.SecureRandom;
import java.util.List;
import java.util.Map;
import java.util.random.RandomGenerator;

@Component
public class PackDrawer {

    private final RandomGenerator random;

    public PackDrawer() {
        this(new SecureRandom());
    }

    public PackDrawer(RandomGenerator random) {
        this.random = random;
    }

    public PackDraw draw(PackType type, PackSource source, Map<CardRarity, List<AssetCard>> cardsByRarity) {
        CardRarity rarity = closestAvailableRarity(rollRarity(type, source), cardsByRarity);
        List<AssetCard> pool = cardsByRarity.get(rarity);
        return new PackDraw(pool.get(random.nextInt(pool.size())), rarity);
    }

    private CardRarity rollRarity(PackType type, PackSource source) {
        double roll = random.nextDouble();
        double cumulative = 0;
        CardRarity last = null;

        for (CardRarity rarity : CardRarity.values()) {
            double odds = type.oddsOf(rarity, source);
            if (odds <= 0)
                continue;
            cumulative += odds;
            last = rarity;
            if (roll < cumulative)
                return rarity;
        }

        return last;
    }

    private CardRarity closestAvailableRarity(CardRarity wanted, Map<CardRarity, List<AssetCard>> cardsByRarity) {
        CardRarity[] rarities = CardRarity.values();

        for (int distance = 0; distance < rarities.length; distance++) {
            int lower = wanted.ordinal() - distance;
            if (lower >= 0 && hasCards(rarities[lower], cardsByRarity))
                return rarities[lower];

            int higher = wanted.ordinal() + distance;
            if (higher < rarities.length && hasCards(rarities[higher], cardsByRarity))
                return rarities[higher];
        }

        throw new IllegalStateException("No card available to draw");
    }

    private boolean hasCards(CardRarity rarity, Map<CardRarity, List<AssetCard>> cardsByRarity) {
        List<AssetCard> cards = cardsByRarity.get(rarity);
        return cards != null && !cards.isEmpty();
    }
}