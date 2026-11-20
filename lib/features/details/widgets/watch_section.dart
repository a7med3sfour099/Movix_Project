import 'package:flutter/material.dart';
import 'package:movixapp/Widgets/media_poster.dart';
import 'package:movixapp/Widgets/section_title.dart';
import 'package:movixapp/features/details/data/media_details.dart';
import 'package:movixapp/features/home/widgets/home_header.dart';

/// Watch button for movies and series. Watching is not available yet,
/// so it stays grayscale with a COMING SOON or STAY TUNED banner.
class WatchSection extends StatelessWidget {
  final MediaDetails details;

  const WatchSection({super.key, required this.details});


  static const _accent = HomeHeader.greenColor;

  @override
  Widget build(BuildContext context) {
    final banner = details.isUnreleased
        ? MediaPoster.bannerFor(details.date)
        : MediaPoster.stayTuned;
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