package com.insa.vestory.controller;

import com.insa.vestory.dto.UserResponse;
import com.insa.vestory.service.UserService;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.oauth2.jwt.Jwt;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.Objects;
import java.util.UUID;

@RestController
@RequestMapping("/api/users")
@RequiredArgsConstructor
public class UserController {

    private final UserService userService;

    @GetMapping("/me")
    public UserResponse getCurrentUser(@AuthenticationPrincipal Jwt jwt) {
        return userService.getUser(UUID.fromString(Objects.requireNonNull(jwt.getSubject())));
    }
}
