import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/core/database/app_database.dart';
import 'package:mobile/core/network/market_client.dart';
import 'package:mobile/core/time/year_month.dart';
import 'package:mobile/features/market/domain/price_history.dart';
import 'package:mobile/features/market/domain/quote.dart';

final marketRepositoryProvider = Provider<MarketRepository>((ref) => MarketRepository(ref.watch(marketClientProvider)));

class MarketRepository {
  final MarketClient client;
  final Duration quoteFreshness;

  MarketRepository(this.client, {this.quoteFreshness = const Duration(hours: 12)});

  Future<PriceHistory> history(Asset asset) => _get(
    '/time_series',
    {
      ..._symbolOf(asset),
      'interval': '1month',
      'start_date': '${historyStartMonth.year}-01-01',
      'outputsize': 5000,
      'order': 'ASC',
    },
    client.cacheOptions,
    (body) => PriceHistory({
      for (final value in (body['values'] as List<dynamic>).cast<Map<String, dynamic>>())
        YearMonth.parse(value['datetime'] as String): double.parse(value['close'] as String),
    }),
  );

  Future<Quote> quote(Asset asset) => _get(
    '/quote',
    _symbolOf(asset),
    client.cacheOptions.copyWith(maxStale: quoteFreshness),
    (body) => Quote(
      price: double.parse(body['close'] as String),
      change: double.tryParse(body['change'] as String? ?? '') ?? 0,
      changePercent: (double.tryParse(body['percent_change'] as String? ?? '') ?? 0) / 100,
      isMarketOpen: body['is_market_open'] as bool? ?? false,
    ),
  );

  Map<String, String> _symbolOf(Asset asset) => {
    'symbol': asset.marketSymbol ?? asset.symbol,
    if (asset.micCode != null) 'mic_code': asset.micCode!,
  };

  Future<T> _get<T>(String path, Map<String, Object> parameters, CacheOptions options, T Function(Map<String, dynamic>) parse) async {
    try {
      final response = await client.dio.get<Map<String, dynamic>>(path, queryParameters: parameters, options: options.toOptions());
      final body = response.data!;
      if (body['status'] == 'error')
        throw MarketException(body['message'] as String? ?? 'Market data is unavailable for this asset.');
      return parse(body);
    } on DioException catch (exception) {
      throw MarketException.from(exception);
    }
  }
}
