import 'package:material_ui/material_ui.dart';
import 'package:mobile/core/theme/app_colors.dart';
import 'package:mobile/features/cards/data/models/rarity.dart';
import 'package:mobile/features/player/data/models/pack_type.dart';

class PackOddsBar extends StatelessWidget {
  final PackType type;

  const PackOddsBar({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    final rarities = Rarity.values.where((rarity) => type.oddsOf(rarity) > 0).toList();

    return Column(
      crossAxisAlignment: .start,
      spacing: 8,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: SizedBox(
            height: 10,
            child: Row(
              children: [
                for (final rarity in rarities)
                  Expanded(
                    flex: (type.oddsOf(rarity) * 100).round(),
                    child: ColoredBox(color: rarity.color),
                  ),
              ],
            ),
          ),
        ),
        Wrap(
          spacing: 12,
          runSpacing: 4,
          children: [
            for (final rarity in rarities)
              Row(
                mainAxisSize: .min,
                spacing: 4,
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(color: rarity.color, shape: BoxShape.circle),
                  ),
                  Text(
                    '${_label(rarity)} ${(type.oddsOf(rarity) * 100).round()}%',
                    style: const TextStyle(fontSize: 12, color: AppColors.muted),
                  ),
                ],
              ),
          ],
        ),
      ],
    );
  }

  static String _label(Rarity rarity) =>
      '${rarity.apiValue[0]}${rarity.apiValue.substring(1).toLowerCase()}';
}
