import 'package:flutter/material.dart';
import 'package:movixapp/core/constants/app_colors.dart';

void showCustomSnackBar(
  BuildContext context, {
  required String message,
  bool isError = false,
}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        message,
        style: const TextStyle(
          color: AppColors.background,
          fontWeight: FontWeight.w600,
        ),
      ),
      backgroundColor: isError ? Colors.redAccent : AppColors.primary,
      behavior: SnackBarBehavior.floating,
      duration: const Duration(seconds: 3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
  );
}