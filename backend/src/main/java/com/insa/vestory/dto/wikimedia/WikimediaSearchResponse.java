package com.insa.vestory.dto.wikimedia;

import java.util.List;

public record WikimediaSearchResponse(Query query) {

    public record Query(List<SearchResult> search) {
    }

    public record SearchResult(String title) {
    }
}