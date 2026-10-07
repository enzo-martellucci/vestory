import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/core/network/api_exception.dart';
import 'package:mobile/features/auth/presentation/auth_notifier.dart';
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
                  Text(switch (error) {
                    NetworkException() => 'No internet connection',
                    ResponseException(:final error) => error.detail ?? 'Something went wrong',
                    _ => 'Something went wrong',
                  }),
                  OutlinedButton(
                    onPressed: () => ref.invalidate(currentUserProvider),
                    child: const Text('Retry'),
                  ),
                ],
              ),
              data: (user) => Text('Welcome, ${user.username}', style: const TextStyle(fontSize: 24, fontWeight: .w500)),
            ),
            FilledButton(
              onPressed: () => ref.read(authProvider.notifier).logout(),
              child: const Text('Log out'),
            ),
          ],
        ),
      ),
    );
  }
}
