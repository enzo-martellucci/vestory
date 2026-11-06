import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mobile/core/network/market_client.dart';
import 'package:mobile/core/router/app_router.dart';
import 'package:mobile/core/theme/app_theme.dart';
import 'package:path_provider/path_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final cacheDirectory = await getApplicationSupportDirectory();

  runApp(
    ProviderScope(
      retry: (retryCount, error) => null,
      overrides: [cacheDirectoryProvider.overrideWithValue(cacheDirectory.path)],
      child: const VestoryApp(),
    ),
  );
}

class VestoryApp extends ConsumerWidget {
  const VestoryApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      title: 'Vestory',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      routerConfig: ref.watch(routerProvider),
    );
  }
}
