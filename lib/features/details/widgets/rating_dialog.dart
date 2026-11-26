
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:movixapp/Widgets/custom_elevated_button.dart';
import 'package:movixapp/Widgets/custom_text.dart';
import 'package:movixapp/core/constants/app_colors.dart';
import 'package:movixapp/features/details/cubit/rating.dart';

class RatingDialog extends StatelessWidget {
  final String mediaType;

  const RatingDialog({
    super.key,
    required this.mediaType,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => RatingCubit(),
      child: BlocBuilder<RatingCubit, int>(
        builder: (context, rating) {
          final cubit = context.read<RatingCubit>();

          return Dialog(
            backgroundColor: AppColors.background,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: BorderSide(color: AppColors.primary.withValues(alpha: 0.3)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(
                        Symbols.close,
                        color: Colors.white70,
                      ),
                    ),
                  ),

                  Icon(
                    Symbols.star,
                    color: AppColors.primary,
                    size: 42,
                    fill: 1,
                  ),

                  const SizedBox(height: 16),

                  CustomText(
                    text: 'Rate this ${mediaType == 'tv' ? 'TV Show' : 'Movie'}',
                    size: 21,
                    color: AppColors.secondary,
                    weight: FontWeight.bold,
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 10),

                  const CustomText(
                    text: 'How would you rate it?',
                    size: 16,
                    color: AppColors.secondary,
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 24),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      5,
                      (index) => IconButton(
                        onPressed: () => cubit.selectRating(index + 1),
                        icon: Icon(
                          Symbols.star,
                          size: 34,
                          fill: index < rating ? 1 : 0,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  CustomText(
                    text: rating == 0 ? 'Select your rating' : '$rating / 5',
                    size: 18,
                    color: AppColors.primary,
                    weight: FontWeight.bold,
                  ),

                  const SizedBox(height: 24),

                  CustomElevatedbutton(
                    text: 'Submit Rating',
                    onPressed: rating == 0
                        ? null
                        : () => Navigator.pop(context, rating),
                    backgroundColor: AppColors.primary,
                  ),

                  const SizedBox(height: 8),

                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const CustomText(
                      text: 'Cancel',
                      size: 14,
                      color: AppColors.secondary,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
