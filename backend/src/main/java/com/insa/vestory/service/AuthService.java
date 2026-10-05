package com.insa.vestory.service;

import com.insa.vestory.dto.RegisterRequest;
import com.insa.vestory.dto.RegisterResponse;
import com.insa.vestory.entity.AuthProvider;
import com.insa.vestory.entity.Identity;
import com.insa.vestory.entity.User;
import com.insa.vestory.exception.DuplicateResourceException;
import com.insa.vestory.mapper.UserMapper;
import com.insa.vestory.repository.IdentityRepository;
import com.insa.vestory.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Locale;

@Service
@RequiredArgsConstructor
public class AuthService {

    private final UserRepository userRepository;
    private final IdentityRepository identityRepository;
    private final PasswordEncoder passwordEncoder;
    private final UserMapper userMapper;

    @Transactional
    public RegisterResponse register(RegisterRequest request) {
        String username = request.username().toLowerCase(Locale.ROOT);
        String email = request.email().toLowerCase(Locale.ROOT);

        if (userRepository.existsByUsername(username))
            throw new DuplicateResourceException("Username already exists");
        if (userRepository.existsByEmail(email))
            throw new DuplicateResourceException("Email already exists");

        User user = new User();
        user.setUsername(username);
        user.setEmail(email);
        userRepository.save(user);

        Identity identity = new Identity();
        identity.setUser(user);
        identity.setProvider(AuthProvider.LOCAL);
        identity.setPasswordHash(passwordEncoder.encode(request.password()));
        identityRepository.save(identity);

        return userMapper.toRegisterResponse(user);
    }
}
