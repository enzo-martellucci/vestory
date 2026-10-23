package com.insa.vestory.controller;

import com.insa.vestory.dto.asset.AssetResponseDto;
import com.insa.vestory.service.asset.AssetService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;

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

    @PostMapping("/import")
    @ResponseStatus(HttpStatus.NO_CONTENT)
    public void importAll() {
        assetService.importAll();
    }

    @DeleteMapping
    @ResponseStatus(HttpStatus.NO_CONTENT)
    public void deleteAll() {
        assetService.deleteAll();
    }
}
