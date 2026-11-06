# Vestory

Educational investment game built as a school project: a Flutter app (`mobile/`) with no backend. Game data lives in a local Drift database, the asset catalog ships as JSON in `mobile/assets/data/`, and market prices come from the Twelve Data API with an HTTP cache on disk.

Run the app with the API key: `flutter run --dart-define-from-file=env.json` (copy `env.example.json` to `env.json`).

## Rules

- Never write comments in the code. No exceptions.
- All code is in English: identifiers, strings, messages, file names. No exceptions.
- When a branch (`if`, `else`, loop) contains a single statement, omit the braces.
- The app has never been in production and holds no sensitive data: breaking changes are fine, no backward compatibility or data migration needed. The Drift schema can be edited and the app data reset instead of writing migrations.
- When developing a feature, never write many files at once. First propose a step-by-step plan, then implement it one step at a time, waiting for validation before moving to the next step.
