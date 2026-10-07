package com.insa.vestory.service.quote;
import com.insa.vestory.dto.quote.FinancialHistoryDto;
import com.insa.vestory.dto.quote.FinancialHistoryPointDto;
import com.insa.vestory.dto.quote.TwelveDataTimeSeriesDto;
import com.insa.vestory.dto.quote.TwelveDataTimeSeriesValueDto;

import java.time.LocalDateTime;
import java.time.ZoneOffset;
import java.time.format.DateTimeFormatter;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import com.insa.vestory.client.TwelveDataClient;
import com.insa.vestory.dto.quote.FinancialQuoteDto;
import com.insa.vestory.dto.quote.TwelveDataQuoteDto;
import com.insa.vestory.model.entity.FinancialAsset;
import com.insa.vestory.model.enums.AssetType;
import com.insa.vestory.repository.FinancialAssetRepository;

import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.web.server.ResponseStatusException;

import java.time.Instant;
import java.util.UUID;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.client.RestClientResponseException;

@Service
public class FinancialMarketService {

    private final FinancialAssetRepository financialAssetRepository;
    private final TwelveDataClient twelveDataClient;
    private static final Logger log = LoggerFactory.getLogger(FinancialMarketService.class);

    public FinancialMarketService(
            FinancialAssetRepository financialAssetRepository,
            TwelveDataClient twelveDataClient
    ) {

        this.financialAssetRepository =
                financialAssetRepository;

        this.twelveDataClient =
                twelveDataClient;
    }

    public FinancialQuoteDto getQuote(
            UUID financialAssetId
    ) {

        FinancialAsset asset =
                financialAssetRepository
                        .findById(financialAssetId)
                        .orElseThrow(
                                () ->
                                        new ResponseStatusException(
                                                HttpStatus.NOT_FOUND,
                                                "FinancialAsset not found"
                                        )
                        );

        String marketSymbol =
                resolveMarketSymbol(asset);

        String micCode =
                asset.getAssetType()
                        == AssetType.COMMODITY
                        ? null
                        : asset.getMicCode();

        log.info(
                """
                ================= QUOTE REQUEST =================
                Asset       : {}
                Type        : {}
                Vestory     : {}
                Market      : {}
                MIC         : {}
                =================================================
                """,
                asset.getName(),
                asset.getAssetType(),
                asset.getSymbol(),
                marketSymbol,
                micCode
        );

        TwelveDataQuoteDto quote;

        try {

            quote =
                    twelveDataClient.getQuote(
                            marketSymbol,
                            micCode
                    );

        } catch (RestClientResponseException e) {

            log.error(
                    """
                    ============== TWELVE DATA ERROR ==============
                    Asset       : {}
                    Type        : {}
                    Vestory     : {}
                    Market      : {}
                    MIC         : {}
                    HTTP status : {}
                    Response    : {}
                    =================================================
                    """,
                    asset.getName(),
                    asset.getAssetType(),
                    asset.getSymbol(),
                    marketSymbol,
                    micCode,
                    e.getStatusCode(),
                    e.getResponseBodyAsString()
            );

            throw new ResponseStatusException(
                    HttpStatus.BAD_GATEWAY,
                    "Unable to retrieve market data from Twelve Data",
                    e
            );

        } catch (Exception e) {

            log.error(
                    """
                    ================= QUOTE ERROR =================
                    Asset       : {}
                    Type        : {}
                    Vestory     : {}
                    Market      : {}
                    MIC         : {}
                    Error       : {}
                    =================================================
                    """,
                    asset.getName(),
                    asset.getAssetType(),
                    asset.getSymbol(),
                    marketSymbol,
                    micCode,
                    e.getMessage(),
                    e
            );

            throw new ResponseStatusException(
                    HttpStatus.BAD_GATEWAY,
                    "Unable to retrieve market data from Twelve Data",
                    e
            );
        }

        if (quote == null) {

            log.error(
                    "Empty Twelve Data quote | type={} | asset={} | symbol={}",
                    asset.getAssetType(),
                    asset.getName(),
                    marketSymbol
            );

            throw new ResponseStatusException(
                    HttpStatus.BAD_GATEWAY,
                    "Empty response from Twelve Data"
            );
        }

        /*
         * Twelve Data peut répondre HTTP 200
         * mais avec status=error dans le JSON.
         */
        if ("error".equalsIgnoreCase(
                quote.status()
        )) {

            log.error(
                    """
                    =========== TWELVE DATA JSON ERROR ===========
                    Asset       : {}
                    Type        : {}
                    Vestory     : {}
                    Market      : {}
                    Status      : {}
                    Message     : {}
                    =================================================
                    """,
                    asset.getName(),
                    asset.getAssetType(),
                    asset.getSymbol(),
                    marketSymbol,
                    quote.status(),
                    quote.message()
            );

            throw new ResponseStatusException(
                    HttpStatus.BAD_GATEWAY,
                    "Twelve Data error: "
                            + quote.message()
            );
        }

        if (quote.close() == null
                || quote.close().isBlank()) {

            log.error(
                    """
                    ================ NO PRICE =================
                    Asset       : {}
                    Type        : {}
                    Vestory     : {}
                    Market      : {}
                    =================================================
                    """,
                    asset.getName(),
                    asset.getAssetType(),
                    asset.getSymbol(),
                    marketSymbol
            );

            throw new ResponseStatusException(
                    HttpStatus.BAD_GATEWAY,
                    "No price returned for "
                            + asset.getSymbol()
            );
        }

        Instant timestamp =
                quote.timestamp() == null
                        ? null
                        : Instant.ofEpochSecond(
                        quote.timestamp()
                );

        log.info(
                "QUOTE SUCCESS | type={} | asset={} | marketSymbol={} | price={}",
                asset.getAssetType(),
                asset.getName(),
                marketSymbol,
                quote.close()
        );

        return new FinancialQuoteDto(
                asset.getId(),
                asset.getSymbol(),
                asset.getName(),
                asset.getAssetType(),

                asset.getCurrency(),
                asset.getExchange(),

                toDouble(quote.close()),

                toDouble(quote.open()),
                toDouble(quote.high()),
                toDouble(quote.low()),
                toDouble(quote.previousClose()),

                toDouble(quote.change()),
                toDouble(quote.percentChange()),

                toDouble(quote.volume()),

                Boolean.TRUE.equals(
                        quote.marketOpen()
                ),

                timestamp,

                "TWELVE_DATA"
        );
    }

    private Double toDouble(
            String value
    ) {

        if (value == null
                || value.isBlank()) {

            return null;
        }

        try {

            return Double.parseDouble(
                    value
            );

        } catch (NumberFormatException e) {

            return null;
        }
    }

    private String resolveMarketSymbol(
            FinancialAsset asset
    ) {

        if (asset.getAssetType()
                != AssetType.COMMODITY) {

            return asset.getSymbol();
        }

        return switch (
                asset.getSymbol()
                        .toUpperCase()
                ) {

            case "GCUSD" ->
                    "XAU/USD";

            case "SIUSD" ->
                    "XAG/USD";

            case "PLUSD" ->
                    "XPT/USD";

            case "PAUSD" ->
                    "XPD/USD";

            case "CLUSD" ->
                    "WTI/USD";

            case "BZUSD" ->
                    "XBR/USD";

            case "HGUSD" ->
                    "HG1";

            default ->
                    throw new ResponseStatusException(
                            HttpStatus.NOT_IMPLEMENTED,
                            "Commodity symbol is not mapped yet: "
                                    + asset.getSymbol()
                    );
        };
    }

    public FinancialHistoryDto getHistory(
            UUID financialAssetId
    ) {

        FinancialAsset asset =
                financialAssetRepository
                        .findById(
                                financialAssetId
                        )
                        .orElseThrow(
                                () ->
                                        new ResponseStatusException(
                                                HttpStatus.NOT_FOUND,
                                                "FinancialAsset not found"
                                        )
                        );

        String marketSymbol =
                resolveMarketSymbol(asset);

        String micCode =
                asset.getAssetType()
                        == AssetType.COMMODITY
                        ? null
                        : asset.getMicCode();

        TwelveDataTimeSeriesDto history;

        try {

            log.info(
                    "HISTORY REQUEST | type={} | asset={} | Vestory={} | Market={} | MIC={}",
                    asset.getAssetType(),
                    asset.getName(),
                    asset.getSymbol(),
                    marketSymbol,
                    micCode
            );

            history =
                    twelveDataClient
                            .getTimeSeries(
                                    marketSymbol,
                                    micCode
                            );

        } catch (RestClientResponseException e) {

            log.error(
                    """
                    =========== TWELVE DATA HISTORY ERROR ===========
                    Asset       : {}
                    Type        : {}
                    Vestory     : {}
                    Market      : {}
                    MIC         : {}
                    HTTP status : {}
                    Response    : {}
                    =================================================
                    """,
                    asset.getName(),
                    asset.getAssetType(),
                    asset.getSymbol(),
                    marketSymbol,
                    micCode,
                    e.getStatusCode(),
                    e.getResponseBodyAsString()
            );

            throw new ResponseStatusException(
                    HttpStatus.BAD_GATEWAY,
                    "Unable to retrieve market history from Twelve Data",
                    e
            );

        } catch (Exception e) {

            log.error(
                    """
                    ================= HISTORY ERROR =================
                    Asset       : {}
                    Type        : {}
                    Vestory     : {}
                    Market      : {}
                    MIC         : {}
                    Error       : {}
                    =================================================
                    """,
                    asset.getName(),
                    asset.getAssetType(),
                    asset.getSymbol(),
                    marketSymbol,
                    micCode,
                    e.getMessage(),
                    e
            );

            throw new ResponseStatusException(
                    HttpStatus.BAD_GATEWAY,
                    "Unable to retrieve market history from Twelve Data",
                    e
            );
        }

        if (history == null) {

            throw new ResponseStatusException(
                    HttpStatus.BAD_GATEWAY,
                    "Empty history response from Twelve Data"
            );
        }

        if ("error".equalsIgnoreCase(
                history.status()
        )) {

            throw new ResponseStatusException(
                    HttpStatus.BAD_GATEWAY,
                    "Twelve Data error: "
                            + history.message()
            );
        }

        List<FinancialHistoryPointDto> points =
                new ArrayList<>();

        if (history.values() != null) {

            for (
                    TwelveDataTimeSeriesValueDto value
                    : history.values()
            ) {

                Double price =
                        toDouble(
                                value.close()
                        );

                Instant timestamp =
                        parseHistoryTimestamp(
                                value.datetime()
                        );

                if (price == null
                        || timestamp == null) {

                    continue;
                }

                points.add(
                        new FinancialHistoryPointDto(
                                timestamp,
                                price
                        )
                );
            }
        }

        /*
         * Twelve Data renvoie normalement
         * les points du plus récent au plus ancien.
         *
         * Pour Flutter, on veut :
         * ancien -> récent.
         */
        Collections.reverse(points);

        return new FinancialHistoryDto(
                asset.getId(),
                asset.getSymbol(),
                asset.getCurrency(),
                points
        );
    }

    private Instant parseHistoryTimestamp(
            String value
    ) {

        if (value == null
                || value.isBlank()) {

            return null;
        }

        try {

            LocalDateTime dateTime =
                    LocalDateTime.parse(
                            value,
                            DateTimeFormatter.ofPattern(
                                    "yyyy-MM-dd HH:mm:ss"
                            )
                    );

            return dateTime.toInstant(
                    ZoneOffset.UTC
            );

        } catch (Exception e) {

            return null;
        }
    }

}