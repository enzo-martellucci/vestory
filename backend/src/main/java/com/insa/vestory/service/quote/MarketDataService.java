package com.insa.vestory.service.quote;

import com.insa.vestory.client.MarketDataUnavailableException;
import com.insa.vestory.client.twelvedata.TwelveDataClient;
import com.insa.vestory.client.twelvedata.dto.TwelveDataQuoteDto;
import com.insa.vestory.client.twelvedata.dto.TwelveDataTimeSeriesDto;
import com.insa.vestory.client.twelvedata.dto.TwelveDataTimeSeriesValueDto;
import com.insa.vestory.config.CacheConfiguration;
import com.insa.vestory.dto.quote.FinancialHistoryDto;
import com.insa.vestory.dto.quote.FinancialHistoryPointDto;
import com.insa.vestory.dto.quote.FinancialQuoteDto;
import com.insa.vestory.exception.ResourceNotFoundException;
import com.insa.vestory.model.entity.FinancialAsset;
import com.insa.vestory.repository.FinancialAssetRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.stereotype.Service;

import java.time.Instant;
import java.time.LocalDateTime;
import java.time.ZoneOffset;
import java.time.format.DateTimeFormatter;
import java.time.format.DateTimeParseException;
import java.util.Comparator;
import java.util.List;
import java.util.Objects;
import java.util.UUID;

@Slf4j
@Service
@RequiredArgsConstructor
public class MarketDataService {

    private static final String PROVIDER = "TWELVE_DATA";
    private static final DateTimeFormatter HISTORY_DATE_FORMAT = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");

    private final FinancialAssetRepository financialAssetRepository;
    private final TwelveDataClient twelveDataClient;

    @Cacheable(cacheNames = CacheConfiguration.QUOTES, key = "#financialAssetId")
    public FinancialQuoteDto getQuote(UUID financialAssetId) {
        FinancialAsset asset = findAsset(financialAssetId);
        MarketSymbol marketSymbol = MarketSymbol.of(asset);
        log.info("Fetching quote for {} ({})", asset.getSymbol(), marketSymbol.symbol());

        TwelveDataQuoteDto quote = twelveDataClient.getQuote(marketSymbol.symbol(), marketSymbol.micCode());
        Double price = toDouble(quote.close());
        if (price == null)
            throw new MarketDataUnavailableException("No price returned for " + asset.getSymbol());

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
                PROVIDER
        );
    }

    @Cacheable(cacheNames = CacheConfiguration.HISTORY, key = "#financialAssetId")
    public FinancialHistoryDto getHistory(UUID financialAssetId) {
        FinancialAsset asset = findAsset(financialAssetId);
        MarketSymbol marketSymbol = MarketSymbol.of(asset);
        log.info("Fetching history for {} ({})", asset.getSymbol(), marketSymbol.symbol());

        TwelveDataTimeSeriesDto timeSeries = twelveDataClient.getTimeSeries(marketSymbol.symbol(), marketSymbol.micCode());
        List<TwelveDataTimeSeriesValueDto> values = timeSeries.values() == null ? List.of() : timeSeries.values();

        List<FinancialHistoryPointDto> points = values.stream()
                .map(this::toHistoryPoint)
                .filter(Objects::nonNull)
                .sorted(Comparator.comparing(FinancialHistoryPointDto::timestamp))
                .toList();

        return new FinancialHistoryDto(asset.getId(), asset.getSymbol(), asset.getCurrency(), points);
    }

    private FinancialAsset findAsset(UUID financialAssetId) {
        return financialAssetRepository.findById(financialAssetId)
                .orElseThrow(() -> new ResourceNotFoundException("Financial asset not found"));
    }

    private FinancialHistoryPointDto toHistoryPoint(TwelveDataTimeSeriesValueDto value) {
        Double price = toDouble(value.close());
        Instant timestamp = parseTimestamp(value.datetime());
        return price == null || timestamp == null ? null : new FinancialHistoryPointDto(timestamp, price);
    }

    private Instant parseTimestamp(String value) {
        if (value == null || value.isBlank())
            return null;

        try {
            return LocalDateTime.parse(value, HISTORY_DATE_FORMAT).toInstant(ZoneOffset.UTC);
        } catch (DateTimeParseException exception) {
            return null;
        }
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
