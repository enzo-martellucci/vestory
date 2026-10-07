package com.insa.vestory.client.fmp;

import com.insa.vestory.client.RestClients;
import com.insa.vestory.client.fmp.dto.FmpCommodityDto;
import com.insa.vestory.client.fmp.dto.FmpCompanyProfileDto;
import com.insa.vestory.client.fmp.dto.FmpCryptoDto;
import com.insa.vestory.client.fmp.dto.FmpForexDto;
import com.insa.vestory.client.fmp.dto.FmpQuoteDto;
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
        this.restClient = RestClients.builder(properties.getBaseUrl()).build();
    }

    public FmpCompanyProfileDto getCompanyProfile(String symbol) {
        List<FmpCompanyProfileDto> response = getList("/profile", symbol, new ParameterizedTypeReference<List<FmpCompanyProfileDto>>() {
        });

        if (response.isEmpty())
            throw new IllegalStateException("No profile returned by FMP for " + symbol);

        return response.getFirst();
    }

    public FmpQuoteDto getQuote(String symbol) {
        String fmpSymbol = symbol.replace("/", "").toUpperCase();
        List<FmpQuoteDto> response = getList("/quote", fmpSymbol, new ParameterizedTypeReference<List<FmpQuoteDto>>() {
        });

        if (response.isEmpty())
            throw new IllegalStateException("No quote returned by FMP for " + symbol);

        return response.getFirst();
    }

    public List<FmpForexDto> getForexList() {
        return getList("/forex-list", null, new ParameterizedTypeReference<List<FmpForexDto>>() {
        });
    }

    public List<FmpCommodityDto> getCommodityList() {
        return getList("/commodities-list", null, new ParameterizedTypeReference<List<FmpCommodityDto>>() {
        });
    }

    public List<FmpCryptoDto> getCryptoList() {
        return getList("/cryptocurrency-list", null, new ParameterizedTypeReference<List<FmpCryptoDto>>() {
        });
    }

    private <T> List<T> getList(String path, String symbol, ParameterizedTypeReference<List<T>> responseType) {
        List<T> response = restClient.get()
                .uri(uri -> {
                    uri.path(path).queryParam("apikey", properties.getApiKey());
                    if (symbol != null)
                        uri.queryParam("symbol", symbol);
                    return uri.build();
                })
                .retrieve()
                .body(responseType);

        return response == null ? List.of() : response;
    }
}
