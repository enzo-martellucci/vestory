package com.insa.vestory.service;

import com.insa.vestory.entity.RefreshToken;
import com.insa.vestory.entity.User;
import com.insa.vestory.exception.InvalidRefreshTokenException;
import com.insa.vestory.repository.RefreshTokenRepository;
import com.insa.vestory.security.JwtProperties;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;
import java.time.Instant;
import java.util.Base64;
import java.util.HexFormat;

@Service
@RequiredArgsConstructor
public class RefreshTokenService {

    private final RefreshTokenRepository refreshTokenRepository;
    private final JwtProperties jwtProperties;
    private final SecureRandom secureRandom = new SecureRandom();

    public String create(User user) {
        byte[] bytes = new byte[32];
        secureRandom.nextBytes(bytes);
        String token = Base64.getUrlEncoder().withoutPadding().encodeToString(bytes);

        RefreshToken refreshToken = new RefreshToken();
        refreshToken.setUser(user);
        refreshToken.setTokenHash(hash(token));
        refreshToken.setExpiresAt(Instant.now().plus(jwtProperties.refreshTokenTtl()));
        refreshTokenRepository.save(refreshToken);

        return token;
    }

    public User consume(String token) {
        RefreshToken refreshToken = refreshTokenRepository.findByTokenHash(hash(token))
                .orElseThrow(InvalidRefreshTokenException::new);

        Instant now = Instant.now();

        if (refreshToken.isRevoked()) {
            refreshTokenRepository.revokeAllActiveByUser(refreshToken.getUser(), now);
            throw new InvalidRefreshTokenException();
        }
        if (refreshToken.isExpired(now))
            throw new InvalidRefreshTokenException();

        refreshToken.setRevokedAt(now);
        return refreshToken.getUser();
    }

    public void revoke(String token) {
        refreshTokenRepository.findByTokenHash(hash(token))
                .filter(refreshToken -> !refreshToken.isRevoked())
                .ifPresent(refreshToken -> refreshToken.setRevokedAt(Instant.now()));
    }

    private String hash(String token) {
        try {
            byte[] digest = MessageDigest.getInstance("SHA-256").digest(token.getBytes(StandardCharsets.UTF_8));
            return HexFormat.of().formatHex(digest);
        } catch (NoSuchAlgorithmException exception) {
            throw new IllegalStateException(exception);
        }
    }
}
