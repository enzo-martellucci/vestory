package com.insa.vestory.client;

import com.insa.vestory.config.TwelveDataProperties;
import com.insa.vestory.dto.twelvedata.*;
import org.springframework.core.ParameterizedTypeReference;
import org.springframework.stereotype.Component;
import org.springframework.web.client.RestClient;

@Component
public class TwelveDataClient {

    private final RestClient restClient;
    private final TwelveDataProperties properties;

    public TwelveDataClient(TwelveDataProperties properties) {
        this.properties = properties;

        this.restClient = RestClient.builder()
                .baseUrl(properties.getBaseUrl())
                .build();
    }

    public TwelveDataResponse<TwelveDataStockDto> getStock(String symbol, String micCode) {

        return restClient.get()
                .uri(uriBuilder -> uriBuilder
                        .path("/stocks")
                        .queryParam("symbol", symbol)
                        .queryParam("mic_code", micCode)
                        .queryParam("apikey", properties.getApiKey())
                        .build())
                .retrieve()
                .body(new ParameterizedTypeReference<
                        TwelveDataResponse<TwelveDataStockDto>>() {});
    }

    public TwelveDataResponse<TwelveDataEtfDto> getEtf(String symbol, String micCode) {

        return restClient.get()
                .uri(uriBuilder -> uriBuilder
                        .path("/etfs")
                        .queryParam("symbol", symbol)
                        .queryParam("mic_code", micCode)
                        .queryParam("apikey", properties.getApiKey())
                        .build())
                .retrieve()
                .body(new ParameterizedTypeReference<
                        TwelveDataResponse<TwelveDataEtfDto>>() {});
    }

    public TwelveDataResponse<TwelveDataCryptoDto> getCrypto(String symbol) {

        return restClient.get()
                .uri(uriBuilder -> uriBuilder
                        .path("/cryptocurrencies")
                        .queryParam("symbol", symbol)
                        .queryParam("apikey", properties.getApiKey())
                        .build())
                .retrieve()
                .body(new ParameterizedTypeReference<
                        TwelveDataResponse<TwelveDataCryptoDto>>() {});
    }

    public TwelveDataResponse<TwelveDataForexDto> getForex(String symbol) {

        return restClient.get()
                .uri(uriBuilder -> uriBuilder
                        .path("/forex_pairs")
                        .queryParam("symbol", symbol)
                        .queryParam("apikey", properties.getApiKey())
                        .build())
                .retrieve()
                .body(new ParameterizedTypeReference<
                        TwelveDataResponse<TwelveDataForexDto>>() {});
    }

    public TwelveDataResponse<TwelveDataCommodityDto> getCommodity(String symbol) {

        return restClient.get()
                .uri(uriBuilder -> uriBuilder
                        .path("/commodities")
                        .queryParam("symbol", symbol)
                        .queryParam("apikey", properties.getApiKey())
                        .build())
                .retrieve()
                .body(new ParameterizedTypeReference<
                        TwelveDataResponse<TwelveDataCommodityDto>>() {});
    }
}