package com.insa.vestory.dto;

public record AuthResponse(
        String accessToken,
        String refreshToken
) {
}
