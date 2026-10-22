import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:movixapp/Widgets/custom_text.dart';
import 'package:movixapp/core/constants/app_colors.dart';

class CustomAppbar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppbar({
    super.key,
    required this.title,
    this.back,
    this.onPressed,
  });

  final String title;
  final bool? back;
  final VoidCallback? onPressed;
  @override
  Size get preferredSize => const Size.fromHeight(60);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: AppColors.background,
      leading: back == true
          ? Padding(
              padding: const EdgeInsets.all(10.0),
              child: CircleAvatar(
                radius: 18,
                backgroundColor: Color(0xff182120),
                child: IconButton(
                  padding: EdgeInsets.zero,
                  iconSize: 20,
                  icon: const Icon(
                    Icons.arrow_back,
                    color: AppColors.secondary,
                  ),
                  onPressed: onPressed,
                ),
              ),
            )
          : null,
      title: CustomText(text: '$title', size: 20, weight: FontWeight.bold),
      centerTitle: true,
    );
  }
}
