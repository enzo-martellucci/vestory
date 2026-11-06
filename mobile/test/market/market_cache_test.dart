import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/network/market_client.dart';
import 'package:mobile/core/time/year_month.dart';
import 'package:mobile/features/market/data/market_repository.dart';

import '../fixtures.dart';

const _history = {
  'status': 'ok',
  'values': [
    {'datetime': '2010-01-01', 'close': '10.5'},
    {'datetime': '2010-02-01', 'close': '12.5'},
  ],
};

const _quote = {'close': '338.32', 'change': '-6.31', 'percent_change': '-1.83', 'currency': 'USD', 'is_market_open': false, 'datetime': '2026-11-02'};

class FakeNetwork implements HttpClientAdapter {
  var calls = 0;
  var offline = false;
  var statusCode = 200;

  @override
  Future<ResponseBody> fetch(RequestOptions options, Stream<Uint8List>? requestStream, Future<void>? cancelFuture) async {
    calls++;
    if (offline)
      throw DioException.connectionError(requestOptions: options, reason: 'offline');

    final body = options.path.endsWith('/quote') ? _quote : _history;
    return ResponseBody.fromString(jsonEncode(body), statusCode, headers: {
      Headers.contentTypeHeader: [Headers.jsonContentType],
    });
  }

  @override
  void close({bool force = false}) {}
}

void main() {
  late Directory directory;
  late FakeNetwork network;
  late MarketClient client;
  final apple = asset(1);

  MarketClient open() => MarketClient.create(directory.path)..dio.httpClientAdapter = network;

  setUp(() async {
    directory = await Directory.systemTemp.createTemp('market_cache');
    network = FakeNetwork();
    client = open();
  });

  tearDown(() async {
    await client.close();
    await directory.delete(recursive: true);
  });

  test('the history is fetched once, then read from the disk', () async {
    final repository = MarketRepository(client);

    final first = await repository.history(apple);
    final second = await repository.history(apple);

    expect(network.calls, 1);
    expect(first.priceAt(const YearMonth(2010, 2)), 12.5);
    expect(second.priceAt(const YearMonth(2010, 2)), 12.5);
  });

  test('the history survives an app restart and works offline', () async {
    await MarketRepository(client).history(apple);
    await client.close();

    network.offline = true;
    client = open();
    final history = await MarketRepository(client).history(apple);

    expect(network.calls, 1);
    expect(history.points, hasLength(2));
  });

  test('an asset that was never loaded fails offline with a clear message', () async {
    network.offline = true;

    await expectLater(MarketRepository(client).history(apple), throwsA(isA<MarketException>()));
  });

  test('each asset has its own cache entry', () async {
    final repository = MarketRepository(client);

    await repository.history(asset(1));
    await repository.history(asset(2));
    await repository.history(asset(1));

    expect(network.calls, 2);
  });

  test('errors are not cached', () async {
    final repository = MarketRepository(client);

    network.statusCode = 429;
    await expectLater(repository.history(apple), throwsA(isA<MarketException>()));

    network.statusCode = 200;
    final history = await repository.history(apple);

    expect(network.calls, 2);
    expect(history.points, hasLength(2));
  });

  test('the quote is reused while fresh and fetched again once expired', () async {
    final fresh = MarketRepository(client);
    expect((await fresh.quote(apple)).price, 338.32);
    await fresh.quote(apple);
    expect(network.calls, 1);

    final expiring = MarketRepository(client, quoteFreshness: const Duration(seconds: 1));
    await expiring.quote(asset(2));
    await Future<void>.delayed(const Duration(seconds: 2));
    await expiring.quote(asset(2));
    expect(network.calls, 3);
  });
}
