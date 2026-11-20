import 'package:movixapp/core/api_config.dart';

class CastMember {
  final int id;
  final String name;
  final String character;
  final String? image;

  const CastMember({
    required this.id,
    required this.name,
    required this.character,
    this.image,
  });

  factory CastMember.fromJson(Map<String, dynamic> json) {
    final path = json['profile_path'];
    // TV (aggregate_credits) keeps the roles in a list.
    final roles = json['roles'] as List? ?? [];
    final character = json['character'] ??
        (roles.isEmpty ? '' : roles.first['character']) ??
        '';
    return CastMember(
      id: json['id'] as int,
      name: json['name'] ?? '',
      character: character,
      image: path == null ? null : '${ApiConfig.imageBaseUrl}/w185$path',
    );
  }
}
