import 'package:movixapp/core/api_config.dart';

/// One row in the search results: a movie, a TV show or a person.
class SearchResult {
  final int id;

  /// 'movie', 'tv' or 'person'
  final String type;
  final String title;
  final String? image;
  final String date;
  final int? year;
  final double rating;
  final List<int> genreIds;

  /// Persons only
  final String department;
  final int gender;
  final List<String> knownFor;

  const SearchResult({
    required this.id,
    required this.type,
    required this.title,
    required this.date,
    required this.rating,
    required this.genreIds,
    this.image,
    this.year,
    this.department = '',
    this.gender = 0,
    this.knownFor = const [],
  });

  bool get isPerson => type == 'person';

  factory SearchResult.fromJson(Map<String, dynamic> json, String defaultType) {
    final type = (json['media_type'] ?? defaultType) as String;
    final date = (json['release_date'] ?? json['first_air_date'] ?? '') as String;
    final path = json['poster_path'] ?? json['profile_path'];

    final knownFor = <String>[];
    for (final raw in (json['known_for'] as List? ?? [])) {
      final name = raw['title'] ?? raw['name'];
      if (name is String && name.isNotEmpty) knownFor.add(name);
    }

    return SearchResult(
      id: json['id'] as int,
      type: type,
      title: (json['title'] ?? json['name'] ?? '') as String,
      image: path == null ? null : '${ApiConfig.imageBaseUrl}/w185$path',
      date: date,
      year: date.length >= 4 ? int.tryParse(date.substring(0, 4)) : null,
      rating: ((json['vote_average'] ?? 0) as num).toDouble(),
      genreIds: [
        for (final g in (json['genre_ids'] as List? ?? [])) g as int,
      ],
      department: (json['known_for_department'] ?? '') as String,
      gender: (json['gender'] as int?) ?? 0,
      knownFor: knownFor,
    );
  }
}
