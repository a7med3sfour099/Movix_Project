import 'package:flutter/material.dart';
import 'package:movixapp/Widgets/person_avatar.dart';
import 'package:movixapp/features/actors/screens/actor_profile_screen.dart';
import 'package:movixapp/features/details/data/cast_member.dart';

/// 3-column grid of the cast. Tap a person to open the actor profile.
class CastGrid extends StatelessWidget {
  final List<CastMember> cast;

  /// TMDB can return hundreds of names; the first ones are the main cast.
  final int maxItems;

  const CastGrid({super.key, required this.cast, this.maxItems = 30});

  @override
  Widget build(BuildContext context) {
    if (cast.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 40),
        child: Center(
          child: Text(
            'Cast not announced yet',
            style: TextStyle(color: Color(0xFF7C8B85)),
          ),
        ),
      );
    }
    final shown = cast.take(maxItems).toList();
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8,
        mainAxisSpacing: 16,
        mainAxisExtent: 160,
      ),
      itemCount: shown.length,
      itemBuilder: (context, i) {
        final member = shown[i];
        return PersonAvatar(
          name: member.name,
          subtitle: member.character,
          image: member.image,
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ActorProfileScreen(id: member.id),
            ),
          ),
        );
      },
    );
  }
}
