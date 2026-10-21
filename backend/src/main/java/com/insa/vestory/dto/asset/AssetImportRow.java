package com.insa.vestory.dto.asset;

import com.insa.vestory.constant.AssetType;

public record AssetImportRow(
    String symbol,
    AssetType type,
    String micCode
) {
}