import 'package:material_ui/material_ui.dart';
import 'package:mobile/core/theme/app_colors.dart';

class GoogleSignInButton extends StatelessWidget {
  final VoidCallback onPressed;

  const GoogleSignInButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      child: Row(
        mainAxisAlignment: .center,
        spacing: 10,
        children: [
          Container(
            width: 24,
            height: 24,
            alignment: .center,
            decoration: BoxDecoration(
              shape: .circle,
              border: Border.all(color: AppColors.ink, width: 1.5),
            ),
            child: const Text('G', style: TextStyle(fontSize: 12, fontWeight: .w800)),
          ),
          const Text('Continue with Google'),
        ],
      ),
    );
  }
}
