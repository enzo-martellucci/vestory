import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/core/network/dio_provider.dart';
import 'package:mobile/core/router/router_provider.dart';
import 'package:mobile/features/auth/presentation/auth_notifier.dart';

void main() {
  runApp(
    ProviderScope(
      overrides: [
        onSessionExpiredProvider.overrideWith((ref) => () => ref.read(authProvider.notifier).expireSession()),
      ],
      child: const Vestory(),
    ),
  );
}

class Vestory extends ConsumerWidget {
  const Vestory({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      title: 'Vestory',
      theme: ThemeData(
        colorScheme: .fromSeed(seedColor: Colors.deepPurple),
      ),
      routerConfig: ref.watch(routerProvider),
    );
  }
}
