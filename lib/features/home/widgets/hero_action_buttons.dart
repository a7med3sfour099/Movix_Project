import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:movixapp/core/constants/app_colors.dart';
import 'package:movixapp/features/details/views/media_details_view.dart';
import 'package:movixapp/features/home/data/movie_details.dart';

class HeroActionButtons extends StatelessWidget {
  final Movie movie;

  const HeroActionButtons({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: _TrailerButton(movie: movie)),
        const Gap(10),
        const _SaveButton(),
      ],
    );
  }
}

class _TrailerButton extends StatelessWidget {
  final Movie movie;

  const _TrailerButton({required this.movie});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => MediaDetailsView(id: movie.id, type: 'movie'),
        ),
      ),
      icon: const Icon(Symbols.play_arrow, size: 22, fill: 1),
      label: const Text(
        'Watch Trailer',
        style: TextStyle(fontWeight: FontWeight.w700),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.background,
        padding: const EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}

class _SaveButton extends StatelessWidget {
  const _SaveButton();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 46,
        height: 46,
        decoration: BoxDecoration(
          color: AppColors.quaternary,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.primary, width: 1),
        ),
        child: const Icon(
          Symbols.bookmark,
          color: AppColors.primary,
          weight: 300,
        ),
      ),
    );
  }
}
