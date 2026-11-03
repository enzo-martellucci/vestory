package com.insa.vestory.service.pack;

import com.insa.vestory.constant.PackSource;
import com.insa.vestory.constant.PackType;
import com.insa.vestory.constant.Rarity;
import com.insa.vestory.entity.Asset;
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

    public Asset draw(PackType type, PackSource source, Map<Rarity, List<Asset>> assetsByRarity) {
        Rarity rarity = closestAvailableRarity(rollRarity(type, source), assetsByRarity);
        List<Asset> pool = assetsByRarity.get(rarity);
        return pool.get(random.nextInt(pool.size()));
    }

    private Rarity rollRarity(PackType type, PackSource source) {
        double roll = random.nextDouble();
        double cumulative = 0;
        Rarity last = null;

        for (Rarity rarity : Rarity.values()) {
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

    private Rarity closestAvailableRarity(Rarity wanted, Map<Rarity, List<Asset>> assetsByRarity) {
        Rarity[] rarities = Rarity.values();

        for (int distance = 0; distance < rarities.length; distance++) {
            int lower = wanted.ordinal() - distance;
            if (lower >= 0 && hasAssets(rarities[lower], assetsByRarity))
                return rarities[lower];

            int higher = wanted.ordinal() + distance;
            if (higher < rarities.length && hasAssets(rarities[higher], assetsByRarity))
                return rarities[higher];
        }

        throw new IllegalStateException("No asset available to draw");
    }

    private boolean hasAssets(Rarity rarity, Map<Rarity, List<Asset>> assetsByRarity) {
        List<Asset> assets = assetsByRarity.get(rarity);
        return assets != null && !assets.isEmpty();
    }
}
