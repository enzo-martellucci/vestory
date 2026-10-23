package com.insa.vestory.service.card.rarity;

import com.insa.vestory.client.MarketDataUnavailableException;
import com.insa.vestory.client.fmp.FmpClient;
import com.insa.vestory.client.fmp.dto.FmpCompanyProfileDto;
import com.insa.vestory.client.fmp.dto.FmpQuoteDto;
import com.insa.vestory.client.twelvedata.TwelveDataClient;
import com.insa.vestory.client.twelvedata.dto.TwelveDataForexPairDto;
import com.insa.vestory.constant.AssetType;
import com.insa.vestory.entity.Asset;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Component;
import org.springframework.web.client.HttpClientErrorException;

import java.util.*;
import java.util.function.Function;
import java.util.stream.Collectors;

@Slf4j
@Component
@RequiredArgsConstructor
public class RarityMarketDataLoader {

    private final FmpClient fmpClient;
    private final TwelveDataClient twelveDataClient;

    public Result load(List<Asset> assets) {
        Map<Long, RarityMarketData> data = new HashMap<>();
        List<String> unavailableSymbols = new ArrayList<>();
        Map<String, TwelveDataForexPairDto> forexPairs = hasForex(assets) ? loadForexPairs() : Map.of();

        for (Asset asset : assets) {
            RarityMarketData assetData = asset.getType() == AssetType.FOREX
                ? loadForex(asset, forexPairs)
                : loadFromFmp(asset);

            if (assetData == null)
                unavailableSymbols.add(asset.getSymbol() + (asset.getType() == AssetType.FOREX ? " [Twelve Data]" : " [FMP]"));
            else
                data.put(asset.getId(), assetData);
        }

        return new Result(data, unavailableSymbols.stream().distinct().sorted().toList());
    }

    private RarityMarketData loadForex(Asset asset, Map<String, TwelveDataForexPairDto> forexPairs) {
        TwelveDataForexPairDto pair = forexPairs.get(normalizeForex(asset.getSymbol()));
        return pair == null ? null : RarityMarketData.ofForex(pair.currencyGroup());
    }

    private RarityMarketData loadFromFmp(Asset asset) {
        String symbol = asset.getSymbol().replace("/", "").trim().toUpperCase();

        try {
            return switch (asset.getType()) {
                case STOCK, ETF -> {
                    FmpCompanyProfileDto profile = fmpClient.getCompanyProfile(symbol);
                    yield RarityMarketData.ofMarket(profile.marketCap(), profile.volume());
                }
                case CRYPTO, COMMODITY -> {
                    FmpQuoteDto quote = fmpClient.getQuote(symbol);
                    yield RarityMarketData.ofMarket(quote.marketCap(), quote.volume());
                }
                case FOREX -> null;
            };
        } catch (HttpClientErrorException exception) {
            if (exception.getStatusCode().isSameCodeAs(HttpStatus.TOO_MANY_REQUESTS))
                throw new MarketDataUnavailableException("FMP API limit reached, rarity update cancelled", exception);

            log.warn("FMP data unavailable for {}: {}", asset.getSymbol(), exception.getStatusCode());
            return null;
        } catch (RuntimeException exception) {
            log.warn("FMP data unavailable for {}: {}", asset.getSymbol(), exception.getMessage());
            return null;
        }
    }

    private Map<String, TwelveDataForexPairDto> loadForexPairs() {
        try {
            return twelveDataClient.getForexPairs().stream()
                .filter(pair -> pair.symbol() != null)
                .collect(Collectors.toMap(pair -> normalizeForex(pair.symbol()), Function.identity(), (first, second) -> first));
        } catch (RuntimeException exception) {
            log.warn("Twelve Data forex pairs unavailable: {}", exception.getMessage());
            return Map.of();
        }
    }

    private boolean hasForex(List<Asset> assets) {
        return assets.stream().anyMatch(asset -> asset.getType() == AssetType.FOREX);
    }

    private String normalizeForex(String symbol) {
        return symbol.trim().toUpperCase();
    }

    public record Result(Map<Long, RarityMarketData> data, List<String> unavailableSymbols) {
    }
}
