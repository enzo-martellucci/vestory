import 'package:material_ui/material_ui.dart';
import 'package:mobile/core/theme/app_colors.dart';
import 'package:mobile/features/home/presentation/widgets/home_panel.dart';
import 'package:mobile/features/player/data/models/user_pack.dart';
import 'package:mobile/features/player/presentation/widgets/pack_visual.dart';

class UnopenedPacksCard extends StatelessWidget {
  static const _maxVisiblePacks = 4;
  static const _packWidth = 80.0;
  static const _packOffset = 36.0;

  final List<UserPack> packs;
  final VoidCallback? onOpen;

  const UnopenedPacksCard({super.key, required this.packs, required this.onOpen});

  @override
  Widget build(BuildContext context) {
    final visiblePacks = packs.take(_maxVisiblePacks).toList();
    final count = packs.length;

    return HomePanel(
      child: Column(
        spacing: 16,
        children: [
          Text(
            'You have $count ${count == 1 ? 'pack' : 'packs'} to open',
            style: const TextStyle(fontSize: 18, fontWeight: .w800),
          ),
          SizedBox(
            width: _packWidth + (visiblePacks.length - 1) * _packOffset,
            height: _packWidth / PackVisual.aspectRatio + 12,
            child: Stack(
              children: [
                for (final (index, pack) in visiblePacks.indexed)
                  Positioned(
                    left: index * _packOffset,
                    top: index.isEven ? 0 : 12,
                    child: Transform.rotate(
                      angle: (index - (visiblePacks.length - 1) / 2) * 0.12,
                      child: PackVisual(type: pack.type, width: _packWidth),
                    ),
                  ),
              ],
            ),
          ),
          if (count > _maxVisiblePacks)
            Text('+${count - _maxVisiblePacks} more', style: const TextStyle(color: AppColors.muted)),
          FilledButton(onPressed: onOpen, child: const Text('Open')),
        ],
      ),
    );
  }
}
