package com.insa.vestory.dto.asset.wikimedia;

public record WikimediaSummaryDto(String title, String description, String extract, Thumbnail thumbnail) {

    public record Thumbnail(String source, int width, int height) {
    }

    public String imageUrl() {
        return thumbnail != null
                ? thumbnail.source()
                : null;
    }
}