import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mobile/core/theme/app_colors.dart';
import 'package:mobile/core/widgets/app_panel.dart';
import 'package:mobile/core/widgets/app_screen.dart';
import 'package:mobile/core/widgets/fade_slide_in.dart';
import 'package:mobile/features/auth/presentation/auth_notifier.dart';
import 'package:mobile/features/user/presentation/current_user_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider).value;
    final username = user?.username ?? '';

    return AppScreen(
      title: 'Profile',
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
        children: [
          FadeSlideIn(
            child: AppPanel(
              child: Row(
                spacing: 16,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: AppColors.indigo,
                    child: Text(
                      username.isEmpty ? '?' : username[0].toUpperCase(),
                      style: const TextStyle(color: Colors.white, fontSize: 26, fontWeight: .w900),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: .start,
                      spacing: 4,
                      children: [
                        Text(username, style: const TextStyle(fontSize: 20, fontWeight: .w800)),
                        Text(user?.email ?? '', style: const TextStyle(color: AppColors.muted)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          FadeSlideIn(
            index: 1,
            child: OutlinedButton.icon(
              onPressed: () => ref.read(authProvider.notifier).logout(),
              icon: const Icon(Icons.logout),
              label: const Text('Log out'),
            ),
          ),
        ],
      ),
    );
  }
}
