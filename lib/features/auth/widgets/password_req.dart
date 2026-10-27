import 'package:flutter/material.dart';
import 'package:movixapp/Widgets/custom_text.dart';
import 'package:movixapp/core/constants/app_colors.dart';

class PasswordRequirement extends StatelessWidget {
  const PasswordRequirement({
    super.key,
    required this.text,
    this.isChecked = false,
  });

  final String text;
  final bool isChecked;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Row(
        children: [
          Transform.scale(
            scale: 0.9,
            child: Checkbox(
              value: isChecked,
              shape: const CircleBorder(),
              onChanged: (value) {},
              activeColor: AppColors.primary,
              checkColor: AppColors.background,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              visualDensity: VisualDensity.compact,
              side: const BorderSide(color: AppColors.secondary, width: 1.5),
            ),
          ),
          Expanded(
  child: CustomText(
    text: text,
    color: AppColors.secondary,
    size: 12,
    textAlign: TextAlign.left,
    maxLines: 2,
    overflow: TextOverflow.visible,
  ),
),
        ],
      ),
    );
  }
}
