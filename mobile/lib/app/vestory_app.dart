import 'package:flutter/material.dart';

import '../core/theme/app_theme.dart';
import '../features/cards/pages/cards_page.dart';
import 'app_dependencies.dart';

class VestoryApp extends StatelessWidget {
  final AppDependencies dependencies;

  const VestoryApp({super.key, required this.dependencies});

  @override
  Widget build(BuildContext context) {
    return AppScope(
      dependencies: dependencies,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Vestory',
        theme: AppTheme.dark,
        home: const CardsPage(),
      ),
    );
  }
}
