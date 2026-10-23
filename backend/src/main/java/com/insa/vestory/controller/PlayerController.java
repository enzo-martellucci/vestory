package com.insa.vestory.controller;

import com.insa.vestory.dto.player.AddGemsRequest;
import com.insa.vestory.dto.player.BuyPackRequest;
import com.insa.vestory.dto.player.OwnedAssetDto;
import com.insa.vestory.dto.player.PackOpeningResultDto;
import com.insa.vestory.dto.player.PlayerProfileDto;
import com.insa.vestory.dto.player.UserPackDto;
import com.insa.vestory.service.player.PlayerService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.oauth2.jwt.Jwt;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.UUID;

@RestController
@RequestMapping("/api/me")
@RequiredArgsConstructor
public class PlayerController {

    private final PlayerService playerService;

    @GetMapping("/profile")
    public PlayerProfileDto getProfile(@AuthenticationPrincipal Jwt jwt) {
        return playerService.getProfile(userId(jwt));
    }

    @PostMapping("/gems")
    public PlayerProfileDto addGems(@AuthenticationPrincipal Jwt jwt, @Valid @RequestBody AddGemsRequest request) {
        return playerService.addGems(userId(jwt), request.amount());
    }

    @GetMapping("/assets")
    public List<OwnedAssetDto> getCollection(@AuthenticationPrincipal Jwt jwt) {
        return playerService.getCollection(userId(jwt));
    }

    @PostMapping("/packs/daily")
    @ResponseStatus(HttpStatus.CREATED)
    public UserPackDto claimDailyPack(@AuthenticationPrincipal Jwt jwt) {
        return playerService.claimDailyPack(userId(jwt));
    }

    @PostMapping("/packs/buy")
    @ResponseStatus(HttpStatus.CREATED)
    public UserPackDto buyPack(@AuthenticationPrincipal Jwt jwt, @Valid @RequestBody BuyPackRequest request) {
        return playerService.buyPack(userId(jwt), request.type());
    }

    @PostMapping("/packs/{packId}/open")
    public PackOpeningResultDto openPack(@AuthenticationPrincipal Jwt jwt, @PathVariable UUID packId) {
        return playerService.openPack(userId(jwt), packId);
    }

    private UUID userId(Jwt jwt) {
        return UUID.fromString(jwt.getSubject());
    }
}