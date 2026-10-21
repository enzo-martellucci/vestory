package com.insa.vestory.service.quote;

import com.insa.vestory.client.MarketDataUnavailableException;
import com.insa.vestory.client.fmp.FmpClient;
import com.insa.vestory.client.fmp.dto.FmpDailyPriceDto;
import com.insa.vestory.client.fmp.dto.FmpQuoteDto;
import com.insa.vestory.client.twelvedata.TwelveDataClient;
import com.insa.vestory.client.twelvedata.dto.TwelveDataQuoteDto;
import com.insa.vestory.client.twelvedata.dto.TwelveDataTimeSeriesDto;
import com.insa.vestory.client.twelvedata.dto.TwelveDataTimeSeriesValueDto;
import com.insa.vestory.config.CacheConfiguration;
import com.insa.vestory.dto.quote.FinancialHistoryDto;
import com.insa.vestory.dto.quote.FinancialHistoryPointDto;
import com.insa.vestory.dto.quote.FinancialQuoteDto;
import com.insa.vestory.entity.Asset;
import com.insa.vestory.exception.ResourceNotFoundException;
import com.insa.vestory.repository.AssetRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.time.Instant;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.ZoneOffset;
import java.time.format.DateTimeFormatter;
import java.time.format.DateTimeParseException;
import java.util.Comparator;
import java.util.List;
import java.util.Objects;
import java.util.UUID;
import java.util.function.Supplier;

@Slf4j
@Service
@RequiredArgsConstructor
public class MarketDataService {

    private static final String TWELVE_DATA = "TWELVE_DATA";
    private static final String FMP = "FMP";
    private static final DateTimeFormatter HISTORY_DATE_FORMAT = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
    private static final int FMP_HISTORY_DAYS = 30;

    private final AssetRepository assetRepository;
    private final TwelveDataClient twelveDataClient;
    private final FmpClient fmpClient;

    @Cacheable(cacheNames = CacheConfiguration.QUOTES, key = "#financialAssetId")
    public FinancialQuoteDto getQuote(UUID financialAssetId) {
        Asset asset = findAsset(financialAssetId);
        MarketSymbol marketSymbol = MarketSymbol.of(asset);

        try {
            return quoteFromTwelveData(asset, marketSymbol);
        } catch (MarketDataUnavailableException exception) {
            log.warn("Twelve Data quote failed for {}: {}", asset.getSymbol(), exception.getBody().getDetail());
        }

        return quoteFromFmp(asset, marketSymbol);
    }

    @Cacheable(cacheNames = CacheConfiguration.HISTORY, key = "#financialAssetId")
    public FinancialHistoryDto getHistory(UUID financialAssetId) {
        Asset asset = findAsset(financialAssetId);
        MarketSymbol marketSymbol = MarketSymbol.of(asset);

        try {
            return historyFromTwelveData(asset, marketSymbol);
        } catch (MarketDataUnavailableException exception) {
            log.warn("Twelve Data history failed for {}: {}", asset.getSymbol(), exception.getBody().getDetail());
        }

        return historyFromFmp(asset, marketSymbol);
    }

    private FinancialQuoteDto quoteFromTwelveData(Asset asset, MarketSymbol marketSymbol) {
        TwelveDataQuoteDto quote = twelveDataClient.getQuote(marketSymbol.symbol(), marketSymbol.micCode());
        Double price = toDouble(quote.close());
        if (price == null)
            throw new MarketDataUnavailableException("No price returned by Twelve Data for " + asset.getSymbol());

        return new FinancialQuoteDto(
            asset.getId(),
            asset.getSymbol(),
            asset.getName(),
            asset.getAssetType(),
            asset.getCurrency(),
            asset.getExchange(),
            price,
            toDouble(quote.open()),
            toDouble(quote.high()),
            toDouble(quote.low()),
            toDouble(quote.previousClose()),
            toDouble(quote.change()),
            toDouble(quote.percentChange()),
            toDouble(quote.volume()),
            Boolean.TRUE.equals(quote.marketOpen()),
            quote.timestamp() == null ? null : Instant.ofEpochSecond(quote.timestamp()),
            TWELVE_DATA,
            marketSymbol.trackedBy()
        );
    }

    private FinancialQuoteDto quoteFromFmp(Asset asset, MarketSymbol marketSymbol) {
        FmpQuoteDto quote = callFmp(asset, () -> fmpClient.getQuote(marketSymbol.fmpSymbol(asset)));
        if (quote.price() == null)
            throw new MarketDataUnavailableException("No price available for " + asset.getSymbol());

        return new FinancialQuoteDto(
            asset.getId(),
            asset.getSymbol(),
            asset.getName(),
            asset.getAssetType(),
            asset.getCurrency(),
            asset.getExchange(),
            quote.price().doubleValue(),
            toDouble(quote.open()),
            toDouble(quote.dayHigh()),
            toDouble(quote.dayLow()),
            toDouble(quote.previousClose()),
            toDouble(quote.change()),
            toDouble(quote.changePercentage()),
            toDouble(quote.volume()),
            false,
            quote.timestamp() == null ? null : Instant.ofEpochSecond(quote.timestamp()),
            FMP,
            marketSymbol.trackedBy()
        );
    }

    private FinancialHistoryDto historyFromTwelveData(Asset asset, MarketSymbol marketSymbol) {
        TwelveDataTimeSeriesDto timeSeries = twelveDataClient.getTimeSeries(marketSymbol.symbol(), marketSymbol.micCode());
        List<TwelveDataTimeSeriesValueDto> values = timeSeries.values() == null ? List.of() : timeSeries.values();

        List<FinancialHistoryPointDto> points = values.stream()
            .map(value -> toPoint(parseTwelveDataTimestamp(value.datetime()), toDouble(value.close())))
            .filter(Objects::nonNull)
            .sorted(Comparator.comparing(FinancialHistoryPointDto::timestamp))
            .toList();

        if (points.isEmpty())
            throw new MarketDataUnavailableException("No history returned by Twelve Data for " + asset.getSymbol());

        return new FinancialHistoryDto(asset.getId(), asset.getSymbol(), asset.getCurrency(), points);
    }

    private FinancialHistoryDto historyFromFmp(Asset asset, MarketSymbol marketSymbol) {
        LocalDate from = LocalDate.now(ZoneOffset.UTC).minusDays(FMP_HISTORY_DAYS);
        List<FmpDailyPriceDto> prices = callFmp(asset, () -> fmpClient.getDailyPrices(marketSymbol.fmpSymbol(asset), from));

        List<FinancialHistoryPointDto> points = prices.stream()
            .map(price -> toPoint(parseFmpDate(price.date()), toDouble(price.price())))
            .filter(Objects::nonNull)
            .sorted(Comparator.comparing(FinancialHistoryPointDto::timestamp))
            .toList();

        if (points.isEmpty())
            throw new MarketDataUnavailableException("No history available for " + asset.getSymbol());

        return new FinancialHistoryDto(asset.getId(), asset.getSymbol(), asset.getCurrency(), points);
    }

    private <T> T callFmp(Asset asset, Supplier<T> call) {
        try {
            return call.get();
        } catch (RuntimeException exception) {
            log.warn("FMP request failed for {}: {}", asset.getSymbol(), exception.getMessage());
            throw new MarketDataUnavailableException("No market data available for " + asset.getSymbol() + " from Twelve Data or FMP", exception);
        }
    }

    private Asset findAsset(UUID financialAssetId) {
        return assetRepository.findById(financialAssetId)
            .orElseThrow(() -> new ResourceNotFoundException("Financial asset not found"));
    }

    private FinancialHistoryPointDto toPoint(Instant timestamp, Double price) {
        return timestamp == null || price == null ? null : new FinancialHistoryPointDto(timestamp, price);
    }

    private Instant parseTwelveDataTimestamp(String value) {
        if (value == null || value.isBlank())
            return null;

        try {
            return LocalDateTime.parse(value, HISTORY_DATE_FORMAT).toInstant(ZoneOffset.UTC);
        } catch (DateTimeParseException exception) {
            return null;
        }
    }

    private Instant parseFmpDate(String value) {
        if (value == null || value.isBlank())
            return null;

        try {
            return LocalDate.parse(value.substring(0, Math.min(10, value.length()))).atStartOfDay(ZoneOffset.UTC).toInstant();
        } catch (DateTimeParseException exception) {
            return null;
        }
    }

    private Double toDouble(BigDecimal value) {
        return value == null ? null : value.doubleValue();
    }

    private Double toDouble(String value) {
        if (value == null || value.isBlank())
            return null;

        try {
            return Double.parseDouble(value);
        } catch (NumberFormatException exception) {
            return null;
        }
    }
}
