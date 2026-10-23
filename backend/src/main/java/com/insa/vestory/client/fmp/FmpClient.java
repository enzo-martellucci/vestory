package com.insa.vestory.client.fmp;

import com.insa.vestory.client.RestClients;
import com.insa.vestory.client.fmp.dto.FmpDailyPriceDto;
import com.insa.vestory.client.fmp.dto.FmpQuoteDto;
import org.springframework.core.ParameterizedTypeReference;
import org.springframework.stereotype.Component;
import org.springframework.web.client.RestClient;

import java.time.LocalDate;
import java.util.List;

@Component
public class FmpClient {

    private final RestClient restClient;
    private final FmpProperties properties;

    public FmpClient(FmpProperties properties) {
        this.properties = properties;
        this.restClient = RestClients.builder(properties.getBaseUrl()).build();
    }

    public FmpQuoteDto getQuote(String symbol) {
        List<FmpQuoteDto> response = getList("/quote", toFmpSymbol(symbol), new ParameterizedTypeReference<List<FmpQuoteDto>>() {
        });

        if (response.isEmpty())
            throw new IllegalStateException("No quote returned by FMP for " + symbol);

        return response.getFirst();
    }

    public List<FmpDailyPriceDto> getDailyPrices(String symbol, LocalDate from) {
        List<FmpDailyPriceDto> response = restClient.get()
                .uri(uri -> uri
                        .path("/historical-price-eod/light")
                        .queryParam("symbol", toFmpSymbol(symbol))
                        .queryParam("from", from)
                        .queryParam("apikey", properties.getApiKey())
                        .build())
                .retrieve()
                .body(new ParameterizedTypeReference<List<FmpDailyPriceDto>>() {
                });

        return response == null ? List.of() : response;
    }

    private String toFmpSymbol(String symbol) {
        return symbol.replace("/", "").trim().toUpperCase();
    }

    private <T> List<T> getList(String path, String symbol, ParameterizedTypeReference<List<T>> responseType) {
        List<T> response = restClient.get()
                .uri(uri -> uri
                        .path(path)
                        .queryParam("symbol", symbol)
                        .queryParam("apikey", properties.getApiKey())
                        .build())
                .retrieve()
                .body(responseType);

        return response == null ? List.of() : response;
    }
}
