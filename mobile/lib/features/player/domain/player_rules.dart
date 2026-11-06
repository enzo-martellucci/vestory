const startingGems = 2100;

final _usernamePattern = RegExp(r'^[A-Za-z0-9_]+$');

String? validateUsername(String? value) {
  final username = value?.trim() ?? '';
  if (username.isEmpty)
    return 'Choose a username.';
  if (username.length < 3 || username.length > 20)
    return 'Use between 3 and 20 characters.';
  if (!_usernamePattern.hasMatch(username))
    return 'Use letters, digits or underscores only.';
  return null;
}
