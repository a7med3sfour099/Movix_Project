import 'package:flutter/material.dart';
import 'package:movixapp/Widgets/media_poster.dart';
import 'package:movixapp/Widgets/section_title.dart';
import 'package:movixapp/features/details/data/media_details.dart';
import 'package:movixapp/features/home/widgets/home_header.dart';

/// Watch button for movies and series. Watching is not available yet,
/// Watch button Always grayscale with a WATCHING SOON banner
class WatchSection extends StatelessWidget {
  final MediaDetails details;

  const WatchSection({super.key, required this.details});
  static const _accent = HomeHeader.greenColor;

  @override
  Widget build(BuildContext context) {
    // Watching is not available yet for any title, so the text is fixed
    const banner = MediaPoster.watchSoon;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionTitle(title: details.isTv ? 'Watch Series' : 'Watch Movie'),
          const SizedBox(height: 12),
          MediaPoster(
            url: details.backdrop ?? details.poster,
            bannerText: banner,
            accentColor: _accent,
            aspectRatio: 16 / 9,
            radius: 18,
          ),
        ],
      ),
    );
  }
}