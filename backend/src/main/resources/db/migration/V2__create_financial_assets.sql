CREATE TABLE financial_assets
(
    id          UUID PRIMARY KEY,

    symbol      VARCHAR(50)              NOT NULL,
    mic_code    VARCHAR(10),
    name        VARCHAR(255)             NOT NULL,
    asset_type  VARCHAR(30)              NOT NULL,

    exchange    VARCHAR(100),
    country     VARCHAR(100),
    currency    VARCHAR(10),

    sector      VARCHAR(100),

    description TEXT,
    logo_url    VARCHAR(500),

    enabled     BOOLEAN                  NOT NULL DEFAULT TRUE,

    created_at  TIMESTAMP WITH TIME ZONE NOT NULL,
    updated_at  TIMESTAMP WITH TIME ZONE NOT NULL
);

CREATE INDEX idx_financial_asset_symbol
    ON financial_assets (symbol);

CREATE INDEX idx_financial_asset_type
    ON financial_assets (asset_type);