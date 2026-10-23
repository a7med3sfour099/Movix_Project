import 'package:movixapp/Widgets/custom_text.dart';
import 'package:movixapp/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class CustomOutlinedButton extends StatelessWidget {
  const CustomOutlinedButton({
    super.key,
    this.backgroundImage,
    required this.text,
    this.onPressed,
    this.showIcon = true,
    this.child,
  });

  final String? backgroundImage;
  final String text;
  final VoidCallback? onPressed;
  final bool? showIcon;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        side: BorderSide(color: AppColors.background, width: 2),
        minimumSize: Size(double.infinity, 50),
        elevation: 0,
        backgroundColor: Color(0xff141D1C),
      ),
      onPressed: onPressed,
      child:
          child ??
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (backgroundImage != null && showIcon!) ...[
                Image.asset(
                  backgroundImage!,
                  width: 31.5,
                  height: 32.14,
                  fit: BoxFit.cover,
                ),
              ],
              Gap(5),
              CustomText(
                text: text,
                size: 23,
                color: AppColors.secondary,
                weight: FontWeight.w500,
              ),
            ],
          ),
    );
  }
}
