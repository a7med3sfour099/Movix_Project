import 'package:dio/dio.dart';

class RetryInterceptor extends Interceptor {
  RetryInterceptor(this._dio, {this.maxRetries = 3});

  final Dio _dio;
  final int maxRetries;

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final retryable = err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.receiveTimeout ||
        err.type == DioExceptionType.connectionError ||
        (err.response?.statusCode ?? 0) == 429 ||
        (err.response?.statusCode ?? 0) >= 500;

    final attempt = (err.requestOptions.extra['retry_attempt'] as int?) ?? 0;

    if (!retryable || attempt >= maxRetries) {
      return handler.next(err);
    }

    // Exponential backoff: 400ms, 800ms, 1600ms
    await Future.delayed(Duration(milliseconds: 400 * (1 << attempt)));

    final options = err.requestOptions
      ..extra['retry_attempt'] = attempt + 1;

    try {
      final response = await _dio.fetch(options);
      handler.resolve(response);
    } on DioException catch (e) {
      handler.next(e);
    }
  }
}