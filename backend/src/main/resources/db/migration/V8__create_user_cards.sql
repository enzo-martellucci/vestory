CREATE TABLE user_cards (
                            id UUID PRIMARY KEY,

                            user_id UUID NOT NULL,

                            asset_card_id UUID NOT NULL,

                            quantity INTEGER NOT NULL DEFAULT 1,

                            first_obtained_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,

                            last_obtained_at TIMESTAMP WITH TIME ZONE,

                            CONSTRAINT fk_user_card_user
                                FOREIGN KEY (user_id)
                                    REFERENCES app_user(id)
                                    ON DELETE CASCADE,

                            CONSTRAINT fk_user_card_asset_card
                                FOREIGN KEY (asset_card_id)
                                    REFERENCES asset_cards(id)
                                    ON DELETE CASCADE,

                            CONSTRAINT uk_user_asset_card
                                UNIQUE (user_id, asset_card_id)
);