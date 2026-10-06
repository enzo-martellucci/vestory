package com.insa.vestory.client;

import com.insa.vestory.config.TwelveDataProperties;
import com.insa.vestory.dto.card.TwelveDataForexPairDto;
import com.insa.vestory.dto.card.TwelveDataForexPairsResponse;
import com.insa.vestory.dto.quote.TwelveDataQuoteDto;
import org.springframework.stereotype.Component;
import org.springframework.web.client.RestClient;

import java.util.List;

@Component
public class TwelveDataClient {

    private final RestClient restClient;
    private final TwelveDataProperties properties;

    public TwelveDataClient(
            TwelveDataProperties properties
    ) {
        this.properties = properties;

        this.restClient =
                RestClient.builder()
                        .baseUrl(properties.getBaseUrl())
                        .build();
    }

    public List<TwelveDataForexPairDto> getForexPairs() {

        TwelveDataForexPairsResponse response =
                restClient.get()
                        .uri(uriBuilder ->
                                uriBuilder
                                        .path("/forex_pairs")
                                        .queryParam(
                                                "apikey",
                                                properties.getApiKey()
                                        )
                                        .build()
                        )
                        .retrieve()
                        .body(
                                TwelveDataForexPairsResponse.class
                        );

        if (response == null
                || response.data() == null) {

            return List.of();
        }

        if (!"ok".equalsIgnoreCase(
                response.status()
        )) {

            throw new IllegalStateException(
                    "Twelve Data forex_pairs request failed"
            );
        }

        return response.data();
    }

    public TwelveDataQuoteDto getQuote(
            String symbol,
            String micCode
    ) {

        return restClient.get()
                .uri(uriBuilder -> {

                    var builder =
                            uriBuilder
                                    .path("/quote")
                                    .queryParam(
                                            "symbol",
                                            symbol
                                    )
                                    .queryParam(
                                            "apikey",
                                            properties.getApiKey()
                                    );

                    /*
                     * Utile pour différencier précisément
                     * certaines actions / ETF.
                     */
                    if (micCode != null
                            && !micCode.isBlank()) {

                        builder.queryParam(
                                "mic_code",
                                micCode
                        );
                    }

                    return builder.build();
                })
                .retrieve()
                .body(
                        TwelveDataQuoteDto.class
                );
    }
}