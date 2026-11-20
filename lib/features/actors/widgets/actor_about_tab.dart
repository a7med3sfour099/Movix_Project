import 'package:flutter/material.dart';
import 'package:movixapp/Widgets/expandable_text.dart';
import 'package:movixapp/Widgets/section_title.dart';
import 'package:movixapp/features/actors/data/person_details.dart';
import 'package:movixapp/features/actors/widgets/aliases_card.dart';
import 'package:movixapp/features/actors/widgets/photo_gallery.dart';

class ActorAboutTab extends StatelessWidget {
  final PersonDetails person;

  const ActorAboutTab({super.key, required this.person});

  @override
  Widget build(BuildContext context) {
    final bio = person.biography.isEmpty
        ? 'No biography available yet.'
        : person.biography;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AliasesCard(aliases: person.aliases),
        if (person.aliases.isNotEmpty) const SizedBox(height: 24),
        const SectionTitle(title: 'Biography'),
        const SizedBox(height: 12),
        ExpandableText(text: bio),
        const SizedBox(height: 28),
        PhotoGallery(title: person.name, photos: person.photos),
      ],
    );
  }
}
