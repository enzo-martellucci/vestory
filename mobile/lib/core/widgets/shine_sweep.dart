import 'package:material_ui/material_ui.dart';

class ShineSweep extends StatefulWidget {
  final Widget child;
  final BorderRadius borderRadius;
  final Duration period;

  const ShineSweep({
    super.key,
    required this.child,
    this.borderRadius = BorderRadius.zero,
    this.period = const Duration(milliseconds: 2800),
  });

  @override
  State<ShineSweep> createState() => _ShineSweepState();
}

class _ShineSweepState extends State<ShineSweep> with SingleTickerProviderStateMixin {
  late final _controller = AnimationController(vsync: this, duration: widget.period)..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        Positioned.fill(
          child: IgnorePointer(
            child: ClipRRect(
              borderRadius: widget.borderRadius,
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, _) {
                  final position = _controller.value * 3 - 1;
                  return DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment(position - 1, -1),
                        end: Alignment(position + 1, 1),
                        colors: [
                          Colors.white.withValues(alpha: 0),
                          Colors.white.withValues(alpha: 0.45),
                          Colors.white.withValues(alpha: 0),
                        ],
                        stops: const [0.4, 0.5, 0.6],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}
