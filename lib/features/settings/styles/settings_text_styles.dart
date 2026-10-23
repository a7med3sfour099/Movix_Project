import 'package:flutter/material.dart';
import 'package:movixapp/core/constants/app_colors.dart';

class SettingsTextStyles {
  SettingsTextStyles._();

  static const sectionTitle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    fontVariations: [FontVariation('wget', 600)],
    height: 22 / 16,
    letterSpacing: 0.425,
    color: AppColors.secondary,
  );

  static const tileTitle = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    fontVariations: [FontVariation('wget', 400)],
    height: 15 / 12,
    color: Color(0xFFF3FFFC),
  );

  static const logout = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w700,
    fontVariations: [FontVariation('wget', 700)],
    height: 15 / 12,
    color: Color(0xFFE53935),
  );
}