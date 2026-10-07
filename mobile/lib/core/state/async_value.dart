import '../api/api_exception.dart';

sealed class AsyncValue<T> {
  const AsyncValue();

  T? get valueOrNull => switch (this) {
        AsyncData<T>(:final value) => value,
        _ => null,
      };

  bool get isLoading => this is AsyncLoading<T>;
}

final class AsyncLoading<T> extends AsyncValue<T> {
  const AsyncLoading();
}

final class AsyncData<T> extends AsyncValue<T> {
  final T value;

  const AsyncData(this.value);
}

final class AsyncError<T> extends AsyncValue<T> {
  final Object error;

  const AsyncError(this.error);

  String get message =>
      error is ApiException ? (error as ApiException).message : 'Something went wrong.';
}

Future<AsyncValue<T>> guardAsync<T>(Future<T> Function() action) async {
  try {
    return AsyncData(await action());
  } catch (e) {
    return AsyncError(e);
  }
}
