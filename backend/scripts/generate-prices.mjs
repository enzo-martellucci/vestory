import { readFileSync, writeFileSync, mkdirSync, existsSync } from 'node:fs';
import { dirname, join } from 'node:path';
import { fileURLToPath } from 'node:url';

const TYPES = ['stock', 'etf', 'crypto', 'forex', 'commodity'];
const FROM = '2005-01-01';
const TWELVE_DATA_DELAY_MS = 8000;

const COMMODITY_SYMBOLS = {
  GCUSD: { symbol: 'XAU/USD' },
  SIUSD: { symbol: 'XAG/USD' },
  PLUSD: { symbol: 'PPLT', micCode: 'ARCX' },
  PAUSD: { symbol: 'PALL', micCode: 'ARCX' },
  CLUSD: { symbol: 'USO', micCode: 'ARCX' },
  BZUSD: { symbol: 'BNO', micCode: 'ARCX' },
  HGUSD: { symbol: 'CPER', micCode: 'ARCX' },
  NGUSD: { symbol: 'UNG', micCode: 'ARCX' },
};

const root = join(dirname(fileURLToPath(import.meta.url)), '..', 'src', 'main', 'resources');
const properties = readFileSync(join(root, 'application-local.properties'), 'utf8');
const property = name => properties.match(new RegExp(`^${name}=(.*)$`, 'm'))[1].trim();
const twelveDataKey = property('TWELVE_DATA_API_KEY');
const fmpKey = property('FMP_DATA_API_KEY');
const currentMonth = new Date().toISOString().slice(0, 7);

const sleep = ms => new Promise(resolve => setTimeout(resolve, ms));

async function fromTwelveData(asset, type) {
  const market = type === 'commodity' ? COMMODITY_SYMBOLS[asset.symbol] : { symbol: asset.symbol, micCode: asset.micCode };
  const params = new URLSearchParams({ symbol: market.symbol, interval: '1month', start_date: FROM, outputsize: '5000', order: 'ASC', apikey: twelveDataKey });
  if (market.micCode)
    params.set('mic_code', market.micCode);

  const body = await (await fetch(`https://api.twelvedata.com/time_series?${params}`)).json();
  if (body.status !== 'ok')
    throw new Error(`Twelve Data ${body.code}: ${body.message}`);

  const closes = {};
  for (const value of body.values) {
    const month = value.datetime.slice(0, 7);
    if (month !== currentMonth)
      closes[month] = Number(value.close);
  }
  return closes;
}

async function fromFmp(asset) {
  const params = new URLSearchParams({ symbol: asset.symbol.replace('/', ''), from: FROM, apikey: fmpKey });
  const response = await fetch(`https://financialmodelingprep.com/stable/historical-price-eod/light?${params}`);
  const text = await response.text();
  if (!text.startsWith('['))
    throw new Error(`FMP: ${text.slice(0, 80)}`);

  const closes = {};
  for (const day of JSON.parse(text).sort((a, b) => a.date.localeCompare(b.date))) {
    const month = day.date.slice(0, 7);
    if (month !== currentMonth)
      closes[month] = day.price;
  }
  return closes;
}

mkdirSync(join(root, 'prices'), { recursive: true });

for (const type of TYPES) {
  const assets = JSON.parse(readFileSync(join(root, 'assets', `${type}.json`), 'utf8'));
  const output = join(root, 'prices', `${type}.json`);
  const prices = existsSync(output) ? JSON.parse(readFileSync(output, 'utf8')) : {};

  for (const asset of assets) {
    if (prices[asset.symbol])
      continue;

    try {
      prices[asset.symbol] = await fromTwelveData(asset, type);
      console.log(`${type} ${asset.symbol} twelve-data ${Object.keys(prices[asset.symbol]).length}`);
    } catch (twelveDataError) {
      try {
        prices[asset.symbol] = await fromFmp(asset);
        console.log(`${type} ${asset.symbol} fmp ${Object.keys(prices[asset.symbol]).length}`);
      } catch (fmpError) {
        console.log(`${type} ${asset.symbol} FAILED ${twelveDataError.message} | ${fmpError.message}`);
      }
    }
    writeFileSync(output, JSON.stringify(prices) + '\n');
    await sleep(TWELVE_DATA_DELAY_MS);
  }

  const ordered = Object.fromEntries(assets.filter(asset => prices[asset.symbol]).map(asset => [asset.symbol, prices[asset.symbol]]));
  writeFileSync(output, JSON.stringify(ordered) + '\n');
}
