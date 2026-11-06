import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/features/player/domain/player_rules.dart';

void main() {
  group('validateUsername', () {
    test('accepts letters, digits and underscores', () {
      expect(validateUsername('enzo_42'), isNull);
    });

    test('rejects empty, too short, too long and invalid names', () {
      expect(validateUsername('  '), isNotNull);
      expect(validateUsername('ab'), isNotNull);
      expect(validateUsername('a' * 21), isNotNull);
      expect(validateUsername('enzo!'), isNotNull);
    });
  });
}
