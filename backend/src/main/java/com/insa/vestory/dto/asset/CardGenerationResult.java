package com.insa.vestory.dto.asset;

public record CardGenerationResult(

        int total,

        int created,

        int updated,

        int common,

        int rare,

        int epic,

        int legendary

) {
}