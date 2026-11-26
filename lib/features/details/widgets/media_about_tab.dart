import 'package:flutter/material.dart';
import 'package:movixapp/Widgets/expandable_text.dart';
import 'package:movixapp/Widgets/section_title.dart';
import 'package:movixapp/features/details/data/media_details.dart';
import 'package:movixapp/features/details/widgets/star_rating.dart';

class MediaAboutTab extends StatelessWidget {
  final MediaDetails details;

  const MediaAboutTab({super.key, required this.details});

  @override
  Widget build(BuildContext context) {
    final overview = details.overview.isEmpty
        ? 'No overview available yet.'
        : details.overview;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle(title: 'Overview'),
        const SizedBox(height: 12),
        ExpandableText(text: overview),
        const SizedBox(height: 28),
        Row(
          children: [
            const Text(
              'Average Rating',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(width:20),
            StarRating(score: details.rawRating),
          ],
        ),
      ],
    );
  }
}
