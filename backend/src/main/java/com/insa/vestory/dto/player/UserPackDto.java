package com.insa.vestory.dto.player;

import com.insa.vestory.model.enums.PackSource;
import com.insa.vestory.model.enums.PackType;

import java.time.Instant;
import java.util.UUID;

public record UserPackDto(UUID id, PackType type, PackSource source, Instant obtainedAt) {
}