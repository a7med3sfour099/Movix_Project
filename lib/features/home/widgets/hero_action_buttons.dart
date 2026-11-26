import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:movixapp/Widgets/are_you_sure_dialog.dart';
import 'package:movixapp/core/constants/app_colors.dart';
import 'package:movixapp/features/auth/widgets/custom_snackbar.dart';
import 'package:movixapp/features/details/views/media_details_view.dart';
import 'package:movixapp/features/home/data/media_item.dart';
import 'package:movixapp/features/home/data/movie_details.dart';
import 'package:movixapp/features/library/cubit/library_cubit.dart';

class HeroActionButtons extends StatelessWidget {
  final Movie movie;

  const HeroActionButtons({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: _TrailerButton(movie: movie)),
        const Gap(10),
        _SaveButton(movie: movie),
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
  final Movie movie;

  const _SaveButton({required this.movie});

  MediaItem _toItem() => MediaItem(
        id: movie.id,
        title: movie.title,
        year: movie.year,
        date: movie.year,
        type: 'movie',
        rating: movie.rating,
        image: movie.image,
      );

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<LibraryCubit>();
    final saved = cubit.isInWatchlist(movie.id);

    return InkWell(
      onTap: () {
        if (saved) {
          showDialog(
            context: context,
            builder: (dialogContext) => AreYouSureDialog(
              title: 'Remove from watchlist?',
              description:
                  'Are you sure you want to remove this movie from your watchlist? It will no longer appear in your saved library.',
              icon: Symbols.bookmark,
              iconColor: const Color(0xFFE53935),
              iconBackgroundColor: const Color(0xFF331718),
              confirmText: 'Remove',
              confirmIcon: Symbols.delete,
              confirmColor: const Color(0xFF990000),
              onConfirm: () {
                Navigator.of(dialogContext).pop();
                cubit.removeFromWatchlist(_toItem());
              },
            ),
          );
        } else if (!cubit.toggleWatchlist(_toItem())) {
          showCustomSnackBar(
            context,
            message: 'Already watched, so it can\'t go to the watchlist',
          );
        }
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 46,
        height: 46,
        decoration: BoxDecoration(
          color: saved ? AppColors.primary : AppColors.quaternary,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.primary, width: 1),
        ),
        child: Icon(
          Symbols.bookmark,
          color: saved ? AppColors.background : AppColors.primary,
          fill: saved ? 1 : 0,
          weight: 300,
        ),
      ),
    );
  }
}
