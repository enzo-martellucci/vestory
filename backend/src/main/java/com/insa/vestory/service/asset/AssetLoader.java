package com.insa.vestory.service.asset;

import com.insa.vestory.constant.AssetType;
import com.insa.vestory.entity.Asset;
import com.insa.vestory.repository.AssetRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.jspecify.annotations.NonNull;
import org.springframework.boot.ApplicationArguments;
import org.springframework.boot.ApplicationRunner;
import org.springframework.core.io.ClassPathResource;
import org.springframework.stereotype.Component;
import tools.jackson.databind.json.JsonMapper;

import java.io.IOException;
import java.io.InputStream;
import java.util.List;

@Slf4j
@Component
@RequiredArgsConstructor
public class AssetLoader implements ApplicationRunner {

    private final AssetRepository assetRepository;
    private final JsonMapper jsonMapper;

    @Override
    public void run(@NonNull ApplicationArguments args) throws IOException {
        if (assetRepository.count() > 0)
            return;

        for (AssetType type : AssetType.values()) {
            String path = "assets/" + type.name().toLowerCase() + ".json";
            try (InputStream input = new ClassPathResource(path).getInputStream()) {
                List<Asset> assets = jsonMapper.readerForListOf(Asset.class).readValue(input);
                assets.forEach(asset -> asset.setType(type));
                assetRepository.saveAll(assets);
                log.info("Loaded {} {} assets", assets.size(), type);
            }
        }
    }
}
