import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mobile/core/network/api_error_message.dart';
import 'package:mobile/core/theme/app_colors.dart';
import 'package:mobile/core/widgets/error_view.dart';
import 'package:mobile/features/auth/presentation/auth_notifier.dart';
import 'package:mobile/features/home/presentation/widgets/daily_pack_card.dart';
import 'package:mobile/features/home/presentation/widgets/unopened_packs_card.dart';
import 'package:mobile/features/player/data/models/player_profile.dart';
import 'package:mobile/features/player/presentation/player_providers.dart';
import 'package:mobile/features/player/presentation/widgets/gems_badge.dart';
import 'package:mobile/features/user/presentation/current_user_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(playerProfileProvider, (previous, next) {
      if (next.hasError && next.hasValue)
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(apiErrorMessage(next.error!))));
    });

    final username = ref.watch(currentUserProvider).value?.username;
    final profile = ref.watch(playerProfileProvider);
    final gems = profile.value?.gems;

    return Scaffold(
      appBar: AppBar(
        title: Text(username == null ? 'Vestory' : 'Hi, $username', style: const TextStyle(fontWeight: .w800)),
        actions: [
          if (gems != null)
            GemsBadge(gems: gems),
          IconButton(
            tooltip: 'Log out',
            icon: const Icon(Icons.logout),
            onPressed: () => ref.read(authProvider.notifier).logout(),
          ),
        ],
      ),
      body: profile.when(
        skipError: true,
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => ErrorView(
          message: apiErrorMessage(error),
          onRetry: () => ref.invalidate(playerProfileProvider),
        ),
        data: (profile) => RefreshIndicator(
          onRefresh: () => ref.refresh(playerProfileProvider.future),
          child: _HomeContent(profile: profile),
        ),
      ),
    );
  }
}

class _HomeContent extends StatelessWidget {
  final PlayerProfile profile;

  const _HomeContent({required this.profile});

  @override
  Widget build(BuildContext context) {
    final packsUntilLegendary = profile.packsUntilGuaranteedLegendary;

    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16),
      children: [
        DailyPackCard(profile: profile),
        if (profile.unopenedPacks.isNotEmpty) ...[
          const SizedBox(height: 16),
          UnopenedPacksCard(
            packs: profile.unopenedPacks,
            onOpen: () => context.push('/packs/open', extra: profile.unopenedPacks),
          ),
        ],
        const SizedBox(height: 24),
        Text(
          'Legendary guaranteed in $packsUntilLegendary ${packsUntilLegendary == 1 ? 'pack' : 'packs'}',
          textAlign: .center,
          style: const TextStyle(color: AppColors.muted),
        ),
      ],
    );
  }
}
