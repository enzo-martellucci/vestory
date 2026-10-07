package com.insa.vestory.client.wikimedia;

import com.insa.vestory.client.RestClients;
import com.insa.vestory.client.wikimedia.dto.WikimediaSummaryDto;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpHeaders;
import org.springframework.stereotype.Component;
import org.springframework.web.client.HttpClientErrorException;
import org.springframework.web.client.RestClient;
import tools.jackson.databind.JsonNode;

import java.util.HashMap;
import java.util.Map;
import java.util.Optional;

@Slf4j
@Component
public class WikimediaClient {

    private static final int MAX_ATTEMPTS = 3;
    private static final long DELAY_BETWEEN_SEARCHES_MS = 750;
    private static final long RETRY_BACKOFF_MS = 3000;

    private final RestClient restClient;
    private final Map<String, Optional<WikimediaSummaryDto>> cache = new HashMap<>();

    public WikimediaClient() {
        this.restClient = RestClients.builder("https://en.wikipedia.org")
                .defaultHeader(HttpHeaders.USER_AGENT, "Vestory/1.0")
                .build();
    }

    public synchronized WikimediaSummaryDto search(String searchTerm) {
        if (searchTerm == null || searchTerm.isBlank())
            return null;

        String cacheKey = searchTerm.trim().toLowerCase();
        Optional<WikimediaSummaryDto> cached = cache.get(cacheKey);
        if (cached != null)
            return cached.orElse(null);

        sleep(DELAY_BETWEEN_SEARCHES_MS);
        WikimediaSummaryDto result = extractResult(executeSearch(searchTerm));
        cache.put(cacheKey, Optional.ofNullable(result));

        return result;
    }

    private JsonNode executeSearch(String searchTerm) {
        for (int attempt = 1; attempt <= MAX_ATTEMPTS; attempt++) {
            try {
                return restClient.get()
                        .uri(uri -> uri
                                .path("/w/api.php")
                                .queryParam("action", "query")
                                .queryParam("generator", "search")
                                .queryParam("gsrsearch", searchTerm)
                                .queryParam("gsrlimit", 1)
                                .queryParam("prop", "pageimages|extracts")
                                .queryParam("exintro", true)
                                .queryParam("explaintext", true)
                                .queryParam("piprop", "thumbnail")
                                .queryParam("pithumbsize", 512)
                                .queryParam("format", "json")
                                .queryParam("formatversion", 2)
                                .build())
                        .retrieve()
                        .body(JsonNode.class);
            } catch (HttpClientErrorException.TooManyRequests exception) {
                log.warn("Wikimedia rate limit for {} (attempt {}/{})", searchTerm, attempt, MAX_ATTEMPTS);
                if (attempt < MAX_ATTEMPTS)
                    sleep(attempt * RETRY_BACKOFF_MS);
            }
        }

        return null;
    }

    private WikimediaSummaryDto extractResult(JsonNode response) {
        if (response == null)
            return null;

        JsonNode pages = response.path("query").path("pages");
        if (!pages.isArray() || pages.isEmpty())
            return null;

        JsonNode page = pages.get(0);
        String imageUrl = getText(page.path("thumbnail"), "source");
        WikimediaSummaryDto.Thumbnail thumbnail = imageUrl == null ? null : new WikimediaSummaryDto.Thumbnail(imageUrl, 0, 0);

        return new WikimediaSummaryDto(getText(page, "title"), null, getText(page, "extract"), thumbnail);
    }

    private String getText(JsonNode node, String field) {
        JsonNode value = node.path(field);
        return value.isMissingNode() || value.isNull() ? null : value.asText();
    }

    private void sleep(long milliseconds) {
        try {
            Thread.sleep(milliseconds);
        } catch (InterruptedException exception) {
            Thread.currentThread().interrupt();
        }
    }
}
