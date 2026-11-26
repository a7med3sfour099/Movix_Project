import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:movixapp/Widgets/custom_text.dart';
import 'package:movixapp/core/constants/app_colors.dart';
import 'package:movixapp/features/home/data/movie_details.dart';
import 'package:movixapp/features/home/widgets/hero_image.dart';
import 'package:movixapp/features/home/widgets/hero_action_buttons.dart';
import 'package:movixapp/features/home/widgets/hero_label.dart';
import 'package:movixapp/features/home/widgets/hero_rating.dart';

class HeroCard extends StatelessWidget {
  final Movie movie;

  const HeroCard({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    final greenLine = [
      if (movie.year.isNotEmpty) 'PREMIERE ${movie.year}',
      movie.time,
    ].where((part) => part.isNotEmpty).join(' \u2022 ').toUpperCase();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: AspectRatio(
            aspectRatio: 0.95,
            child: Stack(
              fit: StackFit.expand,
              children: [
                HeroImage(url: movie.image),
                if (movie.genre.isNotEmpty)
                  Positioned(
                    top: 12,
                    left: 12,
                    child: HeroGenreLabel(genre: movie.genre),
                  ),
                Positioned(
                  top: 12,
                  right: 12,
                  child: HeroRatingBadge(rating: movie.rating),
                ),
              ],
            ),
          ),
        ),
        const Gap(14),
        CustomText(
          text: greenLine,
          size: 12,
          color: AppColors.primary,
          weight: FontWeight.w600,
        ),
        const Gap(4),
        CustomText(
          text: movie.title,
          size: 24,
          color: Colors.white,
          weight: FontWeight.w800,
        ),
        const Gap(4),
        Text(
          movie.story,
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(color: Color(0xFFB4C2BC), fontSize: 13),
        ),
        const Gap(14),
        HeroActionButtons(movie: movie),
      ],
    );
  }
}