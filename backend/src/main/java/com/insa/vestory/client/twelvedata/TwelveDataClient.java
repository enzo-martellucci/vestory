package com.insa.vestory.client.twelvedata;

import com.insa.vestory.client.MarketDataUnavailableException;
import com.insa.vestory.client.RestClients;
import com.insa.vestory.client.twelvedata.dto.TwelveDataForexPairDto;
import com.insa.vestory.client.twelvedata.dto.TwelveDataForexPairsResponse;
import com.insa.vestory.client.twelvedata.dto.TwelveDataQuoteDto;
import com.insa.vestory.client.twelvedata.dto.TwelveDataTimeSeriesDto;
import org.springframework.stereotype.Component;
import org.springframework.web.client.RestClient;
import org.springframework.web.client.RestClientException;
import org.springframework.web.util.UriBuilder;

import java.net.URI;
import java.util.List;
import java.util.function.Function;

@Component
public class TwelveDataClient {

    private static final String ERROR_STATUS = "error";

    private final RestClient restClient;
    private final TwelveDataProperties properties;

    public TwelveDataClient(TwelveDataProperties properties) {
        this.properties = properties;
        this.restClient = RestClients.builder(properties.getBaseUrl()).build();
    }

    public List<TwelveDataForexPairDto> getForexPairs() {
        TwelveDataForexPairsResponse response = get(uri -> uri
                .path("/forex_pairs")
                .queryParam("apikey", properties.getApiKey())
                .build(), TwelveDataForexPairsResponse.class);

        if (ERROR_STATUS.equalsIgnoreCase(response.status()))
            throw new MarketDataUnavailableException("Twelve Data forex_pairs request failed");

        return response.data() == null ? List.of() : response.data();
    }

    public TwelveDataQuoteDto getQuote(String symbol, String micCode) {
        TwelveDataQuoteDto quote = get(uri -> withMicCode(uri
                .path("/quote")
                .queryParam("symbol", symbol)
                .queryParam("apikey", properties.getApiKey()), micCode)
                .build(), TwelveDataQuoteDto.class);

        if (ERROR_STATUS.equalsIgnoreCase(quote.status()))
            throw new MarketDataUnavailableException("Twelve Data error for " + symbol + ": " + quote.message());

        return quote;
    }

    public TwelveDataTimeSeriesDto getTimeSeries(String symbol, String micCode) {
        TwelveDataTimeSeriesDto timeSeries = get(uri -> withMicCode(uri
                .path("/time_series")
                .queryParam("symbol", symbol)
                .queryParam("interval", "1h")
                .queryParam("outputsize", 24)
                .queryParam("timezone", "UTC")
                .queryParam("apikey", properties.getApiKey()), micCode)
                .build(), TwelveDataTimeSeriesDto.class);

        if (ERROR_STATUS.equalsIgnoreCase(timeSeries.status()))
            throw new MarketDataUnavailableException("Twelve Data error for " + symbol + ": " + timeSeries.message());

        return timeSeries;
    }

    private <T> T get(Function<UriBuilder, URI> uri, Class<T> responseType) {
        T body;
        try {
            body = restClient.get()
                    .uri(uri)
                    .retrieve()
                    .body(responseType);
        } catch (RestClientException exception) {
            throw new MarketDataUnavailableException("Twelve Data request failed", exception);
        }

        if (body == null)
            throw new MarketDataUnavailableException("Empty response from Twelve Data");

        return body;
    }

    private UriBuilder withMicCode(UriBuilder uri, String micCode) {
        if (micCode != null && !micCode.isBlank())
            uri.queryParam("mic_code", micCode);

        return uri;
    }
}
