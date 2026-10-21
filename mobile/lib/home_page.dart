import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mobile/core/network/api_error_message.dart';
import 'package:mobile/features/user/presentation/current_user_provider.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserProvider);

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: .center,
          spacing: 12,
          children: [
            const Text('Vestory', style: TextStyle(fontSize: 48, fontWeight: .w900)),
            currentUser.when(
              loading: () => const CircularProgressIndicator(),
              error: (error, stackTrace) => Column(
                spacing: 8,
                children: [
                  Text(apiErrorMessage(error)),
                  OutlinedButton(
                    onPressed: () => ref.invalidate(currentUserProvider),
                    child: const Text('Retry'),
                  ),
                ],
              ),
              data: (user) => Text('Welcome, ${user.username}', style: const TextStyle(fontSize: 24, fontWeight: .w500)),
            ),
          ],
        ),
      ),
    );
  }
}
