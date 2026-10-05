CREATE TABLE app_user
(
    id         UUID PRIMARY KEY     DEFAULT gen_random_uuid(),
    username   VARCHAR(20) NOT NULL,
    email      VARCHAR(255) NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE UNIQUE INDEX ux_app_user_username ON app_user (lower(username));
CREATE UNIQUE INDEX ux_app_user_email ON app_user (lower(email));

CREATE TYPE auth_provider AS ENUM ('LOCAL', 'GOOGLE');

CREATE TABLE identity
(
    id               UUID PRIMARY KEY       DEFAULT gen_random_uuid(),
    user_id          UUID          NOT NULL REFERENCES app_user (id) ON DELETE CASCADE,
    provider         auth_provider NOT NULL,
    provider_user_id VARCHAR(255),
    password_hash    VARCHAR(255),
    created_at       TIMESTAMPTZ NOT NULL DEFAULT now(),
    last_login_at    TIMESTAMPTZ NOT NULL DEFAULT now(),

    CONSTRAINT ux_identity_user_provider UNIQUE (user_id, provider),
    CONSTRAINT ux_identity_provider_user UNIQUE (provider, provider_user_id),
    CONSTRAINT ck_identity_provider_fields CHECK (
        (provider = 'LOCAL' AND password_hash IS NOT NULL AND provider_user_id IS NULL)
            OR
        (provider = 'GOOGLE' AND password_hash IS NULL AND provider_user_id IS NOT NULL)
        )
);

CREATE TABLE refresh_token
(
    id         UUID PRIMARY KEY     DEFAULT gen_random_uuid(),
    user_id    UUID        NOT NULL REFERENCES app_user (id) ON DELETE CASCADE,
    token_hash VARCHAR(64) NOT NULL,
    expires_at TIMESTAMPTZ NOT NULL,
    revoked_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),

    CONSTRAINT ux_refresh_token_hash UNIQUE (token_hash)
);

CREATE INDEX ix_refresh_token_user ON refresh_token (user_id);
