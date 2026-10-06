CREATE TABLE asset_cards (
                             id UUID PRIMARY KEY,

                             financial_asset_id UUID NOT NULL UNIQUE,

                             rarity VARCHAR(20) NOT NULL,

                             rarity_score DOUBLE PRECISION NOT NULL DEFAULT 0,

                             collection_number INTEGER NOT NULL UNIQUE,

                             enabled BOOLEAN NOT NULL DEFAULT TRUE,

                             created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,

                             CONSTRAINT fk_asset_card_financial_asset
                                 FOREIGN KEY (financial_asset_id)
                                     REFERENCES financial_assets(id)
                                     ON DELETE CASCADE
);