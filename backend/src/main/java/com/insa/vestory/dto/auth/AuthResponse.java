package com.insa.vestory.dto.auth;

public record AuthResponse(
    String accessToken,
    String refreshToken
) {
}
