import 'package:flutter/material.dart';
import 'package:movixapp/Widgets/custom_elevated_button.dart';
import 'package:movixapp/Widgets/custom_outlined_button.dart';
import 'package:movixapp/Widgets/custom_text.dart';

class AreYouSureDialog extends StatelessWidget {
  const AreYouSureDialog({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    this.iconColor = const Color(0xFFE53935),
    this.iconBackgroundColor = const Color(0xFF331718),
    this.confirmText = 'Log out',
    this.confirmIcon = Icons.logout_rounded,
    this.confirmColor = const Color(0xFF990000),
    this.cancelText = 'Cancel',
    this.onConfirm,
    this.onCancel,
  });

  final String title;
  final String description;
  final IconData icon;
  final Color iconColor;
  final Color iconBackgroundColor;
  final String confirmText;
  final IconData? confirmIcon;
  final Color confirmColor;
  final String cancelText;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color(0xFF131D1B),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: iconBackgroundColor,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    color: iconColor,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: CustomText(
                    text: title,
                    size: 20,
                    weight: FontWeight.w700,
                    color: const Color(0xFFF3FFFC),
                    textAlign: TextAlign.start,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            CustomText(
              text: description,
              size: 14,
              weight: FontWeight.w400,
              color: const Color(0xFFBBCABF),
              height: 1.4,
              maxLines: 5,
              textAlign: TextAlign.start,
            ),
            const SizedBox(height: 24),
            CustomElevatedbutton(
              text: confirmText,
              backgroundColor: confirmColor,
              onPressed: onConfirm,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (confirmIcon != null) ...[
                    Icon(confirmIcon, size: 18, color: Colors.white),
                    const SizedBox(width: 8),
                  ],
                  CustomText(
                    text: confirmText,
                    size: 16,
                    color: Colors.white,
                    weight: FontWeight.w600,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            CustomOutlinedButton(
              text: cancelText,
              borderColor: const Color(0xFF2D3735),
              onPressed: onCancel ?? () => Navigator.of(context).pop(),
              child: Center(
                child: CustomText(
                  text: cancelText,
                  size: 16,
                  color: const Color(0xFFF3FFFC),
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
