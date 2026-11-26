import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movixapp/core/constants/api_endpoints.dart';
import 'package:movixapp/core/network/api_service.dart';
import 'package:movixapp/core/network/result.dart';

class GenresService extends Cubit<Map<int, String>> {
  GenresService._() : super(const {});
  static final GenresService instance = GenresService._();

  final Map<int, String> _cache = {};
  final Map<String, Map<int, String>> _byType = {};
  bool _loaded = false;

  Future<Result<void>> ensureLoaded() async {
    if (_loaded) return const Success(null);

    final movieResult = await ApiService.instance.get<Map<int, String>>(
      ApiEndpoints.movieGenres,
      parser: (json) => _parse(json),
    );
    final tvResult = await ApiService.instance.get<Map<int, String>>(
      ApiEndpoints.tvGenres,
      parser: (json) => _parse(json),
    );

    if (movieResult case Failure(:final exception)) {
      return Failure(exception);
    }
    if (tvResult case Failure(:final exception)) {
      return Failure(exception);
    }

    final movies = (movieResult as Success<Map<int, String>>).data;
    final tv = (tvResult as Success<Map<int, String>>).data;

    _byType['movie'] = movies;
    _byType['tv'] = tv;
    _cache
      ..addAll(movies)
      ..addAll(tv);
    _loaded = true;
    return const Success(null);
  }

  Map<int, String> _parse(dynamic json) => {
    for (final g in (json as Map<String, dynamic>)['genres'] as List)
      g['id'] as int: g['name'] as String,
  };

  Map<int, String> forType(String type) {
    return Map.unmodifiable(_byType[type] ?? const {});
  }

  String? nameFor(int? id) => id == null ? null : _cache[id];
}
