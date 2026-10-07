import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/core/network/api_exception.dart';
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: .min,
                crossAxisAlignment: .stretch,
                spacing: 16,
                children: [
                  Text('Create an account', textAlign: .center, style: theme.textTheme.headlineMedium),
                  TextFormField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                      labelText: 'Username',
                      border: const OutlineInputBorder(),
                      errorText: _fieldErrors['username'],
                    ),
                    textInputAction: .next,
                    validator: _validateUsername,
                  ),
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      border: const OutlineInputBorder(),
                      errorText: _fieldErrors['email'],
                    ),
                    keyboardType: .emailAddress,
                    textInputAction: .next,
                    validator: _validateEmail,
                  ),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      border: const OutlineInputBorder(),
                      errorText: _fieldErrors['password'],
                    ),
                    textInputAction: .next,
                    validator: _validatePassword,
                  ),
                  TextFormField(
                    controller: _confirmPasswordController,
                    obscureText: true,
                    decoration: const InputDecoration(labelText: 'Confirm password', border: OutlineInputBorder()),
                    textInputAction: .done,
                    onFieldSubmitted: (_) => _submit(),
                    validator: _validateConfirmPassword,
                  ),
                  if (_errorMessage != null)
                    Text(_errorMessage!, textAlign: .center, style: TextStyle(color: theme.colorScheme.error)),
                  FilledButton(
                    onPressed: _isLoading ? null : _submit,
                    child: _isLoading
                        ? const SizedBox.square(dimension: 20, child: CircularProgressIndicator(strokeWidth: 2))
                        : const Text('Sign up'),
                  ),
                  TextButton(
                    onPressed: () => context.pop(),
                    child: const Text('Already have an account? Log in'),
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
