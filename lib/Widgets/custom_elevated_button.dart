import 'package:flutter/material.dart';
import 'package:movixapp/Widgets/custom_text.dart';
import 'package:movixapp/core/constants/app_colors.dart';

class CustomElevatedbutton extends StatelessWidget {
  const CustomElevatedbutton({
    super.key,
    required this.text,
    this.onPressed,
    this.child,
    this.backgroundColor,
    this.size = 20,
    this.isLoading = false,
  });

  final String text;
  final VoidCallback? onPressed;
  final Widget? child;
  final Color? backgroundColor;
  final double size;
  final bool isLoading;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        backgroundColor: backgroundColor ?? AppColors.primary,
        disabledBackgroundColor: backgroundColor ?? AppColors.primary,
        minimumSize: const Size(double.infinity, 50),
      ),
      onPressed: isLoading ? null : onPressed,
      child: isLoading
          ? const SizedBox(
              width: 22,
              height: 22,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                color: AppColors.background,
              ),
            )
          : CustomText(
              text: text,
              size: size,
              color: AppColors.background,
              weight: FontWeight.bold,
              textAlign: TextAlign.center,
            ),
    );
  }
}
