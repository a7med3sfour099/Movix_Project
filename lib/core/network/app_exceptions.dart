sealed class AppException implements Exception {
  const AppException({required this.userMessage, this.debugMessage, this.cause});

  final String userMessage;
  final String? debugMessage;
  final Object? cause;

  @override
  String toString() => debugMessage ?? userMessage;
}

class NetworkException extends AppException {
  const NetworkException({
    super.userMessage = 'No internet connection. Please check your network.',
    super.debugMessage,
    super.cause,
  });
}

class TimeoutException_ extends AppException {
  const TimeoutException_({
    super.userMessage = 'The request took too long. Please try again.',
    super.debugMessage,
    super.cause,
  });
}

class UnauthorizedException extends AppException {
  const UnauthorizedException({
    super.userMessage = 'Session expired. Please sign in again.',
    super.debugMessage,
    super.cause,
  });
}

class ForbiddenException extends AppException {
  const ForbiddenException({
    super.userMessage = "You don't have permission to do that.",
    super.debugMessage,
    super.cause,
  });
}

class NotFoundException extends AppException {
  const NotFoundException({
    super.userMessage = 'The requested item was not found.',
    super.debugMessage,
    super.cause,
  });
}

class RateLimitException extends AppException {
  const RateLimitException({
    super.userMessage = 'Too many requests. Please try again later.',
    super.debugMessage,
    super.cause,
  });
}

class ServerException extends AppException {
  const ServerException({
    super.userMessage = 'Something went wrong on the server. Please try again.',
    super.debugMessage,
    super.cause,
  });
}

class ParsingException extends AppException {
  const ParsingException({
    super.userMessage = 'Unexpected response format.',
    super.debugMessage,
    super.cause,
  });
}

class UnknownException extends AppException {
  const UnknownException({
    super.userMessage = 'An unexpected error occurred. Please try again.',
    super.debugMessage,
    super.cause,
  });
}