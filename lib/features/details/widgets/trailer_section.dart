import 'package:flutter/material.dart';
import 'package:movixapp/Widgets/section_title.dart';
import 'package:movixapp/features/details/widgets/trailer_player.dart';
import 'package:movixapp/features/home/widgets/home_header.dart';

/// "Official Trailer" title + player.
/// Shows a small message when TMDB has no trailer for this title.
class TrailerSection extends StatelessWidget {
  final String? videoKey;

  const TrailerSection({super.key, required this.videoKey});

  @override
  Widget build(BuildContext context) {
    final key = videoKey;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionTitle(title: 'Official Trailer'),
          const SizedBox(height: 12),
          if (key != null)
            TrailerPlayer(key: ValueKey(key), videoKey: key)
          else
            AspectRatio(
              aspectRatio: 16 / 9,
              child: Container(
                decoration: BoxDecoration(
                  color: HomeHeader.darkColor,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: const Color(0xFF1E2E29)),
                ),
                child: const Center(
                  child: Text(
                    'Trailer not available yet',
                    style: TextStyle(color: Color(0xFF7C8B85)),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
