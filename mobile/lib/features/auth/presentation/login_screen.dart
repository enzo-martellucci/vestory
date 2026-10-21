import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mobile/core/network/api_error_message.dart';
import 'package:mobile/core/network/api_exception.dart';
import 'package:mobile/core/theme/app_colors.dart';
import 'package:mobile/core/widgets/google_sign_in_button.dart';
import 'package:mobile/core/widgets/labeled_text_field.dart';
import 'package:mobile/core/widgets/or_divider.dart';
import 'package:mobile/features/auth/data/models/login_request.dart';
import 'package:mobile/features/auth/presentation/auth_notifier.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _identifierController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _identifierController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate())
      return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final request = LoginRequest(identifier: _identifierController.text.trim(), password: _passwordController.text);
      await ref.read(authProvider.notifier).login(request);
    } on ApiException catch (exception) {
      setState(() => _errorMessage = apiErrorMessage(exception));
    } finally {
      if (mounted)
        setState(() => _isLoading = false);
    }
  }

  void _showGoogleUnavailable() {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Google sign-in is coming soon')));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) => SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 40, 24, 24),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: .stretch,
                      children: [
                        const _CardFan(),
                        const SizedBox(height: 20),
                        Text('Vestory', textAlign: .center, style: theme.textTheme.displaySmall),
                        const SizedBox(height: 8),
                        const Text(
                          'Collect real companies.\nLearn to invest, risk-free.',
                          textAlign: .center,
                          style: TextStyle(fontSize: 16, height: 1.45, color: AppColors.muted),
                        ),
                        const SizedBox(height: 28),
                        LabeledTextField(
                          label: 'Username or email',
                          controller: _identifierController,
                          textInputAction: .next,
                          validator: (value) => value == null || value.trim().isEmpty ? 'Username or email is required' : null,
                        ),
                        const SizedBox(height: 16),
                        LabeledTextField(
                          label: 'Password',
                          controller: _passwordController,
                          obscureText: true,
                          hintText: '••••••••',
                          textInputAction: .done,
                          onFieldSubmitted: (_) => _submit(),
                          validator: (value) => value == null || value.isEmpty ? 'Password is required' : null,
                        ),
                        if (_errorMessage != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 16),
                            child: Text(
                              _errorMessage!,
                              textAlign: .center,
                              style: const TextStyle(color: AppColors.error, fontWeight: .w600),
                            ),
                          ),
                        const SizedBox(height: 24),
                        FilledButton(
                          onPressed: _isLoading ? null : _submit,
                          child: _isLoading
                              ? const SizedBox.square(dimension: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                              : const Text('Log in'),
                        ),
                        const SizedBox(height: 16),
                        const OrDivider(),
                        const SizedBox(height: 16),
                        GoogleSignInButton(onPressed: _showGoogleUnavailable),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: .center,
                          children: [
                            const Text("Don't have an account?", style: TextStyle(fontSize: 15, color: AppColors.muted)),
                            TextButton(
                              onPressed: () => context.push('/register'),
                              child: const Text('Sign up'),
                            ),
                          ],
                        ),
                        const Spacer(),
                        const SizedBox(height: 16),
                        const Text(
                          'Educational app · no real money involved',
                          textAlign: .center,
                          style: TextStyle(fontSize: 13, color: AppColors.muted),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _CardFan extends StatelessWidget {
  const _CardFan();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 210,
        height: 150,
        child: Stack(
          children: [
            Positioned(
              left: 22,
              top: 22,
              child: Transform.rotate(
                angle: -14 * pi / 180,
                child: const _FanCard(color: Colors.white, borderColor: AppColors.rare, accent: AppColors.rareTint),
              ),
            ),
            Positioned(
              left: 106,
              top: 22,
              child: Transform.rotate(
                angle: 14 * pi / 180,
                child: const _FanCard(color: Colors.white, borderColor: AppColors.legendary, accent: AppColors.legendaryTint),
              ),
            ),
            Positioned(
              left: 64,
              top: 6,
              child: _FanCard(
                color: AppColors.indigo,
                accent: AppColors.vanilla.withValues(alpha: 0.22),
                bottom: Text(
                  'V',
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(fontSize: 24, height: 1, color: AppColors.vanilla),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FanCard extends StatelessWidget {
  final Color color;
  final Color? borderColor;
  final Color accent;
  final Widget? bottom;

  const _FanCard({required this.color, this.borderColor, required this.accent, this.bottom});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 82,
      height: 114,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(14),
        border: borderColor == null ? null : Border.all(color: borderColor!, width: 2),
      ),
      child: Column(
        crossAxisAlignment: .start,
        mainAxisAlignment: .spaceBetween,
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(color: accent, borderRadius: BorderRadius.circular(9)),
          ),
          bottom ??
              FractionallySizedBox(
                widthFactor: 0.7,
                child: Container(
                  height: 6,
                  decoration: BoxDecoration(color: accent, borderRadius: BorderRadius.circular(3)),
                ),
              ),
        ],
      ),
    );
  }
}
