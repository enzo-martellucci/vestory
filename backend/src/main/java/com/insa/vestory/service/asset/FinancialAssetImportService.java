package com.insa.vestory.service.asset;

import com.insa.vestory.client.fmp.FmpClient;
import com.insa.vestory.client.fmp.dto.FmpCommodityDto;
import com.insa.vestory.client.fmp.dto.FmpCompanyProfileDto;
import com.insa.vestory.client.fmp.dto.FmpCryptoDto;
import com.insa.vestory.client.fmp.dto.FmpForexDto;
import com.insa.vestory.client.wikimedia.WikimediaClient;
import com.insa.vestory.client.wikimedia.dto.WikimediaSummaryDto;
import com.insa.vestory.dto.asset.FinancialAssetImportRow;
import com.insa.vestory.model.entity.FinancialAsset;
import com.insa.vestory.model.enums.AssetType;
import com.insa.vestory.repository.FinancialAssetRepository;
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
public class FinancialAssetImportService {

    private final FmpClient fmpClient;
    private final WikimediaClient wikimediaClient;
    private final FinancialAssetRepository financialAssetRepository;

    public FinancialAssetImportService(FmpClient fmpClient, WikimediaClient wikimediaClient, FinancialAssetRepository financialAssetRepository) {
        this.fmpClient = fmpClient;
        this.wikimediaClient = wikimediaClient;
        this.financialAssetRepository = financialAssetRepository;
    }

    public void importAll() {

        List<FinancialAssetImportRow> rows = readCsv();
        List<FinancialAssetImportRow> missingRows =
                rows.stream()
                        .filter(row ->
                                !financialAssetRepository
                                        .existsBySymbolAndAssetType(
                                                row.symbol(),
                                                row.type()
                                        )
                        )
                        .toList();

        if (missingRows.isEmpty()) {
            log.info("Nothing to import");
            return;
        }

        Map<String, FmpCryptoDto> cryptoBySymbol = containsType(missingRows, AssetType.CRYPTO)
                        ? toCryptoMap(fmpClient.getCryptoList())
                        : Map.of();

        Map<String, FmpForexDto> forexBySymbol = containsType(missingRows, AssetType.FOREX)
                        ? toForexMap(fmpClient.getForexList())
                        : Map.of();

        Map<String, FmpCommodityDto> commodityBySymbol = containsType(missingRows, AssetType.COMMODITY)
                        ? toCommodityMap(fmpClient.getCommodityList())
                        : Map.of();

        for (FinancialAssetImportRow row : missingRows) {
            try {
                importAsset(row, cryptoBySymbol, forexBySymbol, commodityBySymbol);
                log.info("Imported {}", row.symbol());
            } catch (RuntimeException exception) {
                log.warn("Import failed for {}: {}", row.symbol(), exception.getMessage());
            }
        }
    }

    private boolean containsType(List<FinancialAssetImportRow> rows, AssetType type) {
        return rows.stream().anyMatch(row -> row.type() == type);
    }

    private List<FinancialAssetImportRow> readCsv() {
        List<FinancialAssetImportRow> rows = new ArrayList<>();

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


    private FinancialAssetImportRow parseRow(String line) {

        String[] columns = line.split(",", -1);

        String symbol = columns[0].trim();

        AssetType type = AssetType.valueOf(columns[1].trim());

        String micCode = columns[2].trim();
        return new FinancialAssetImportRow(symbol, type, micCode.isEmpty() ? null : micCode);
    }

    private void importAsset(FinancialAssetImportRow row, Map<String, FmpCryptoDto> cryptoBySymbol, Map<String, FmpForexDto> forexBySymbol, Map<String, FmpCommodityDto> commodityBySymbol) {

        if (financialAssetRepository.existsBySymbolAndAssetType(row.symbol(), row.type()))
            return;

        FinancialAsset asset =
                switch (row.type()) {
                    case STOCK -> importProfileAsset(row, AssetType.STOCK, row.symbol());
                    case ETF -> importProfileAsset(row, AssetType.ETF, row.symbol());
                    case CRYPTO -> importCrypto(row, cryptoBySymbol);
                    case FOREX -> importForex(row, forexBySymbol);
                    case COMMODITY -> importCommodity(row, commodityBySymbol);
                };

        financialAssetRepository.save(asset);
    }

    private FinancialAsset importProfileAsset(FinancialAssetImportRow row, AssetType assetType, String fmpSymbol) {

        FmpCompanyProfileDto profile = fmpClient.getCompanyProfile(fmpSymbol);
        FinancialAsset asset = new FinancialAsset();
        asset.setSymbol(row.symbol());
        asset.setName(profile.companyName());
        asset.setAssetType(assetType);
        asset.setMicCode(row.micCode());
        asset.setExchange(profile.exchange());
        asset.setCountry(profile.country());
        asset.setCurrency(profile.currency());
        asset.setSector(profile.sector());
        asset.setIndustry(profile.industry());
        asset.setDescription(profile.description());
        asset.setWebsite(profile.website());
        asset.setLogoUrl(profile.image());
        asset.setEnabled(true);

        return asset;
    }

    private FinancialAsset importForex(FinancialAssetImportRow row, Map<String, FmpForexDto> forexBySymbol) {

        String fmpSymbol = row.symbol().replace("/", "").toUpperCase();
        FmpForexDto forex = forexBySymbol.get(fmpSymbol);

        if (forex == null)
            throw new IllegalStateException("Forex not found in FMP: " + fmpSymbol);

        FinancialAsset asset = new FinancialAsset();
        asset.setSymbol(row.symbol());

        asset.setName(forex.fromName() + " / " + forex.toName());
        asset.setAssetType(AssetType.FOREX);
        asset.setCurrency(forex.toCurrency());
        asset.setExchange("FOREX");
        asset.setDescription(buildForexDescription(forex));

        WikimediaSummaryDto wiki = wikimediaClient.search(forex.fromName());
        if (wiki != null)
            asset.setLogoUrl(wiki.imageUrl());
        asset.setEnabled(true);

        return asset;
    }

    private FinancialAsset importCommodity(FinancialAssetImportRow row, Map<String, FmpCommodityDto> commodityBySymbol) {

        FmpCommodityDto commodity = commodityBySymbol.get(row.symbol().toUpperCase());

        if (commodity == null)
            throw new IllegalStateException("Commodity not found in FMP: " + row.symbol());

        FinancialAsset asset = new FinancialAsset();
        asset.setSymbol(commodity.symbol());
        asset.setName(cleanCommodityName(commodity.name()));
        asset.setAssetType(AssetType.COMMODITY);
        asset.setExchange(commodity.exchange());
        asset.setCurrency(commodity.currency());
        String searchTerm = cleanCommodityName(commodity.name());
        WikimediaSummaryDto wiki = wikimediaClient.search(searchTerm);
        if (wiki != null) {
            asset.setDescription(wiki.extract());
            asset.setLogoUrl(wiki.imageUrl());
        }
        asset.setEnabled(true);
        return asset;
    }

    private Map<String, FmpForexDto> toForexMap(List<FmpForexDto> list) {
        if (list == null)
            return Map.of();

        return list.stream()
                .collect(Collectors.toMap(FmpForexDto::symbol,
                        Function.identity(), (first, second) -> first));
    }

    private Map<String, FmpCommodityDto> toCommodityMap(List<FmpCommodityDto> list) {

        if (list == null)
            return Map.of();

        return list.stream().collect(Collectors.toMap(FmpCommodityDto::symbol,
                        Function.identity(), (first, second) -> first)
                );
    }

    private String cleanCommodityName(String name) {

        if (name == null)
            return null;
        return name.replace("Micro ", "").replace(" Futures", "").trim();
    }

    private String buildForexDescription(FmpForexDto forex) {

        return forex.fromCurrency()
                + "/"
                + forex.toCurrency()
                + " represents the exchange rate between "
                + forex.fromName()
                + " and "
                + forex.toName()
                + ". It indicates how many units of "
                + forex.toName()
                + " are required to purchase one unit of "
                + forex.fromName()
                + ".";
    }

    private Map<String, FmpCryptoDto> toCryptoMap(List<FmpCryptoDto> list) {

        if (list == null)
            return Map.of();

        return list.stream().collect(Collectors.toMap(FmpCryptoDto::symbol,
                                Function.identity(), (first, second) -> first));
    }

    private FinancialAsset importCrypto(FinancialAssetImportRow row, Map<String, FmpCryptoDto> cryptoBySymbol) {

        String fmpSymbol = row.symbol().replace("/", "").toUpperCase();

        FmpCryptoDto crypto = cryptoBySymbol.get(fmpSymbol);

        if (crypto == null)
            throw new IllegalStateException("Crypto not found in FMP: " + fmpSymbol);

        FinancialAsset asset = new FinancialAsset();

        asset.setSymbol(row.symbol());

        String name = cleanCryptoName(crypto.name());

        asset.setName(name);
        asset.setAssetType(AssetType.CRYPTO);
        asset.setExchange(crypto.exchange());

        asset.setCurrency("USD");
        asset.setSector("Cryptocurrency");
        WikimediaSummaryDto wiki = wikimediaClient.search(name + " cryptocurrency");

        if (wiki != null) {
            asset.setDescription(wiki.extract());
            asset.setLogoUrl(wiki.imageUrl());
        }

        asset.setEnabled(true);

        return asset;
    }

    private String cleanCryptoName(String name) {

        if (name == null)
            return null;
        return name.replaceAll("(?i)\\s+USD$", "").trim();
    }
}