import 'package:mobile/core/database/app_database.dart';

class PackOpening {
  final Asset asset;
  final bool isNew;
  final int gemsEarned;

  const PackOpening({required this.asset, required this.isNew, required this.gemsEarned});
}

class PackException implements Exception {
  final String message;

  const PackException(this.message);

  @override
  String toString() => message;
}
