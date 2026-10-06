package com.insa.vestory.service.quote;

import com.insa.vestory.client.TwelveDataClient;
import com.insa.vestory.dto.quote.FinancialQuoteDto;
import com.insa.vestory.dto.quote.TwelveDataQuoteDto;
import com.insa.vestory.model.entity.FinancialAsset;
import com.insa.vestory.model.enums.AssetType;
import com.insa.vestory.repository.FinancialAssetRepository;

import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.web.server.ResponseStatusException;

import java.math.BigDecimal;
import java.time.Instant;
import java.util.UUID;

@Service
public class FinancialMarketService {

    private final FinancialAssetRepository financialAssetRepository;
    private final TwelveDataClient twelveDataClient;

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

        /*
         * Les commodities seront branchées
         * séparément avec un provider compatible.
         */
        if (asset.getAssetType()
                == AssetType.COMMODITY) {

            throw new ResponseStatusException(
                    HttpStatus.NOT_IMPLEMENTED,
                    "Commodity market data is not available yet"
            );
        }

        TwelveDataQuoteDto quote;

        try {

            quote =
                    twelveDataClient.getQuote(
                            asset.getSymbol(),
                            asset.getMicCode()
                    );

        } catch (Exception e) {

            throw new ResponseStatusException(
                    HttpStatus.BAD_GATEWAY,
                    "Unable to retrieve market data from Twelve Data",
                    e
            );
        }

        if (quote == null) {

            throw new ResponseStatusException(
                    HttpStatus.BAD_GATEWAY,
                    "Empty response from Twelve Data"
            );
        }

        /*
         * Twelve Data peut retourner une réponse
         * JSON contenant status=error.
         */
        if ("error".equalsIgnoreCase(
                quote.status()
        )) {

            throw new ResponseStatusException(
                    HttpStatus.BAD_GATEWAY,
                    "Twelve Data error: "
                            + quote.message()
            );
        }

        if (quote.close() == null
                || quote.close().isBlank()) {

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

        return new FinancialQuoteDto(

                asset.getId(),

                asset.getSymbol(),
                asset.getName(),
                asset.getAssetType(),

                /*
                 * Sur Twelve Data /quote,
                 * le dernier prix exploité ici est close.
                 */
                toBigDecimal(
                        quote.close()
                ),

                toBigDecimal(
                        quote.open()
                ),

                toBigDecimal(
                        quote.high()
                ),

                toBigDecimal(
                        quote.low()
                ),

                toBigDecimal(
                        quote.previousClose()
                ),

                toBigDecimal(
                        quote.change()
                ),

                toBigDecimal(
                        quote.percentChange()
                ),

                toBigDecimal(
                        quote.volume()
                ),

                Boolean.TRUE.equals(
                        quote.marketOpen()
                ),

                timestamp,

                "TWELVE_DATA"
        );
    }

    private BigDecimal toBigDecimal(
            String value
    ) {

        if (value == null
                || value.isBlank()) {

            return null;
        }

        try {

            return new BigDecimal(
                    value
            );

        } catch (NumberFormatException e) {

            return null;
        }
    }
}