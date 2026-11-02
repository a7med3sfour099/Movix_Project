import 'package:movixapp/Widgets/custom_text.dart';
import 'package:movixapp/Widgets/svg_image.dart';
import 'package:movixapp/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class CustomOutlinedButton extends StatelessWidget {
  const CustomOutlinedButton({
    super.key,

    required this.text,
    this.onPressed,
    this.showIcon = true,
    this.child,
    this.imageUrl,
    this.borderColor,
    this.isLoading = false,
  });

  final String? imageUrl;
  final String text;
  final VoidCallback? onPressed;
  final bool? showIcon;
  final Widget? child;
  final Color? borderColor;
  final bool isLoading;
  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        side: BorderSide(color: borderColor ?? AppColors.background, width: 2),
        minimumSize: Size(double.infinity, 50),
        elevation: 0,
        backgroundColor: Color(0xff141D1C),
      ),
      onPressed: isLoading ? null : onPressed,
      child: isLoading
          ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: AppColors.secondary,
              ),
            )
          : child ??
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      if (imageUrl != null && showIcon == true)
                        Positioned(
                          left: 0,
                          child: SvgImage(path: imageUrl!, size: 26),
                        ),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32),
                        child: Center(
                          child: CustomText(
                            text: text,
                            size: 20,
                            color: AppColors.secondary,
                            weight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }
}
