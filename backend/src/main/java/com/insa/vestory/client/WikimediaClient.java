package com.insa.vestory.client;

import com.insa.vestory.dto.asset.wikimedia.WikimediaSummaryDto;
import org.springframework.http.HttpHeaders;
import org.springframework.stereotype.Component;
import org.springframework.web.client.HttpClientErrorException;
import org.springframework.web.client.RestClient;
import tools.jackson.databind.JsonNode;
import java.util.HashMap;
import java.util.Map;

@Component
public class WikimediaClient {

    private final RestClient restClient;

    /*
     * Cache en mémoire.
     *
     * Exemple :
     * EUR/USD, EUR/JPY, EUR/GBP utilisent tous "Euro".
     * On ne demande donc Wikimedia qu'une seule fois.
     */
    private final Map<String, WikimediaSummaryDto> cache = new HashMap<>();
    public WikimediaClient() {

        this.restClient = RestClient.builder().baseUrl("https://en.wikipedia.org")
                .defaultHeader(HttpHeaders.USER_AGENT, "Vestory/1.0").build();
    }

    public synchronized WikimediaSummaryDto search(String searchTerm) {

        if (searchTerm == null || searchTerm.isBlank()) {
            return null;
        }

        String cacheKey = searchTerm.trim().toLowerCase();

        /*
         * Si on a déjà demandé cette ressource,
         * aucun nouvel appel Wikimedia.
         */
        if (cache.containsKey(cacheKey)) {
            return cache.get(cacheKey);
        }

        /*
         * Petit délai entre deux nouvelles recherches Wikimedia.
         */
        sleep(750);

        JsonNode response = executeSearch(searchTerm);
        WikimediaSummaryDto result = extractResult(response);

        /*
         * On cache aussi un résultat vide.
         * Cela évite de rechercher 10 fois
         * une page inexistante.
         */
        cache.put(cacheKey, result);

        return result;
    }

    private JsonNode executeSearch(String searchTerm) {

        for (int attempt = 1; attempt <= 3; attempt++) {

            try {

                return restClient.get()
                        .uri(uriBuilder -> uriBuilder
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

            } catch (
                    HttpClientErrorException.TooManyRequests e
            ) {
                System.err.println("Wikimedia rate limit for " + searchTerm + " - attempt " + attempt + "/3");

                if (attempt == 3) {
                    return null;
                }

                sleep(attempt * 3000L);
            }
        }

        return null;
    }

    private WikimediaSummaryDto extractResult(JsonNode response) {

        if (response == null) {
            return null;
        }

        JsonNode pages = response.path("query").path("pages");

        if (!pages.isArray() || pages.isEmpty()) {
            return null;
        }

        JsonNode page = pages.get(0);
        String title = getText(page, "title");
        String extract = getText(page, "extract");
        String imageUrl = null;
        JsonNode thumbnail = page.path("thumbnail");

        if (!thumbnail.isMissingNode() && !thumbnail.isNull()) {
            imageUrl = getText(thumbnail, "source");
        }

        return new WikimediaSummaryDto(title, null, extract,
                imageUrl == null ? null : new WikimediaSummaryDto.Thumbnail(imageUrl, 0, 0));
    }

    private String getText(JsonNode node, String field) {
        JsonNode value = node.path(field);
        if (value.isMissingNode() || value.isNull()) {
            return null;
        }
        return value.asText();
    }

    private void sleep(long milliseconds) {
        try {
            Thread.sleep(milliseconds);
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
        }
    }
}