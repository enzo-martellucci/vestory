package com.insa.vestory.client;

import org.springframework.http.client.SimpleClientHttpRequestFactory;
import org.springframework.web.client.RestClient;

import java.time.Duration;

public final class RestClients {

    private static final Duration CONNECT_TIMEOUT = Duration.ofSeconds(5);
    private static final Duration READ_TIMEOUT = Duration.ofSeconds(15);

    private RestClients() {
    }

    public static RestClient.Builder builder(String baseUrl) {
        SimpleClientHttpRequestFactory requestFactory = new SimpleClientHttpRequestFactory();
        requestFactory.setConnectTimeout(CONNECT_TIMEOUT);
        requestFactory.setReadTimeout(READ_TIMEOUT);

        return RestClient.builder()
                .baseUrl(baseUrl)
                .requestFactory(requestFactory);
    }
}
