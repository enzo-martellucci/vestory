package com.insa.vestory.client.twelvedata;

import lombok.Getter;
import lombok.Setter;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.stereotype.Component;

@Component
@ConfigurationProperties(prefix = "twelve-data")
@Getter
@Setter
public class TwelveDataProperties {

    private String apiKey;
    private String baseUrl;
}