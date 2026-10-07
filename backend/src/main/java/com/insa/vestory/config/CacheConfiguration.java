package com.insa.vestory.config;

import com.github.benmanes.caffeine.cache.Caffeine;
import org.springframework.cache.CacheManager;
import org.springframework.cache.annotation.EnableCaching;
import org.springframework.cache.caffeine.CaffeineCacheManager;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import java.time.Duration;

@Configuration
@EnableCaching
public class CacheConfiguration {

    public static final String QUOTES = "quotes";
    public static final String HISTORY = "history";

    private static final long MAXIMUM_ENTRIES = 1_000;

    @Bean
    public CacheManager cacheManager() {
        CaffeineCacheManager cacheManager = new CaffeineCacheManager();
        cacheManager.registerCustomCache(QUOTES, Caffeine.newBuilder()
                .expireAfterWrite(Duration.ofMinutes(1))
                .maximumSize(MAXIMUM_ENTRIES)
                .build());
        cacheManager.registerCustomCache(HISTORY, Caffeine.newBuilder()
                .expireAfterWrite(Duration.ofMinutes(15))
                .maximumSize(MAXIMUM_ENTRIES)
                .build());
        return cacheManager;
    }
}
