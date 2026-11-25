import 'package:dio/dio.dart';
import 'package:movixapp/core/network/app_exceptions.dart';

class ApiError {
  ApiError._();

  static AppException map(DioException error) {
    final statusCode = error.response?.statusCode;
    final serverMessage = _extractServerMessage(error.response?.data);

    final fromStatus = _fromStatus(statusCode, serverMessage);
    if (fromStatus != null) return fromStatus;

  /// Handle other errors
    return switch (error.type) {
      DioExceptionType.connectionTimeout ||
      DioExceptionType.sendTimeout ||
      DioExceptionType.receiveTimeout => TimeoutException_(
        debugMessage: error.message,
        cause: error.error,
      ),
      DioExceptionType.connectionError => NetworkException(
        debugMessage: error.message,
        cause: error.error,
      ),
      DioExceptionType.cancel => UnknownException(
        userMessage: 'Request was cancelled.',
        debugMessage: error.message,
        cause: error.error,
      ),
      DioExceptionType.badResponse => ServerException(
        userMessage:
            serverMessage ??
            'Server responded with an error. Please try again.',
        debugMessage: 'Status $statusCode: ${error.message}',
        cause: error.error,
      ),
      _ => UnknownException(debugMessage: error.message, cause: error.error),
    };
  }

  /// Maps http status code
  static AppException? _fromStatus(int? status, String? serverMessage) {
    return switch (status) {
      401 => UnauthorizedException(
        debugMessage: serverMessage ?? '401 Unauthorized',
      ),
      403 => ForbiddenException(debugMessage: serverMessage ?? '403 Forbidden'),
      404 => NotFoundException(debugMessage: serverMessage ?? '404 Not Found'),
      429 => RateLimitException(
        debugMessage: serverMessage ?? '429 Too Many Requests',
      ),
      500 => ServerException(
        userMessage: serverMessage ?? 'Server error. Please try again later.',
        debugMessage: 'Status $status',
      ),
      _ => null,
    };
  }

  /// Extracts error message from server response
  static String? _extractServerMessage(dynamic data) {
    if (data is Map) {
      final msg = data['status_message'] ?? data['message'];
      if (msg is String && msg.isNotEmpty) return msg;
    }
    return null;
  }
}
