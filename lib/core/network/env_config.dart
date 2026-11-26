import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

class EnvConfig {
  EnvConfig._();

  static const String _dartDefineToken =
      String.fromEnvironment('TMDB_ACCESS_TOKEN');

  static const String _assetPath = 'env.json';

  static Map<String, dynamic>? _cache;

  static Future<void> init() async {
    if (_cache != null) return;

    try {
      final raw = await rootBundle.loadString(_assetPath);
      final decoded = jsonDecode(raw);
      if (decoded is Map<String, dynamic>) {
        _cache = decoded;
      } else {
        _cache = const {};
      }
    } catch (_) {
      _cache = const {};
    }
  }

  static String get tmdbAccessToken {
    if (_dartDefineToken.isNotEmpty) return _dartDefineToken;
    final fromJson = _cache?['TMDB_ACCESS_TOKEN'];
    if (fromJson is String && fromJson.isNotEmpty) return fromJson;
    throw StateError(
      'Add Your TMDB_ACCESS_TOKEN to env.json.',
    );
  }
}