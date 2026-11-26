import 'dart:io';
import 'package:dio/io.dart';
import 'package:dio/dio.dart';
import 'package:movixapp/core/network/env_config.dart';
import 'package:movixapp/core/network/loggin_interceptor.dart';
import 'package:movixapp/core/network/retry_interceptor.dart';
import 'package:movixapp/core/network/tmdb_config.dart';

class DioClient {
  DioClient._();

  static final DioClient instance = DioClient._();
  factory DioClient() => instance;

  late final Dio _dio = _build();

  Dio get dio => _dio;

  Dio _build() {
    final dio = Dio(
      BaseOptions(
        baseUrl: TmdbConfig.baseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        sendTimeout: const Duration(seconds: 15),
        responseType: ResponseType.json,
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      ),
    );

    (dio.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () {
      final client = HttpClient();
      client.maxConnectionsPerHost = 6;
      client.idleTimeout = const Duration(seconds: 15);
      return client;
    };

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          options.headers['Authorization'] =
              'Bearer ${EnvConfig.tmdbAccessToken}';
          options.queryParameters.putIfAbsent(
            'language',
            () => TmdbConfig.language,
          );
          handler.next(options);
        },
      ),
    );

    dio.interceptors.add(RetryInterceptor(dio));
    dio.interceptors.add(LoggingInterceptor());

    return dio;
  }
}
