import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mobile/core/format/formatters.dart';
import 'package:mobile/core/theme/app_colors.dart';
import 'package:mobile/core/theme/app_theme.dart';
import 'package:mobile/features/assets/domain/rarity.dart';
import 'package:mobile/features/assets/presentation/asset_style.dart';
import 'package:mobile/features/player/data/player_repository.dart';
import 'package:mobile/features/player/domain/player_rules.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _username = TextEditingController();
  var _submitting = false;

  @override
  void dispose() {
    _username.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate())
      return;

    setState(() => _submitting = true);
    await ref.read(playerRepositoryProvider).create(_username.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
          children: [
            const _CardFan(),
            const SizedBox(height: 40),
            Text('Collect.\nInvest.\nLearn.', style: AppTheme.display(44)),
            const SizedBox(height: 16),
            const Text(
              'Open packs to collect real companies, ETFs, cryptos and more. Then travel back in time and invest in them.',
              style: TextStyle(color: AppColors.muted, fontSize: 16, height: 1.5),
            ),
            const SizedBox(height: 32),
            Form(
              key: _formKey,
              child: TextFormField(
                controller: _username,
                autofocus: true,
                textInputAction: TextInputAction.done,
                decoration: const InputDecoration(labelText: 'Choose a username', prefixIcon: Icon(Icons.person_rounded)),
                validator: validateUsername,
                onFieldSubmitted: (_) => _submit(),
              ),
            ),
            const SizedBox(height: 16),
            FilledButton(onPressed: _submitting ? null : _submit, child: const Text('Start playing')),
            const SizedBox(height: 12),
            Text(
              'You start with ${formatGems(startingGems)} gems to open your first packs.',
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.muted),
            ),
          ],
        ),
      ),
    );
  }
}

class _CardFan extends StatelessWidget {
  const _CardFan();

  @override
  Widget build(BuildContext context) {
    const rarities = [Rarity.rare, Rarity.legendary, Rarity.epic];
    return SizedBox(
      height: 190,
      child: Stack(
        alignment: Alignment.center,
        children: [
          for (final (index, rarity) in rarities.indexed)
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: 1),
              duration: Duration(milliseconds: 700 + index * 150),
              curve: Curves.easeOutBack,
              builder: (context, value, child) => Transform.translate(
                offset: Offset((index - 1) * 70.0 * value, (index == 1 ? -10 : 10) * value),
                child: Transform.rotate(angle: (index - 1) * 0.22 * value, child: child),
              ),
              child: Container(
                width: 112,
                height: 160,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(colors: rarity.gradient, begin: Alignment.topLeft, end: Alignment.bottomRight),
                  boxShadow: [BoxShadow(color: rarity.color.withValues(alpha: 0.4), blurRadius: 20, offset: const Offset(0, 10))],
                ),
                child: const Icon(Icons.auto_awesome_rounded, color: Colors.white, size: 40),
              ),
            ),
        ],
      ),
    );
  }
}
