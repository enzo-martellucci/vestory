import 'dart:ui';

import 'package:material_ui/material_ui.dart';
import 'package:mobile/core/theme/app_colors.dart';
import 'package:mobile/core/widgets/floating.dart';
import 'package:mobile/features/player/data/models/pack.dart';
import 'package:mobile/features/player/presentation/widgets/pack_visual.dart';

String describePacks(List<UserPack> packs) => [
  for (final type in PackType.values)
    if (packs.any((pack) => pack.type == type)) '${packs.where((pack) => pack.type == type).length} ${type.label}',
].join(' · ');

Future<bool> confirmOpenPacks(
  BuildContext context,
  List<UserPack> packs, {
  String? title,
  String confirmLabel = 'Open',
  String cancelLabel = 'Not now',
}) async {
  final count = packs.length;
  final confirmed = await showGeneralDialog<bool>(
    context: context,
    barrierDismissible: true,
    barrierLabel: cancelLabel,
    barrierColor: AppColors.ink.withValues(alpha: 0.45),
    transitionDuration: const Duration(milliseconds: 350),
    pageBuilder: (context, animation, secondaryAnimation) => _OpenPacksSheet(
      packs: packs,
      title: title ?? 'Open $count ${count == 1 ? 'pack' : 'packs'}?',
      confirmLabel: confirmLabel,
      cancelLabel: cancelLabel,
    ),
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      final curved = CurvedAnimation(parent: animation, curve: Curves.easeOutCubic);
      return BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 6 * curved.value, sigmaY: 6 * curved.value),
        child: SlideTransition(
          position: Tween(begin: const Offset(0, 1), end: Offset.zero).animate(curved),
          child: child,
        ),
      );
    },
  );
  return confirmed ?? false;
}

class _OpenPacksSheet extends StatelessWidget {
  static const _maxVisiblePacks = 4;
  static const _packWidth = 88.0;
  static const _packOffset = 40.0;

  final List<UserPack> packs;
  final String title;
  final String confirmLabel;
  final String cancelLabel;

  const _OpenPacksSheet({
    required this.packs,
    required this.title,
    required this.confirmLabel,
    required this.cancelLabel,
  });

  @override
  Widget build(BuildContext context) {
    final visiblePacks = packs.take(_maxVisiblePacks).toList();

    return Align(
      alignment: Alignment.bottomCenter,
      child: Material(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 12, 24, 20),
            child: Column(
              mainAxisSize: .min,
              spacing: 18,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(color: AppColors.cardBorder, borderRadius: BorderRadius.circular(999)),
                ),
                SizedBox(
                  width: _packWidth + (visiblePacks.length - 1) * _packOffset,
                  height: _packWidth / PackVisual.aspectRatio + 20,
                  child: Stack(
                    children: [
                      for (final (index, pack) in visiblePacks.indexed)
                        Positioned(
                          left: index * _packOffset,
                          top: index.isEven ? 4 : 16,
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
                Column(
                  spacing: 6,
                  children: [
                    Text(title, textAlign: .center, style: Theme.of(context).textTheme.headlineMedium),
                    Text(describePacks(packs), style: const TextStyle(color: AppColors.muted, fontSize: 15)),
                  ],
                ),
                Column(
                  spacing: 8,
                  children: [
                    _GradientButton(
                      label: confirmLabel,
                      onPressed: () => Navigator.pop(context, true),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: Text(cancelLabel),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _GradientButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const _GradientButton({required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(colors: [Color(0xFF3A50D0), AppColors.epic]),
        boxShadow: [BoxShadow(color: AppColors.epic.withValues(alpha: 0.35), blurRadius: 18, offset: const Offset(0, 8))],
      ),
      child: FilledButton.icon(
        style: FilledButton.styleFrom(backgroundColor: Colors.transparent, shadowColor: Colors.transparent),
        onPressed: onPressed,
        icon: const Icon(Icons.auto_awesome),
        label: Text(label),
      ),
    );
  }
}
