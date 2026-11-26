import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:movixapp/Widgets/info_chip.dart';
import 'package:movixapp/Widgets/media_poster.dart';
import 'package:movixapp/core/utils/date_utils.dart';
import 'package:movixapp/features/details/data/media_details.dart';
import 'package:movixapp/features/home/widgets/home_header.dart';
// Shows the title, backdrop, poster, and key details for movies and TV shows
class MediaHeader extends StatelessWidget {
  final MediaDetails details;
  const MediaHeader({super.key, required this.details});

  @override
  Widget build(BuildContext context) {
    final d = details;
    // Same gray + COMING SOON look as the cards, for unreleased titles
    final banner = d.isUnreleased ? MediaPoster.bannerFor(d.date) : null;
    final greenLine = [
      d.isTv ? 'TV SHOW' : 'MOVIE',
      if (d.year.isNotEmpty) d.year,
    ].join(' \u2022 ');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 330,
          child: Stack(
            children: [
              _backdrop(d.backdrop, banner),
              Positioned(
                left: 16,
                right: 16,
                bottom: 0,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    SizedBox(
                      width: 120,
                      child: MediaPoster(
                        url: d.poster,
                        bannerText: banner,
                        radius: 16,
                        compact: true,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(child: _titleBlock(greenLine)),
                  ],
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              if (d.language.isNotEmpty) InfoChip(text: d.language),
              if (d.isUnreleased) const InfoChip(text: 'Not released yet'),
              for (final g in d.genres) InfoChip(text: g, highlight: true),
            ],
          ),
        ),
      ],
    );
  }

  Widget _titleBlock(String greenLine) {
    final d = details;
    final ratingText = d.voteCount == 0
        ? d.rating
        : '${d.rating} (${compactCount(d.voteCount)})';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          greenLine,
          style: const TextStyle(
            color: HomeHeader.greenColor,
            fontSize: 14,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          d.title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.w800,
            height: 1.15,
          ),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            InfoChip(
              text: ratingText,
              icon: Symbols.star,
              highlight: true,
              fontSize: 12,
            ),
            if (d.certification.isNotEmpty)
              InfoChip(text: d.certification, fontSize: 12),
            if (d.runtime.isNotEmpty) InfoChip(text: d.runtime, fontSize: 12),
          ],
        ),
      ],
    );
  }

  Widget _backdrop(String? url, String? banner) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Positioned(
          left: 0,
          right: 0,
          top: 0,
          height: 230,
          // MediaPoster handles the gray look + banner and the dark fallback
          child: MediaPoster(
            url: url,
            bannerText: banner,
            aspectRatio: 16 / 9,
            radius: 0,
          ),
        ),
        const Positioned(
          left: 0,
          right: 0,
          top: 0,
          height: 230,
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0x330B1512), Color(0xFF0B1512)],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
