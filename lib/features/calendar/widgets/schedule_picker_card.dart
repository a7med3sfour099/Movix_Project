import 'package:flutter/material.dart';
import 'package:movixapp/Widgets/custom_text.dart';
import 'package:movixapp/core/constants/app_colors.dart';

class SchedulePickerCard extends StatelessWidget {
  final String text;
  final bool isSelected;
  final VoidCallback onTap;

  const SchedulePickerCard({
    super.key,
    required this.text,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        decoration: BoxDecoration(
          color: const Color(0xFF13221C),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primary : const Color(0xFF23352E),
            width: isSelected ? 1.5 : 1.0,
          ),
        ),
        child: Center(
          child: CustomText(
            text: text,
            size: 13,
            weight: FontWeight.w600,
            color: isSelected ? AppColors.primary : const Color(0xFF5C6C66),
          ),
        ),
      ),
    );
  }
}
