import 'package:dio/dio.dart';
import 'package:mobile/core/storage/token_storage.dart';

class AuthInterceptor extends QueuedInterceptor {
  final Dio plainDio;
  final TokenStorage tokenStorage;
  final void Function() onSessionExpired;

  AuthInterceptor({required this.plainDio, required this.tokenStorage, required this.onSessionExpired});

  @override
  Future<void> onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    if (options.path.startsWith('/api/auth/'))
      return handler.next(options);

    final accessToken = await tokenStorage.readAccessToken();
    if (accessToken != null)
      options.headers['Authorization'] = 'Bearer $accessToken';
    handler.next(options);
  }

  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    final options = err.requestOptions;
    if (err.response?.statusCode != 401 || options.path.startsWith('/api/auth/'))
      return handler.next(err);

    final accessToken = await _refreshedAccessToken(options) ?? await _refresh();
    if (accessToken == null)
      return handler.next(err);

    options.headers['Authorization'] = 'Bearer $accessToken';
    try {
      handler.resolve(await plainDio.fetch(options));
    } on DioException catch (retryException) {
      handler.next(retryException);
    }
  }

  Future<String?> _refreshedAccessToken(RequestOptions options) async {
    final storedAccessToken = await tokenStorage.readAccessToken();
    if (storedAccessToken == null || options.headers['Authorization'] == 'Bearer $storedAccessToken')
      return null;
    return storedAccessToken;
  }

  Future<String?> _refresh() async {
    final storedRefreshToken = await tokenStorage.readRefreshToken();
    if (storedRefreshToken == null)
      return null;

    try {
      final response = await plainDio.post('/api/auth/refresh', data: {'refreshToken': storedRefreshToken});
      final accessToken = response.data['accessToken'] as String;
      final refreshToken = response.data['refreshToken'] as String;
      await tokenStorage.save(accessToken: accessToken, refreshToken: refreshToken);
      return accessToken;
    } on DioException catch (exception) {
      if (exception.response?.statusCode == 401) {
        await tokenStorage.clear();
        onSessionExpired();
      }
      return null;
    }
  }
}
