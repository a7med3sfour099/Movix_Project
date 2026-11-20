import 'package:movixapp/core/api_config.dart';

enum ActorGender { all, female, male }

class Actor {
  final int id;
  final String name;
  final String? image;
  final String department;
  final int gender;
  final double popularity;
  final List<String> knownFor;

  const Actor({
    required this.id,
    required this.name,
    required this.department,
    required this.gender,
    required this.popularity,
    required this.knownFor,
    this.image,
  });

  factory Actor.fromJson(Map<String, dynamic> json) {
    final path = json['profile_path'];
    final knownFor = <String>[];
    for (final raw in (json['known_for'] as List? ?? [])) {
      final title = raw['title'] ?? raw['name'];
      if (title is String && title.isNotEmpty) knownFor.add(title);
    }

    return Actor(
      id: json['id'] as int,
      name: json['name'] ?? '',
      image: path == null ? null : '${ApiConfig.imageBaseUrl}/w342$path',
      department: json['known_for_department'] ?? '',
      gender: (json['gender'] as int?) ?? 0,
      popularity: ((json['popularity'] ?? 0) as num).toDouble(),
      knownFor: knownFor,
    );
  }
// 1 for female,2 for male
  bool matches(ActorGender filter) => switch (filter) {
        ActorGender.all => true,
        ActorGender.female => gender == 1,
        ActorGender.male => gender == 2,
      };
}
