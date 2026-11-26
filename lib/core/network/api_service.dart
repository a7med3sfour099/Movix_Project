import 'package:dio/dio.dart';
import 'package:movixapp/core/network/api_error.dart';
import 'package:movixapp/core/network/app_exceptions.dart';
import 'package:movixapp/core/network/dio_client.dart';
import 'package:movixapp/core/network/result.dart';

class ApiService {
  ApiService._();

  static final ApiService instance = ApiService._();
  factory ApiService() => instance;

  final Dio _dio = DioClient.instance.dio;

  /// CRUD METHODS
  /// get
  Future<Result<T>> get<T>(
    String path, {
    Map<String, dynamic>? query,
    required T Function(dynamic json) parser,
  }) =>
      _run(() => _dio.get(path, queryParameters: query), parser);

  /// post
  Future<Result<T>> post<T>(
    String path, {
    dynamic body,
    Map<String, dynamic>? query,
    required T Function(dynamic json) parser,
  }) =>
      _run(
        () => _dio.post(path, data: body, queryParameters: query),
        parser,
      );

  /// put or update
  Future<Result<T>> put<T>(
    String path, {
    dynamic body,
    Map<String, dynamic>? query,
    required T Function(dynamic json) parser,
  }) =>
      _run(
        () => _dio.put(path, data: body, queryParameters: query),
        parser,
      );

  /// delete
  Future<Result<T>> delete<T>(
    String path, {
    dynamic body,
    Map<String, dynamic>? query,
    required T Function(dynamic json) parser,
  }) =>
      _run(
        () => _dio.delete(path, data: body, queryParameters: query),
        parser,
      );

  /// run request
  Future<Result<T>> _run<T>(
    Future<Response<dynamic>> Function() call,
    T Function(dynamic json) parser,
  ) async {
    try {
      final response = await call();
      final data = response.data;
      try {
        return Success(parser(data));
      } catch (e, st) {
        return Failure(
          ParsingException(
            debugMessage: 'Failed to parse response: $e',
            cause: st,
          ),
        );
      }
    } on DioException catch (e) {
      return Failure(ApiError.map(e));
    } catch (e, st) {
      return Failure(
        UnknownException(debugMessage: e.toString(), cause: st),
      );
    }
  }
}