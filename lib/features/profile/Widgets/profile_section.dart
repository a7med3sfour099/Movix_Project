import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:movixapp/Widgets/custom_text.dart';
import 'package:movixapp/core/constants/app_colors.dart';

class ProfileSection extends StatelessWidget {
  const ProfileSection({
    super.key,
    required this.title,
    required this.cards,
  });

  final String title;
  final List<Widget> cards;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const CircleAvatar(
              backgroundColor: AppColors.primary,
              radius: 4,
            ),
            const Gap(8),
            CustomText(
              text: title,
              weight: FontWeight.bold,
              size: 16,
            ),
          ],
        ),
        const Gap(12),
        Row(
          children: cards,
        ),
      ],
    );
  }
}
