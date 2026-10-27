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
