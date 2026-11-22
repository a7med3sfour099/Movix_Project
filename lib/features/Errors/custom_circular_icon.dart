import 'package:flutter/material.dart';
import 'package:movixapp/core/constants/app_colors.dart';

class CustomCircularIcon extends StatelessWidget {
  const CustomCircularIcon({super.key, required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 176,
          height: 176,
          decoration: BoxDecoration(
            color: AppColors.StackBackground1,
            shape: BoxShape.circle,
          ),
        ),
        Container(
          width: 128,
          height: 128,
          decoration: BoxDecoration(
            color: AppColors.StackBackground2,
            shape: BoxShape.circle,
          ),
        ),
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: AppColors.StackBackground3,
            shape: BoxShape.circle,
          ),
        ),
        Icon(icon, size: 40, color: AppColors.primary),
      ],
    );
  }
}
