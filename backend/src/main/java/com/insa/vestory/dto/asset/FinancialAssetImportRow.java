package com.insa.vestory.dto.asset;

import com.insa.vestory.model.enums.AssetType;

public record FinancialAssetImportRow(
        String symbol,
        AssetType type,
        String micCode
) {
}