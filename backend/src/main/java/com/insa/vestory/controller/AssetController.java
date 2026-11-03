package com.insa.vestory.controller;

import com.insa.vestory.dto.asset.AssetResponseDto;
import com.insa.vestory.service.asset.AssetService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/api/assets")
@RequiredArgsConstructor
public class AssetController {

    private final AssetService assetService;

    @GetMapping
    public List<AssetResponseDto> getAll() {
        return assetService.getAll();
    }
}
