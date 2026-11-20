import 'package:movixapp/core/api_config.dart';
import 'package:movixapp/core/rating_calc.dart';
import 'package:movixapp/features/details/data/cast_member.dart';


class MediaDetails {
  final int id;
  final String type;
  final String title;
  final String overview;
  final String date;
  final String year;
  final String runtime;
  final String rating;
  final double rawRating;
  final int voteCount;
  final String certification;
  final String language;
  final List<String> genres;
  final String? poster;
  final String? backdrop;
  final String? trailerKey;
  final List<CastMember> cast;
  final String status;

  const MediaDetails({
    required this.id,
    required this.type,
    required this.title,
    required this.overview,
    required this.date,
    required this.year,
    required this.runtime,
    required this.rating,
    required this.rawRating,
    required this.voteCount,
    required this.certification,
    required this.language,
    required this.genres,
    required this.poster,
    required this.backdrop,
    required this.trailerKey,
    required this.cast,
    required this.status,
  });

  bool get isTv => type == 'tv';

  /// Not released yet (future date, or TMDB says it is still planned).
  bool get isUnreleased {
    const planned = ['Planned', 'In Production', 'Post Production', 'Rumored'];
    return planned.contains(status) ||
        (DateTime.tryParse(date)?.isAfter(DateTime.now()) ?? false);
  }

  factory MediaDetails.fromJson(Map<String, dynamic> json, String type) {
    final tv = type == 'tv';
    final date = (tv ? json['first_air_date'] : json['release_date']) ?? '';

    // runtime: movie -> "2h 46m", tv -> "3 Seasons"
    String runtime = '';
    if (tv) {
      final seasons = json['number_of_seasons'] as int? ?? 0;
      if (seasons > 0) runtime = '$seasons Season${seasons == 1 ? '' : 's'}';
    } else {
      final minutes = json['runtime'] as int? ?? 0;
      if (minutes > 0) runtime = '${minutes ~/ 60}h ${minutes % 60}m';
    }

    final languages = json['spoken_languages'] as List? ?? [];
    final language = languages.isEmpty
        ? ''
        : (languages.first['english_name'] ?? '') as String;

    final cast = <CastMember>[];
    final credits = tv ? json['aggregate_credits'] : json['credits'];
    for (final raw in (credits?['cast'] as List? ?? [])) {
      cast.add(CastMember.fromJson(raw));
    }

    final poster = json['poster_path'];
    final backdrop = json['backdrop_path'];

    return MediaDetails(
      id: json['id'] as int,
      type: type,
      title: (tv ? json['name'] : json['title']) ?? '',
      overview: json['overview'] ?? '',
      date: date,
      year: date.length >= 4 ? date.substring(0, 4) : '',
      runtime: runtime,
      rating: formatRating((json['vote_average'] ?? 0).toDouble()),
      rawRating: (json['vote_average'] ?? 0).toDouble(),
      voteCount: json['vote_count'] as int? ?? 0,
      certification: _certification(json, tv),
      language: language,
      genres: [
        for (final g in (json['genres'] as List? ?? [])) g['name'] as String,
      ],
      poster: poster == null ? null : '${ApiConfig.imageBaseUrl}/w500$poster',
      backdrop:
          backdrop == null ? null : '${ApiConfig.imageBaseUrl}/w1280$backdrop',
      trailerKey: _trailerKey(json['videos']?['results'] as List? ?? []),
      cast: cast,
      status: json['status'] ?? '',
    );
  }

  /// Prefers an official YouTube Trailer, then any Trailer, then a Teaser.
  static String? _trailerKey(List videos) {
    final youtube = videos.where((v) => v['site'] == 'YouTube').toList();
    for (final type in ['Trailer', 'Teaser']) {
      final ofType = youtube.where((v) => v['type'] == type).toList();
      if (ofType.isEmpty) continue;
      final official = ofType.where((v) => v['official'] == true);
      return (official.isNotEmpty ? official.first : ofType.first)['key'];
    }
    return null;
  }

  /// US certification (PG-13, TV-MA...), or empty when TMDB has none.
  static String _certification(Map<String, dynamic> json, bool tv) {
    if (tv) {
      for (final r in (json['content_ratings']?['results'] as List? ?? [])) {
        if (r['iso_3166_1'] == 'US') return r['rating'] ?? '';
      }
      return '';
    }
    for (final c in (json['release_dates']?['results'] as List? ?? [])) {
      if (c['iso_3166_1'] != 'US') continue;
      for (final r in (c['release_dates'] as List? ?? [])) {
        final cert = r['certification'] as String? ?? '';
        if (cert.isNotEmpty) return cert;
      }
    }
    return '';
  }
}
