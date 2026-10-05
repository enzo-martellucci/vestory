package com.insa.vestory.service;

import com.insa.vestory.client.TwelveDataClient;
import com.insa.vestory.dto.FinancialAssetImportRow;
import com.insa.vestory.dto.twelvedata.*;
import com.insa.vestory.model.entity.FinancialAsset;
import com.insa.vestory.model.enums.AssetType;
import com.insa.vestory.repository.FinancialAssetRepository;
import org.springframework.core.io.ClassPathResource;
import org.springframework.stereotype.Service;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.nio.charset.StandardCharsets;

@Service
public class FinancialAssetImportService {

    private final TwelveDataClient twelveDataClient;
    private final FinancialAssetRepository financialAssetRepository;

    public FinancialAssetImportService(
            TwelveDataClient twelveDataClient,
            FinancialAssetRepository financialAssetRepository
    ) {
        this.twelveDataClient = twelveDataClient;
        this.financialAssetRepository = financialAssetRepository;
    }

    public void importAll() throws Exception {

        ClassPathResource resource =
                new ClassPathResource("import/financial-assets.csv");

        try (BufferedReader reader = new BufferedReader(
                new InputStreamReader(
                        resource.getInputStream(),
                        StandardCharsets.UTF_8
                )
        )) {

            reader.readLine();

            String line;

            while ((line = reader.readLine()) != null) {

                if (line.isBlank()) {
                    continue;
                }

                try {

                    FinancialAssetImportRow row = parseRow(line);

                    importAsset(row);

                    System.out.println(
                            "Imported: " + row.symbol()
                    );

                } catch (Exception e) {

                    System.err.println(
                            "Import failed for: "
                                    + line
                                    + " → "
                                    + e.getMessage()
                    );
                }
            }
        }
    }

    private FinancialAssetImportRow parseRow(String line) {

        String[] columns = line.split(",", -1);

        String symbol = columns[0].trim();
        AssetType type = AssetType.valueOf(columns[1].trim());

        String micCode = columns[2].trim();

        if (micCode.isEmpty()) {
            micCode = null;
        }

        return new FinancialAssetImportRow(symbol, type, micCode
        );
    }

    private void importAsset(FinancialAssetImportRow row) {
        if (financialAssetRepository.existsBySymbolAndAssetType(row.symbol(), row.type())) {
            return;
        }

        FinancialAsset asset = switch (row.type()) {
            case STOCK -> importStock(row);
            case ETF -> importEtf(row);
            case CRYPTO -> importCrypto(row);
            case FOREX -> importForex(row);
            case COMMODITY -> importCommodity(row);
            default -> null;
        };

        if (asset != null) {
            financialAssetRepository.save(asset);
        }
    }

    private FinancialAsset importStock(FinancialAssetImportRow row) {

        var response = twelveDataClient.getStock(
                row.symbol(),
                row.micCode()
        );

        TwelveDataStockDto stock = getFirst(response);

        FinancialAsset asset = new FinancialAsset();

        asset.setSymbol(stock.symbol());
        asset.setName(stock.name());
        asset.setAssetType(AssetType.STOCK);

        asset.setMicCode(stock.micCode());
        asset.setExchange(stock.exchange());
        asset.setCountry(stock.country());
        asset.setCurrency(stock.currency());

        asset.setEnabled(true);

        return asset;
    }

    private FinancialAsset importEtf(FinancialAssetImportRow row) {

        var response = twelveDataClient.getEtf(
                row.symbol(),
                row.micCode()
        );

        TwelveDataEtfDto etf = getFirst(response);

        FinancialAsset asset = new FinancialAsset();

        asset.setSymbol(etf.symbol());
        asset.setName(etf.name());
        asset.setAssetType(AssetType.ETF);

        asset.setMicCode(etf.micCode());
        asset.setExchange(etf.exchange());
        asset.setCountry(etf.country());
        asset.setCurrency(etf.currency());

        asset.setEnabled(true);

        return asset;
    }

    private FinancialAsset importCrypto(FinancialAssetImportRow row) {

        var response =
                twelveDataClient.getCrypto(row.symbol());

        TwelveDataCryptoDto crypto = getFirst(response);

        FinancialAsset asset = new FinancialAsset();

        asset.setSymbol(crypto.symbol());
        asset.setName(crypto.currencyBase());
        asset.setAssetType(AssetType.CRYPTO);

        asset.setCurrency(
                extractQuoteCurrency(crypto.symbol())
        );

        asset.setEnabled(true);

        return asset;
    }

    private FinancialAsset importForex(FinancialAssetImportRow row) {

        var response =
                twelveDataClient.getForex(row.symbol());

        TwelveDataForexDto forex = getFirst(response);

        FinancialAsset asset = new FinancialAsset();

        asset.setSymbol(forex.symbol());

        asset.setName(
                forex.currencyBase()
                        + " / "
                        + forex.currencyQuote()
        );

        asset.setAssetType(AssetType.FOREX);

        asset.setCurrency(
                extractQuoteCurrency(forex.symbol())
        );

        asset.setEnabled(true);

        return asset;
    }

    private FinancialAsset importCommodity(FinancialAssetImportRow row) {

        var response =
                twelveDataClient.getCommodity(row.symbol());

        TwelveDataCommodityDto commodity = getFirst(response);

        FinancialAsset asset = new FinancialAsset();

        asset.setSymbol(commodity.symbol());
        asset.setName(commodity.name());

        asset.setAssetType(AssetType.COMMODITY);

        asset.setCurrency(
                extractQuoteCurrency(commodity.symbol())
        );

        asset.setSector(commodity.category());
        asset.setDescription(commodity.description());

        asset.setEnabled(true);

        return asset;
    }

    private <T> T getFirst(TwelveDataResponse<T> response) {

        if (response == null
                || response.data() == null
                || response.data().isEmpty()) {

            throw new IllegalStateException(
                    "No data returned by Twelve Data"
            );
        }

        return response.data().getFirst();
    }

    private String extractQuoteCurrency(String symbol) {

        if (symbol == null || !symbol.contains("/")) {
            return null;
        }

        String[] parts = symbol.split("/");

        if (parts.length != 2) {
            return null;
        }

        return parts[1];
    }

}