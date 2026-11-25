// import 'package:dio/dio.dart';
// import 'package:movixapp/core/network/api_exceptions.dart';
// import 'package:movixapp/core/network/dio_client.dart';
// import 'package:movixapp/core/network/tmdb_config.dart';

// class ApiService {
//   ApiService._();
//   static final ApiService instance = ApiService._();

//   factory ApiService() => instance;

//   final DioClient _dioClient = DioClient.instance;

//   /// CRUD METHODS

//   /// get
//   Future<dynamic> get(String endPoint , {Map<String, dynamic>? param}) async {
//     try {
//       final response = await _dioClient.dio.get(endPoint, queryParameters: {
//         'language': TmdbConfig.language,
//         ...?param});
//       return response.data;
//     } on DioException catch (e) {
//       throw ApiExceptions.handleError(e);
//     }
//   }

//   /// post
//   Future<dynamic> post(String endPoint, dynamic body) async {
//     try {
//       final response = await _dioClient.dio.post(endPoint, data: body);
//       return response.data;
//     } on DioException catch (e) {
//       throw ApiExceptions.handleError(e);
//     }
//   }

//   /// put || update
//   Future<dynamic> put(String endPoint, dynamic body) async {
//     try {
//       final response = await _dioClient.dio.put(endPoint, data: body);
//       return response.data;
//     } on DioException catch (e) {
//       throw ApiExceptions.handleError(e);
//     }
//   }

//   /// delete
//   Future<dynamic> delete(String endPoint, dynamic body, {Map<String, dynamic>? params}) async {
//     try {
//       final response = await _dioClient.dio.delete(endPoint, data: body , queryParameters: params);
//       return response.data;
//     } on DioException catch (e) {
//       throw ApiExceptions.handleError(e);
//     }
//   }
// }

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