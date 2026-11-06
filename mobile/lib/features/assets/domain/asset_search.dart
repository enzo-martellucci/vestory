import 'package:mobile/core/database/app_database.dart';

extension AssetSearch on Asset {
  bool matches(String search) {
    final term = search.trim().toLowerCase();
    return term.isEmpty || name.toLowerCase().contains(term) || symbol.toLowerCase().contains(term);
  }
}
