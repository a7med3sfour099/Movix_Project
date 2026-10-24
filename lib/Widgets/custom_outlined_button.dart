import 'package:movixapp/Widgets/custom_text.dart';
import 'package:movixapp/Widgets/svg_image.dart';
import 'package:movixapp/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class CustomOutlinedButton extends StatelessWidget {
  const CustomOutlinedButton({
    super.key,

    required this.text,
    this.onPressed,
    this.showIcon = true,
    this.child,
    this.imageUrl,
  });

  final String? imageUrl;
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
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              if (imageUrl != null && showIcon!) ...[
                SvgImage(
                  path:
                      imageUrl ?? 'assets/auth_assets/google-icon-logo-svg.svg',
                  size: 30,
                ),
              ],
              Gap(60),
              CustomText(
                text: text,
                size: 20,
                color: AppColors.secondary,
                weight: FontWeight.w500,

              ),
            ],
          ),
    );
  }
}
