import 'dart:math';

import 'package:material_ui/material_ui.dart';
import 'package:mobile/core/database/app_database.dart';
import 'package:mobile/core/theme/app_colors.dart';
import 'package:mobile/core/theme/app_theme.dart';
import 'package:mobile/features/assets/presentation/asset_logo.dart';
import 'package:mobile/features/assets/presentation/asset_style.dart';

const assetCardAspectRatio = 0.7;
const _designWidth = 180.0;

class FlippableAssetCard extends StatefulWidget {
  final Asset asset;
  final int total;
  final VoidCallback onDetails;

  const FlippableAssetCard({super.key, required this.asset, required this.total, required this.onDetails});

  @override
  State<FlippableAssetCard> createState() => _FlippableAssetCardState();
}

class _FlippableAssetCardState extends State<FlippableAssetCard> with SingleTickerProviderStateMixin {
  late final _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 550));
  late final _rotation = CurvedAnimation(parent: _controller, curve: Curves.easeInOutBack);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _flip() => _controller.isForwardOrCompleted ? _controller.reverse() : _controller.forward();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _flip,
      child: AnimatedBuilder(
        animation: _rotation,
        builder: (context, _) {
          final angle = _rotation.value * pi;
          final showBack = angle > pi / 2;
          return Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.0012)
              ..rotateY(angle),
            child: showBack
                ? Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.rotationY(pi),
                    child: AssetCardBack(asset: widget.asset, onDetails: widget.onDetails),
                  )
                : AssetCardFront(asset: widget.asset, total: widget.total),
          );
        },
      ),
    );
  }
}

class _CardShell extends StatelessWidget {
  final Asset asset;
  final Color background;
  final Widget child;

  const _CardShell({required this.asset, required this.background, required this.child});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: assetCardAspectRatio,
      child: FittedBox(
        child: SizedBox(
          width: _designWidth,
          height: _designWidth / assetCardAspectRatio,
          child: Container(
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(22),
              gradient: LinearGradient(colors: asset.rarity.gradient, begin: Alignment.topLeft, end: Alignment.bottomRight),
              boxShadow: [BoxShadow(color: asset.rarity.color.withValues(alpha: 0.35), blurRadius: 18, offset: const Offset(0, 8))],
            ),
            child: Container(
              decoration: BoxDecoration(color: background, borderRadius: BorderRadius.circular(19)),
              padding: const EdgeInsets.all(12),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}

class AssetCardFront extends StatelessWidget {
  final Asset asset;
  final int total;

  const AssetCardFront({super.key, required this.asset, required this.total});

  @override
  Widget build(BuildContext context) {
    return _CardShell(
      asset: asset,
      background: AppColors.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              _Chip(icon: asset.type.icon, label: asset.type.label, color: AppColors.muted),
              const Spacer(),
              Text('#${asset.id.toString().padLeft(3, '0')}', style: const TextStyle(fontSize: 11, color: AppColors.muted, fontWeight: FontWeight.w700)),
            ],
          ),
          const Spacer(),
          Center(child: AssetLogo(asset: asset, size: 56)),
          const Spacer(),
          Text(
            asset.name,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: AppTheme.display(14),
          ),
          const SizedBox(height: 2),
          Text(asset.symbol, textAlign: TextAlign.center, style: const TextStyle(fontSize: 12, color: AppColors.muted, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Center(child: _Chip(label: asset.rarity.label.toUpperCase(), color: asset.rarity.color, filled: true)),
          const SizedBox(height: 4),
          Text('${asset.id} / $total', textAlign: TextAlign.center, style: const TextStyle(fontSize: 10, color: AppColors.muted)),
        ],
      ),
    );
  }
}

class AssetCardBack extends StatelessWidget {
  final Asset asset;
  final VoidCallback onDetails;

  const AssetCardBack({super.key, required this.asset, required this.onDetails});

  @override
  Widget build(BuildContext context) {
    final facts = [
      ?asset.sector,
      ?asset.country,
      ?asset.exchange,
    ];
    return _CardShell(
      asset: asset,
      background: AppColors.ink,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(asset.symbol, style: AppTheme.display(16, color: Colors.white)),
          const SizedBox(height: 6),
          Wrap(
            spacing: 4,
            runSpacing: 4,
            children: [for (final fact in facts) _Chip(label: fact, color: asset.rarity.gradient.first)],
          ),
          const SizedBox(height: 8),
          Expanded(
            child: Text(
              asset.description ?? 'No description yet.',
              overflow: TextOverflow.fade,
              style: TextStyle(fontSize: 11, height: 1.35, color: Colors.white.withValues(alpha: 0.8)),
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              style: FilledButton.styleFrom(minimumSize: const Size(0, 34), backgroundColor: asset.rarity.color, padding: EdgeInsets.zero),
              onPressed: onDetails,
              child: const Text('Details', style: TextStyle(fontSize: 13)),
            ),
          ),
        ],
      ),
    );
  }
}

class LockedAssetCard extends StatelessWidget {
  final Asset asset;

  const LockedAssetCard({super.key, required this.asset});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: assetCardAspectRatio,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.border.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: AppColors.border, width: 2),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.lock_rounded, color: AppColors.muted),
            const SizedBox(height: 8),
            Text('#${asset.id.toString().padLeft(3, '0')}', style: const TextStyle(color: AppColors.muted, fontWeight: FontWeight.w700)),
            const SizedBox(height: 4),
            Text(asset.rarity.label, style: TextStyle(color: asset.rarity.color, fontSize: 12, fontWeight: FontWeight.w700)),
          ],
        ),
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final IconData? icon;
  final String label;
  final Color color;
  final bool filled;

  const _Chip({this.icon, required this.label, required this.color, this.filled = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: filled ? color : color.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[Icon(icon, size: 11, color: color), const SizedBox(width: 3)],
          Flexible(
            child: Text(
              label,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: filled ? Colors.white : color, letterSpacing: 0.3),
            ),
          ),
        ],
      ),
    );
  }
}
