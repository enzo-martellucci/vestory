package com.insa.vestory.dto;

import java.util.UUID;

public record UserResponse(
        UUID id,
        String username,
        String email
) {
}
