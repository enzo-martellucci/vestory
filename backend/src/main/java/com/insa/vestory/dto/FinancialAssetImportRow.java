package com.insa.vestory.dto;

import com.insa.vestory.model.enums.AssetType;

public record FinancialAssetImportRow(
        String symbol,
        AssetType type,
        String micCode
) {
}