import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/features/invest/data/models/price_point.dart';
import 'package:mobile/features/invest/data/sample_history.dart';

final investRepositoryProvider = Provider<InvestRepository>((ref) => InvestRepository());

class InvestRepository {
  static const _simulatedLatency = Duration(milliseconds: 300);

  final DateTime Function() now;

  InvestRepository({this.now = DateTime.now});

  Future<List<PricePoint>> getMonthlyHistory(int assetId, int years) async {
    await Future<void>.delayed(_simulatedLatency);
    return sampleMonthlyHistory(seed: assetId.toString(), years: years, now: now());
  }
}
