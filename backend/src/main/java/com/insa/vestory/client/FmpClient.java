package com.insa.vestory.client;

import com.insa.vestory.config.FmpProperties;
import com.insa.vestory.dto.asset.fmp.FmpCommodityDto;
import com.insa.vestory.dto.asset.fmp.FmpCryptoDto;
import com.insa.vestory.dto.asset.fmp.FmpForexDto;
import com.insa.vestory.dto.card.FmpCompanyProfileDto;
import com.insa.vestory.dto.card.FmpQuoteDto;
import org.springframework.core.ParameterizedTypeReference;
import org.springframework.stereotype.Component;
import org.springframework.web.client.RestClient;
import java.util.List;

@Component
public class FmpClient {

    private final RestClient restClient;
    private final FmpProperties properties;

    public FmpClient(FmpProperties properties) {

        this.properties = properties;

        this.restClient = RestClient.builder()
                .baseUrl(properties.getBaseUrl())
                .build();
    }

    public FmpCompanyProfileDto getCompanyProfile(String symbol) {

        List<FmpCompanyProfileDto> response =
                restClient.get()
                        .uri(uriBuilder -> uriBuilder
                                .path("/profile")
                                .queryParam("symbol", symbol)
                                .queryParam(
                                        "apikey",
                                        properties.getApiKey()
                                )
                                .build())
                        .retrieve()
                        .body(
                                new ParameterizedTypeReference<
                                        List<FmpCompanyProfileDto>
                                        >() {}
                        );

        if (response == null || response.isEmpty()) {
            throw new IllegalStateException(
                    "No profile returned by FMP for " + symbol
            );
        }

        return response.getFirst();
    }

    public List<FmpForexDto> getForexList() {

        return restClient.get()
                .uri(uriBuilder -> uriBuilder
                        .path("/forex-list")
                        .queryParam(
                                "apikey",
                                properties.getApiKey()
                        )
                        .build())
                .retrieve()
                .body(
                        new ParameterizedTypeReference<List<FmpForexDto>>() {}
                );
    }

    public List<FmpCommodityDto> getCommodityList() {

        return restClient.get()
                .uri(uriBuilder -> uriBuilder
                        .path("/commodities-list")
                        .queryParam(
                                "apikey",
                                properties.getApiKey()
                        )
                        .build())
                .retrieve()
                .body(
                        new ParameterizedTypeReference<List<FmpCommodityDto>>() {}
                );
    }

    public List<FmpCryptoDto> getCryptoList() {

        return restClient.get()
                .uri(uriBuilder -> uriBuilder
                        .path("/cryptocurrency-list")
                        .queryParam("apikey", properties.getApiKey())
                        .build())
                .retrieve()
                .body(
                        new ParameterizedTypeReference<List<FmpCryptoDto>>() {}
                );
    }

    private String toFmpQuoteSymbol(String symbol) {

        if (symbol == null) {
            return null;
        }
        return symbol.replace("/", "").toUpperCase();
    }

    public FmpQuoteDto getQuote(String vestorySymbol) {

        String fmpSymbol = toFmpQuoteSymbol(vestorySymbol);

        List<FmpQuoteDto> response =
                restClient.get()
                        .uri(uriBuilder -> uriBuilder
                                .path("/quote")
                                .queryParam(
                                        "symbol",
                                        fmpSymbol
                                )
                                .queryParam(
                                        "apikey",
                                        properties.getApiKey()
                                )
                                .build())
                        .retrieve()
                        .body(
                                new ParameterizedTypeReference<
                                        List<FmpQuoteDto>
                                        >() {}
                        );

        if (response == null || response.isEmpty()) {

            throw new IllegalStateException(
                    "No quote returned by FMP for "
                            + vestorySymbol
            );
        }

        return response.getFirst();
    }

}