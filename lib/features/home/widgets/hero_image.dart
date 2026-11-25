import 'package:flutter/material.dart';
import 'package:movixapp/core/constants/app_colors.dart';

class HeroImage extends StatelessWidget {
  final String? url;

  const HeroImage({super.key, required this.url});

  static const _darkBackground = ColoredBox(color: AppColors.quaternary);

  @override
  Widget build(BuildContext context) {
    if (url == null) return _darkBackground;
    return Image.network(
      url!,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stack) => _darkBackground,
    );
  }
}