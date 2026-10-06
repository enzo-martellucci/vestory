package com.insa.vestory.security;

import org.springframework.boot.context.properties.ConfigurationProperties;

import java.time.Duration;

@ConfigurationProperties("vestory.jwt")
public record JwtProperties(
        String issuer,
        String secret,
        Duration accessTokenTtl,
        Duration refreshTokenTtl
) {
}
