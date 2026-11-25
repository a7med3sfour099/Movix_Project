import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:movixapp/Widgets/custom_text.dart';
import 'package:movixapp/core/constants/app_colors.dart';

class ProfileStatCard extends StatelessWidget {
  const ProfileStatCard({
    super.key,
    required this.title,
    required this.icon,
    required this.count,
    required this.subtitle,
    this.onTap,
  });

  final String title;
  final IconData icon;
  final String count;
  final String subtitle;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
            
          height: 112,
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: AppColors.InputFiledBackground,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: AppColors.primary.withValues(alpha: 0.30),
            ),
            
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: CustomText(
                      text: title,
                      size: 12,
                      weight: FontWeight.w600,
                      maxLines: 2,
                      textAlign: TextAlign.start,
                      height: 1.4,
                      color: AppColors.secondary,
                    ),
                  ),
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: AppColors.InputFiledBackground,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: AppColors.primary.withValues(alpha: 0.3)
                      )
                    ),
                    child: Icon(
                      icon,
                      color: AppColors.primary,
                      size: 20,
                    ),
                  ),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  CustomText(
                    text: count,
                    size: 32,
                    weight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                  Gap(5),
                  CustomText(
                    text: subtitle,
                    size: 10,
                    weight: FontWeight.bold,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
