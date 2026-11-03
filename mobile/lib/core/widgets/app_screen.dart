import 'package:material_ui/material_ui.dart';

class AppScreen extends StatelessWidget {
  final String title;
  final List<Widget> actions;
  final Widget body;

  const AppScreen({super.key, required this.title, this.actions = const [], required this.body});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: .stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
              child: Row(
                spacing: 12,
                children: [
                  Expanded(child: Text(title, style: Theme.of(context).textTheme.headlineMedium)),
                  ...actions,
                ],
              ),
            ),
            Expanded(child: body),
          ],
        ),
      ),
    );
  }
}
