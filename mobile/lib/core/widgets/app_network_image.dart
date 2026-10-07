import 'package:flutter/material.dart';

class AppNetworkImage extends StatelessWidget {
  final String? url;
  final double size;

  const AppNetworkImage({
    super.key,
    required this.url,
    this.size = 52,
  });

  @override
  Widget build(BuildContext context) {
    if (url == null || url!.isEmpty) {
      return _fallback(context);
    }

    return ClipOval(
      child: Image.network(
        url!,
        width: size,
        height: size,
        fit: BoxFit.cover,
        errorBuilder: (
            context,
            error,
            stackTrace,
            ) {
          return _fallback(context);
        },
      ),
    );
  }

  Widget _fallback(
      BuildContext context,
      ) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Theme.of(context)
            .colorScheme
            .surfaceContainerHighest,
      ),
      child: Icon(
        Icons.show_chart_rounded,
        size: size * 0.45,
      ),
    );
  }
}