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
  });

  final String text;
  final VoidCallback? onPressed;
  final Widget? child;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        backgroundColor: backgroundColor ??  AppColors.secondary,
        minimumSize: const Size(double.infinity, 50),
      ),
      onPressed: onPressed,
      child: child ??
          CustomText(
            text: text,
            size: 23,
            color: Colors.white,
            weight: FontWeight.w500,
            textAlign: TextAlign.center,
          ),
    );
  }
}