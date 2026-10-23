package com.insa.vestory.service.asset;

import com.insa.vestory.client.fmp.FmpClient;
import com.insa.vestory.client.fmp.dto.FmpCommodityDto;
import com.insa.vestory.client.fmp.dto.FmpCompanyProfileDto;
import com.insa.vestory.client.fmp.dto.FmpCryptoDto;
import com.insa.vestory.client.fmp.dto.FmpForexDto;
import com.insa.vestory.client.wikimedia.WikimediaClient;
import com.insa.vestory.client.wikimedia.dto.WikimediaSummaryDto;
import com.insa.vestory.constant.AssetType;
import com.insa.vestory.dto.asset.AssetImportRow;
import com.insa.vestory.entity.Asset;
import com.insa.vestory.repository.AssetRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.core.io.ClassPathResource;
import org.springframework.stereotype.Service;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.UncheckedIOException;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.function.Function;
import java.util.stream.Collectors;

@Slf4j
@Service
@RequiredArgsConstructor
public class AssetImportService {

    private final FmpClient fmpClient;
    private final WikimediaClient wikimediaClient;
    private final AssetRepository assetRepository;

    public void importAll() {
        List<AssetImportRow> missingRows = readCsv().stream()
            .filter(row -> !assetRepository.existsBySymbolAndType(row.symbol(), row.type()))
            .toList();

        if (missingRows.isEmpty()) {
            log.info("Nothing to import");
            return;
        }

        Map<String, FmpCryptoDto> cryptoBySymbol = containsType(missingRows, AssetType.CRYPTO)
            ? bySymbol(fmpClient.getCryptoList(), FmpCryptoDto::symbol)
            : Map.of();
        Map<String, FmpForexDto> forexBySymbol = containsType(missingRows, AssetType.FOREX)
            ? bySymbol(fmpClient.getForexList(), FmpForexDto::symbol)
            : Map.of();
        Map<String, FmpCommodityDto> commodityBySymbol = containsType(missingRows, AssetType.COMMODITY)
            ? bySymbol(fmpClient.getCommodityList(), FmpCommodityDto::symbol)
            : Map.of();

        for (AssetImportRow row : missingRows) {
            try {
                Asset asset = switch (row.type()) {
                    case STOCK, ETF -> importProfileAsset(row);
                    case CRYPTO -> importCrypto(row, cryptoBySymbol);
                    case FOREX -> importForex(row, forexBySymbol);
                    case COMMODITY -> importCommodity(row, commodityBySymbol);
                };
                assetRepository.save(asset);
                log.info("Imported {}", row.symbol());
            } catch (RuntimeException exception) {
                log.warn("Import failed for {}: {}", row.symbol(), exception.getMessage());
            }
        }
    }

    private List<AssetImportRow> readCsv() {
        List<AssetImportRow> rows = new ArrayList<>();
        ClassPathResource resource = new ClassPathResource("import/financial-assets.csv");

        try (BufferedReader reader = new BufferedReader(new InputStreamReader(resource.getInputStream(), StandardCharsets.UTF_8))) {
            reader.readLine();
            String line;
            while ((line = reader.readLine()) != null)
                if (!line.isBlank())
                    rows.add(parseRow(line));
        } catch (IOException exception) {
            throw new UncheckedIOException("Unable to read financial assets CSV", exception);
        }
        return rows;
    }

    private AssetImportRow parseRow(String line) {
        String[] columns = line.split(",", -1);
        String micCode = columns[2].trim();
        return new AssetImportRow(columns[0].trim(), AssetType.valueOf(columns[1].trim()), micCode.isEmpty() ? null : micCode);
    }

    private Asset importProfileAsset(AssetImportRow row) {
        FmpCompanyProfileDto profile = fmpClient.getCompanyProfile(row.symbol());

        Asset asset = new Asset();
        asset.setSymbol(row.symbol());
        asset.setName(profile.companyName());
        asset.setType(row.type());
        asset.setMicCode(row.micCode());
        asset.setExchange(profile.exchange());
        asset.setCountry(profile.country());
        asset.setCurrency(profile.currency());
        asset.setSector(profile.sector());
        asset.setIndustry(profile.industry());
        asset.setDescription(profile.description());
        asset.setLogoUrl(profile.image());
        return asset;
    }

    private Asset importCrypto(AssetImportRow row, Map<String, FmpCryptoDto> cryptoBySymbol) {
        String fmpSymbol = row.symbol().replace("/", "").toUpperCase();
        FmpCryptoDto crypto = cryptoBySymbol.get(fmpSymbol);
        if (crypto == null)
            throw new IllegalStateException("Crypto not found in FMP: " + fmpSymbol);

        String name = cleanCryptoName(crypto.name());

        Asset asset = new Asset();
        asset.setSymbol(row.symbol());
        asset.setName(name);
        asset.setType(AssetType.CRYPTO);
        asset.setExchange(crypto.exchange());
        asset.setCurrency("USD");
        asset.setSector("Cryptocurrency");

        WikimediaSummaryDto wiki = wikimediaClient.search(name + " cryptocurrency");
        if (wiki != null) {
            asset.setDescription(wiki.extract());
            asset.setLogoUrl(wiki.imageUrl());
        }
        return asset;
    }

    private Asset importForex(AssetImportRow row, Map<String, FmpForexDto> forexBySymbol) {
        String fmpSymbol = row.symbol().replace("/", "").toUpperCase();
        FmpForexDto forex = forexBySymbol.get(fmpSymbol);
        if (forex == null)
            throw new IllegalStateException("Forex not found in FMP: " + fmpSymbol);

        Asset asset = new Asset();
        asset.setSymbol(row.symbol());
        asset.setName(forex.fromName() + " / " + forex.toName());
        asset.setType(AssetType.FOREX);
        asset.setCurrency(forex.toCurrency());
        asset.setExchange("FOREX");
        asset.setDescription(buildForexDescription(forex));

        WikimediaSummaryDto wiki = wikimediaClient.search(forex.fromName());
        if (wiki != null)
            asset.setLogoUrl(wiki.imageUrl());
        return asset;
    }

    private Asset importCommodity(AssetImportRow row, Map<String, FmpCommodityDto> commodityBySymbol) {
        FmpCommodityDto commodity = commodityBySymbol.get(row.symbol().toUpperCase());
        if (commodity == null)
            throw new IllegalStateException("Commodity not found in FMP: " + row.symbol());

        String name = cleanCommodityName(commodity.name());

        Asset asset = new Asset();
        asset.setSymbol(commodity.symbol());
        asset.setName(name);
        asset.setType(AssetType.COMMODITY);
        asset.setExchange(commodity.exchange());
        asset.setCurrency(commodity.currency());

        WikimediaSummaryDto wiki = wikimediaClient.search(name);
        if (wiki != null) {
            asset.setDescription(wiki.extract());
            asset.setLogoUrl(wiki.imageUrl());
        }
        return asset;
    }

    private boolean containsType(List<AssetImportRow> rows, AssetType type) {
        return rows.stream().anyMatch(row -> row.type() == type);
    }

    private <T> Map<String, T> bySymbol(List<T> items, Function<T, String> symbol) {
        if (items == null)
            return Map.of();
        return items.stream().collect(Collectors.toMap(symbol, Function.identity(), (first, second) -> first));
    }

    private String cleanCryptoName(String name) {
        if (name == null)
            return null;
        return name.replaceAll("(?i)\\s+USD$", "").trim();
    }

    private String cleanCommodityName(String name) {
        if (name == null)
            return null;
        return name.replace("Micro ", "").replace(" Futures", "").trim();
    }

    private String buildForexDescription(FmpForexDto forex) {
        return forex.fromCurrency() + "/" + forex.toCurrency()
            + " represents the exchange rate between " + forex.fromName() + " and " + forex.toName()
            + ". It indicates how many units of " + forex.toName()
            + " are required to purchase one unit of " + forex.fromName() + ".";
    }
}
