import 'dart:io';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:movixapp/Widgets/custom_text.dart';
import 'package:movixapp/core/constants/app_colors.dart';

class HomeHeader extends StatelessWidget {
  final String imagePath;
  final VoidCallback onSettingsTap;
  final VoidCallback onProfileTap;

  const HomeHeader({
    super.key,
    required this.imagePath,
    required this.onSettingsTap,
    required this.onProfileTap,
  });

  static const Color greenColor = Color(0xFF4FE4A6);
  static const Color darkColor = Color(0xFF0F1F1A);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Image.asset('assets/images/logo.png', width: 36, height: 36),
        const SizedBox(width: 8),
        CustomText(
          text: 'Movix'.toUpperCase(),
          color: AppColors.primary,
          size: 22,
          weight: FontWeight.w800,
        ),
        const Spacer(),

        IconButton(
          onPressed: onSettingsTap,
          icon: const Icon(
            Symbols.settings,
            color: AppColors.primary,
            size: 26,
            weight: 200,
          ),
        ),

        InkWell(
          onTap: onProfileTap,
          customBorder: const CircleBorder(),
          child: Container(
            width: 42,
            height: 42,
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.quaternary,
              border: Border.all(color: AppColors.primary, width: 1),
            ),
            child: ClipOval(child: buildImage()),
          ),
        ),
      ],
    );
  }

  //
  Widget buildImage() {
    if (imagePath == '') {
      return const Icon(Icons.person, color: AppColors.primary, size: 22);
    }
    return Image.file(File(imagePath), fit: BoxFit.cover);
  }
}
