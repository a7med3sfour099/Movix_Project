import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:movixapp/Widgets/are_you_sure_dialog.dart';
import 'package:movixapp/features/details/data/media_details.dart';
import 'package:movixapp/features/home/data/media_item.dart';
import 'package:movixapp/features/home/widgets/home_header.dart';
import 'package:movixapp/features/library/cubit/library_cubit.dart';
import 'package:movixapp/features/details/widgets/rating_dialog.dart';
import 'package:movixapp/features/auth/widgets/custom_snackbar.dart';

extension MediaDetailsX on MediaDetails {
  MediaItem toMediaItem() {
    return MediaItem(
      id: id,
      title: title,
      year: year,
      date: date,
      type: type,
      rating: rating,
      genreId: null,
      image: poster,
    );
  }
}

class MediaActionBar extends StatelessWidget {
  final MediaDetails details;

  const MediaActionBar({super.key, required this.details});

  @override
  Widget build(BuildContext context) {
    final libraryCubit = context.watch<LibraryCubit>();
    final isFavorite = libraryCubit.isFavorite(details.id);
    final isInWatchlist = libraryCubit.isInWatchlist(details.id);
    final isWatched = libraryCubit.isWatched(details.id, details.type);

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: const Color(0xFF0C1A16),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF1E2E29)),
      ),
      child: Row(
        children: [
          Expanded(
            child: _ActionButton(
              icon: Symbols.star,
              label: 'Rate Now',
              onTap: () async {
                final rating = await showDialog<int>(
                  context: context,
                  barrierDismissible: true,
                  builder: (_) => RatingDialog(mediaType: details.type),
                );

                if (rating != null && context.mounted) {
                  showCustomSnackBar(
                    context,
                    message: 'Selected rating: $rating / 5',
                  );
                }
              },
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _ActionButton(
              icon: Symbols.bookmark,
              label: 'Watchlist',
              selected: isInWatchlist,
              onTap: () {
                if (isInWatchlist) {
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
                        libraryCubit.removeFromWatchlist(
                          details.toMediaItem(),
                        );
                      },
                    ),
                  );
                } else if (!libraryCubit.toggleWatchlist(details.toMediaItem())) {
                  showCustomSnackBar(
                    context,
                    message: 'Already watched, so it can\'t go to the watchlist',
                  );
                }
              },
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _ActionButton(
              icon: Symbols.favorite,
              label: 'Favorite',
              selected: isFavorite,
              onTap: () {
                if (isFavorite) {
                  showDialog(
                    context: context,
                    builder: (dialogContext) => AreYouSureDialog(
                      title: 'Remove from favorites?',
                      description:
                          'Are you sure you want to remove this movie from your favorites? It will no longer appear in your saved library.',
                      icon: Symbols.favorite,
                      iconColor: const Color(0xFFE53935),
                      iconBackgroundColor: const Color(0xFF331718),
                      confirmText: 'Remove',
                      confirmIcon: Symbols.delete,
                      confirmColor: const Color(0xFF990000),
                      onConfirm: () {
                        Navigator.of(dialogContext).pop();
                        libraryCubit.removeFromFavorites(
                          details.toMediaItem(),
                        );
                      },
                    ),
                  );
                } else {
                  libraryCubit.toggleFavorite(details.toMediaItem());
                }
              },
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _ActionButton(
              icon: Symbols.check_circle,
              label: 'Watched',
              selected: isWatched,
              onTap: () {
                if (isWatched) {
                  showDialog(
                    context: context,
                    builder: (dialogContext) => AreYouSureDialog(
                      title: 'Remove from history?',
                      description:
                          'Are you sure you want to remove this title from your history? It will no longer count as watched.',
                      icon: Symbols.history,
                      iconColor: const Color(0xFFE53935),
                      iconBackgroundColor: const Color(0xFF331718),
                      confirmText: 'Remove',
                      confirmIcon: Symbols.delete,
                      confirmColor: const Color(0xFF990000),
                      onConfirm: () {
                        Navigator.of(dialogContext).pop();
                        libraryCubit.removeFromHistory(details.toMediaItem());
                      },
                    ),
                  );
                } else {
                  libraryCubit.markWatched(details.toMediaItem());
                  showCustomSnackBar(
                    context,
                    message: 'Added to history',
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback? onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    this.selected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = selected ? const Color(0xFF0B1512) : HomeHeader.greenColor;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: selected ? HomeHeader.greenColor : HomeHeader.darkColor,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 26, fill: selected ? 1 : 0),
            const SizedBox(height: 6),
            FittedBox(
              child: Text(
                label,
                style: TextStyle(
                  color: color,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
