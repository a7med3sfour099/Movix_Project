import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:movixapp/Widgets/custom_text.dart';
import 'package:movixapp/core/constants/app_colors.dart';

class HeroRatingBadge extends StatelessWidget {
  final String rating;

  const HeroRatingBadge({super.key, required this.rating});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.quaternary,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Symbols.star, size: 14, fill: 1, color: AppColors.primary),
          const SizedBox(width: 4),
          CustomText(
            text: rating,
            color: AppColors.primary,
            size: 12,
            weight: FontWeight.w700,
          ),
        ],
      ),
    );
  }
}
