import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:movixapp/Widgets/custom_text.dart';
import 'package:movixapp/core/constants/app_colors.dart';
import 'package:movixapp/features/search/data/search_result.dart';

class SelectedMediaCard extends StatelessWidget {
  final SearchResult media;

  const SelectedMediaCard({super.key, required this.media});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFF13221C),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.primary, width: 1.5),
      ),
      child: Row(
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: media.image != null
                    ? Image.network(
                        media.image!,
                        width: 48,
                        height: 68,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            _posterPlaceholder(),
                      )
                    : _posterPlaceholder(),
              ),
              if (media.rating > 0)
                Positioned(
                  top: 4,
                  left: 4,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                    decoration: BoxDecoration(
                      color: const Color(0x990F1F1A),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      media.rating.toStringAsFixed(1),
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const Gap(12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: media.title,
                  size: 15,
                  weight: FontWeight.bold,
                  color: Colors.white,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const Gap(4),
                CustomText(
                  text: media.year != null ? '${media.year}' : media.date,
                  size: 12,
                  color: const Color(0xFF8B9B95),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFF1B382C),
              borderRadius: BorderRadius.circular(12),
            ),
            child: CustomText(
              text: media.type == 'tv' ? 'Tv Show' : 'Movie',
              size: 11,
              weight: FontWeight.w600,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _posterPlaceholder() {
    return Container(
      width: 48,
      height: 68,
      color: const Color(0xFF1B2825),
      child: const Center(
        child: Icon(
          Symbols.movie,
          color: AppColors.primary,
          size: 24,
        ),
      ),
    );
  }
}
