package com.insa.vestory.client.fmp;

import lombok.Getter;
import lombok.Setter;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.stereotype.Component;

@Component
@ConfigurationProperties(prefix = "fmp")
@Getter
@Setter
public class FmpProperties {

    private String apiKey;
    private String baseUrl;
}
