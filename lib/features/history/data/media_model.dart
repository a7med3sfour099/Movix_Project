class MediaModel {
  final int id;
  final String title;
  final String? posterPath;
  final String? releaseDate;
  final double voteAverage;
  final String mediaType;

  MediaModel({
    required this.id,
    required this.title,
    this.posterPath,
    this.releaseDate,
    required this.voteAverage,
    required this.mediaType,
  });

  factory MediaModel.fromJson(Map<String, dynamic> json) {
    return MediaModel(
      id: json['id'],
      title: json['title'] ?? json['name'] ?? '',
      posterPath: json['poster_path'],
      releaseDate: json['release_date'] ?? json['first_air_date'],
      voteAverage: (json['vote_average'] ?? 0).toDouble(),
      mediaType: json['media_type'] ?? 'movie',
    );
  }
}
