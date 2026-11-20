import 'package:flutter/material.dart';
import 'package:movixapp/core/constants/app_colors.dart';

/// Round back arrow, same look as the one in CustomAppbar (Settings / Auth).
/// Goes back one screen unless [onPressed] is given.
class CustomBackButton extends StatelessWidget {
  const CustomBackButton({super.key, this.onPressed});

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 18,
      backgroundColor: const Color(0xff182120),
      child: IconButton(
        padding: EdgeInsets.zero,
        iconSize: 20,
        icon: const Icon(Icons.arrow_back, color: AppColors.secondary),
        onPressed: onPressed ?? () => Navigator.maybePop(context),
      ),
    );
  }
}
