# Rarity computation

Rarities are stored as static data in `src/main/resources/assets/*.json`. They were computed once with the algorithm below, which was removed from the code because it needed about 200 API calls and changed the rarity of assets players already owned. Use it as a reference when adding new assets.

## Market data

| Type | Source | Data |
|---|---|---|
| STOCK, ETF | FMP `/profile` | market cap, volume |
| CRYPTO, COMMODITY | FMP `/quote` | market cap, volume |
| FOREX | Twelve Data `/forex_pairs` | currency group (`Major`, `Minor`, `Exotic`, `Exotic-Cross`) |

The computation was aborted when market data was available for less than 80% of the assets.

## Score (0 to 100)

The score is computed within each asset type, so assets are only compared with assets of the same type.

- **STOCK, ETF, CRYPTO**: `percentile(marketCap) * 0.80 + percentile(volume) * 0.20`. When the market cap is missing, the score is `percentile(volume)` only.
- **COMMODITY**: `percentile(volume)`, or `50` when no data is available.
- **FOREX**: fixed score by currency group: Major `100`, Minor `70`, Exotic `40`, Exotic-Cross `20`, otherwise `0`.
- Any other asset without data gets `0`.

`percentile(value)` is the share of the other positive values of the same type that are strictly lower than `value`: `below / (count - 1) * 100`. It is `0` for a missing or non-positive value, and `100` when the value is the only one of its type.

## Rarity

All assets are ranked together by descending score, then by symbol. Rarities are assigned by quota on this ranking:

| Rank | Rarity |
|---|---|
| top 10% | LEGENDARY |
| next 15% | EPIC |
| next 25% | RARE |
| remaining 50% | COMMON |

Each quota is `round(total * share)`.
