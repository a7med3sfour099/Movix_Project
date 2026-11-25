import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class LoggingInterceptor extends Interceptor {

  /// Print request options and data object
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (kDebugMode) {
      debugPrint('→ ${options.method} ${options.uri}');
      if (options.data != null) {
        debugPrint('  body: ${options.data}');
      }
    }
    handler.next(options);
  }

  /// Print response status code
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (kDebugMode) {
      debugPrint(
        '← ${response.statusCode} ${response.requestOptions.uri}',
      );
    }
    handler.next(response);
  }

  /// Print error status code
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (kDebugMode) {
      debugPrint(
        '✖ ${err.response?.statusCode ?? err.type} ${err.requestOptions.uri}',
      );
      if (err.response?.data != null) {
        debugPrint('  error: ${err.response!.data}');
      }
    }
    handler.next(err);
  }
}