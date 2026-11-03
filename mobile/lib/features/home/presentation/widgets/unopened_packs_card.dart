import 'package:material_ui/material_ui.dart';
import 'package:mobile/core/theme/app_colors.dart';
import 'package:mobile/core/widgets/app_panel.dart';
import 'package:mobile/core/widgets/floating.dart';
import 'package:mobile/features/player/data/models/pack.dart';
import 'package:mobile/features/player/presentation/widgets/open_packs_sheet.dart';
import 'package:mobile/features/player/presentation/widgets/pack_visual.dart';

class UnopenedPacksCard extends StatelessWidget {
  static const _maxVisiblePacks = 4;
  static const _packWidth = 96.0;
  static const _packOffset = 44.0;

  final List<UserPack> packs;
  final VoidCallback? onOpen;

  const UnopenedPacksCard({super.key, required this.packs, required this.onOpen});

  @override
  Widget build(BuildContext context) {
    final visiblePacks = packs.take(_maxVisiblePacks).toList();
    final count = packs.length;

    return AppPanel(
      child: Column(
        spacing: 18,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: .start,
                  spacing: 4,
                  children: [
                    const Text('Your packs', style: TextStyle(fontSize: 20, fontWeight: .w900)),
                    Text(describePacks(packs), style: const TextStyle(color: AppColors.muted)),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(color: AppColors.indigo, borderRadius: BorderRadius.circular(999)),
                child: Text('$count', style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: .w900)),
              ),
            ],
          ),
          SizedBox(
            width: _packWidth + (visiblePacks.length - 1) * _packOffset,
            height: _packWidth / PackVisual.aspectRatio + 24,
            child: Stack(
              children: [
                for (final (index, pack) in visiblePacks.indexed)
                  Positioned(
                    left: index * _packOffset,
                    top: index.isEven ? 6 : 18,
                    child: Floating(
                      phase: index * 0.25,
                      amplitude: 4,
                      child: Transform.rotate(
                        angle: (index - (visiblePacks.length - 1) / 2) * 0.12,
                        child: PackVisual(type: pack.type, width: _packWidth),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          if (count > _maxVisiblePacks)
            Text('+${count - _maxVisiblePacks} more', style: const TextStyle(color: AppColors.muted)),
          FilledButton.icon(
            onPressed: onOpen,
            icon: const Icon(Icons.auto_awesome),
            label: Text('Open $count ${count == 1 ? 'pack' : 'packs'}'),
          ),
        ],
      ),
    );
  }
}
