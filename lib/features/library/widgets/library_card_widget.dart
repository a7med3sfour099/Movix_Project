import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:movixapp/Widgets/are_you_sure_dialog.dart';
import 'package:movixapp/Widgets/media_poster.dart';
import 'package:movixapp/core/constants/app_colors.dart';
import 'package:movixapp/features/home/data/media_item.dart';
import 'package:movixapp/features/home/widgets/home_header.dart';

class LibraryCard extends StatelessWidget {
  final MediaItem item;
  final bool isFavoriteTab;
  final bool isWatched;
  final VoidCallback onDelete;
  final VoidCallback onTap;
  final VoidCallback onAddToHistory;
  final VoidCallback onAddToWatchlist;

  const LibraryCard({
    super.key,
    required this.item,
    required this.isFavoriteTab,
    required this.isWatched,
    required this.onDelete,
    required this.onTap,
    required this.onAddToHistory,
    required this.onAddToWatchlist,
  });

  @override
  Widget build(BuildContext context) {
    final year = item.year;
    final rating = item.rating;

    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              MediaPoster(
                url: item.image,
                overlays: [
                  if (year.isNotEmpty)
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding:
                            const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                        decoration: BoxDecoration(
                          color: const Color(0x990F1F1A),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          year,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  Positioned(
                    top: isFavoriteTab ? null : 8,
                    bottom: isFavoriteTab ? 8 : null,
                    right: isFavoriteTab ? null : 8,
                    left: isFavoriteTab ? 8 : null,
                    child: Container(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                      decoration: BoxDecoration(
                        color: const Color(0x990F1F1A),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Symbols.star,
                              size: 12, fill: 1, color: AppColors.primary),
                          const SizedBox(width: 3),
                          Text(
                            rating,
                            style: const TextStyle(
                              color: AppColors.primary,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (isFavoriteTab)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: GestureDetector(
                        onTap: onAddToWatchlist,
                        child: Container(
                          width: 34,
                          height: 34,
                          decoration: BoxDecoration(
                            color: const Color(0xCC131D1B),
                            shape: BoxShape.circle,
                            border: Border.all(color: HomeHeader.greenColor),
                          ),
                          child: Icon(
                            Symbols.bookmark,
                            size: 18,
                            color: HomeHeader.greenColor,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              Positioned(
                bottom: 8,
                right: 8,
                child: GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (dialogContext) => AreYouSureDialog(
                        title: isFavoriteTab
                            ? 'Remove from favorites?'
                            : 'Remove from watchlist?',
                        description: isFavoriteTab
                            ? 'Are you sure you want to remove this movie from your favorites? It will no longer appear in your saved library.'
                            : 'Are you sure you want to remove this movie from your watchlist? It will no longer appear in your saved library.',
                        icon: isFavoriteTab
                            ? Symbols.favorite
                            : Symbols.bookmark,
                        iconColor: const Color(0xFFE53935),
                        iconBackgroundColor: const Color(0xFF331718),
                        confirmText: 'Remove',
                        confirmIcon: Symbols.delete,
                        confirmColor: const Color(0xFF990000),
                        onConfirm: () {
                          Navigator.of(dialogContext).pop();
                          onDelete();
                        },
                      ),
                    );
                  },
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: const Color(0xCC131D1B),
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0xFF2D3735)),
                    ),
                    child: const Icon(
                      Symbols.delete,
                      size: 18,
                      color: Color(0xFFE53935),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            item.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            item.type == 'tv' ? 'TV Show' : (item.date.isNotEmpty ? item.date : ''),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Color(0xFF7C8B85),
              fontSize: 12,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: isWatched ? null : onAddToHistory,
              style: ElevatedButton.styleFrom(
                backgroundColor: HomeHeader.greenColor,
                foregroundColor: const Color(0xFF0B1512),
                padding: const EdgeInsets.symmetric(vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
                disabledBackgroundColor: const Color(0xFF1E2E29),
                disabledForegroundColor: const Color(0xFF7C8B85),
              ),
              child: Text(
                isWatched ? 'In history' : 'Add to history',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
