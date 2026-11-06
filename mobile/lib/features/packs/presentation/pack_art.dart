import 'package:material_ui/material_ui.dart';
import 'package:mobile/core/theme/app_theme.dart';
import 'package:mobile/features/packs/domain/pack_type.dart';

const packArtAspectRatio = 1.4;

extension PackTypeStyle on PackType {
  List<Color> get gradient => switch (this) {
    PackType.standard => const [Color(0xFF7C6CFF), Color(0xFF4532E0)],
    PackType.premium => const [Color(0xFFFF7AC6), Color(0xFF8B3DFF)],
    PackType.elite => const [Color(0xFFFFD66B), Color(0xFFE0612F)],
  };

  Color get glow => gradient.last;
}

class PackArt extends StatelessWidget {
  final PackType type;
  final double width;

  const PackArt({super.key, required this.type, this.width = 120});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: width * packArtAspectRatio,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(width * 0.14),
        gradient: LinearGradient(colors: type.gradient, begin: Alignment.topLeft, end: Alignment.bottomRight),
        boxShadow: [BoxShadow(color: type.glow.withValues(alpha: 0.45), blurRadius: width * 0.25, offset: Offset(0, width * 0.08))],
      ),
      child: Stack(
        children: [
          Positioned(
            top: -width * 0.3,
            left: -width * 0.4,
            child: Transform.rotate(
              angle: -0.6,
              child: Container(width: width * 0.5, height: width * 2, color: Colors.white.withValues(alpha: 0.16)),
            ),
          ),
          Positioned.fill(
            child: Padding(
              padding: EdgeInsets.all(width * 0.1),
              child: Column(
                children: [
                  Text('VESTORY', style: AppTheme.display(width * 0.1, color: Colors.white.withValues(alpha: 0.8))),
                  const Spacer(),
                  Icon(Icons.auto_awesome_rounded, color: Colors.white, size: width * 0.34),
                  const Spacer(),
                  Text(type.label.toUpperCase(), style: AppTheme.display(width * 0.13, color: Colors.white)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
