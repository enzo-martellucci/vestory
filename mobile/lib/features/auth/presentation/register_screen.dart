import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mobile/core/network/api_exception.dart';
import 'package:mobile/core/theme/app_colors.dart';
import 'package:mobile/core/widgets/google_sign_in_button.dart';
import 'package:mobile/core/widgets/labeled_text_field.dart';
import 'package:mobile/core/widgets/or_divider.dart';
import 'package:mobile/features/auth/data/models/register_request.dart';
import 'package:mobile/features/auth/presentation/auth_notifier.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  static final _usernamePattern = RegExp(r'^[A-Za-z0-9_]{3,20}$');
  static final _emailPattern = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;
  Map<String, String> _fieldErrors = {};

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() => _fieldErrors = {});
    if (!_formKey.currentState!.validate())
      return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final request = RegisterRequest(
        username: _usernameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );
      await ref.read(authProvider.notifier).register(request);
    } on ApiException catch (exception) {
      setState(() {
        switch (exception) {
          case NetworkException():
            _errorMessage = 'No internet connection';
          case ResponseException(:final error):
            _fieldErrors = error.errors ?? {};
            _errorMessage = _fieldErrors.isEmpty ? error.detail ?? 'Something went wrong' : null;
        }
      });
    } finally {
      if (mounted)
        setState(() => _isLoading = false);
    }
  }

  String? _validateUsername(String? value) {
    if (value == null || value.trim().isEmpty)
      return 'Username is required';
    if (!_usernamePattern.hasMatch(value.trim()))
      return 'Username must be 3 to 20 letters, digits or underscores';
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty)
      return 'Email is required';
    if (!_emailPattern.hasMatch(value.trim()))
      return 'Email must be a valid address';
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty)
      return 'Password is required';
    if (value.length < 8 || value.length > 72)
      return 'Password must be 8 to 72 characters';
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value != _passwordController.text)
      return 'Passwords do not match';
    return null;
  }

  void _showGoogleUnavailable() {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Google sign-in is coming soon')));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const highlight = TextStyle(fontWeight: .w700, color: AppColors.indigo);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: .min,
                crossAxisAlignment: .stretch,
                children: [
                  Text('Create your account', textAlign: .center, style: theme.textTheme.headlineMedium),
                  const SizedBox(height: 8),
                  const Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(text: 'Start with '),
                        TextSpan(text: '€1,000', style: highlight),
                        TextSpan(text: ' and '),
                        TextSpan(text: '3 free packs', style: highlight),
                        TextSpan(text: '.'),
                      ],
                    ),
                    textAlign: .center,
                    style: TextStyle(fontSize: 16, height: 1.45, color: AppColors.muted),
                  ),
                  const SizedBox(height: 28),
                  LabeledTextField(
                    label: 'Username',
                    controller: _usernameController,
                    errorText: _fieldErrors['username'],
                    textInputAction: .next,
                    validator: _validateUsername,
                  ),
                  const SizedBox(height: 14),
                  LabeledTextField(
                    label: 'Email',
                    controller: _emailController,
                    hintText: 'you@example.com',
                    errorText: _fieldErrors['email'],
                    keyboardType: .emailAddress,
                    textInputAction: .next,
                    validator: _validateEmail,
                  ),
                  const SizedBox(height: 14),
                  LabeledTextField(
                    label: 'Password',
                    controller: _passwordController,
                    obscureText: true,
                    hintText: '••••••••',
                    errorText: _fieldErrors['password'],
                    textInputAction: .next,
                    validator: _validatePassword,
                  ),
                  const SizedBox(height: 14),
                  LabeledTextField(
                    label: 'Confirm password',
                    controller: _confirmPasswordController,
                    obscureText: true,
                    hintText: '••••••••',
                    textInputAction: .done,
                    onFieldSubmitted: (_) => _submit(),
                    validator: _validateConfirmPassword,
                  ),
                  if (_errorMessage != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 14),
                      child: Text(
                        _errorMessage!,
                        textAlign: .center,
                        style: const TextStyle(color: AppColors.error, fontWeight: .w600),
                      ),
                    ),
                  const SizedBox(height: 22),
                  FilledButton(
                    onPressed: _isLoading ? null : _submit,
                    child: _isLoading
                        ? const SizedBox.square(dimension: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                        : const Text('Sign up'),
                  ),
                  const SizedBox(height: 14),
                  const OrDivider(),
                  const SizedBox(height: 14),
                  GoogleSignInButton(onPressed: _showGoogleUnavailable),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: .center,
                    children: [
                      const Text('Already have an account?', style: TextStyle(fontSize: 15, color: AppColors.muted)),
                      TextButton(
                        onPressed: () => context.pop(),
                        child: const Text('Log in'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
