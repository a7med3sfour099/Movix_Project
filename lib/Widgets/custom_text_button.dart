import 'package:movixapp/Widgets/custom_text.dart';
import 'package:flutter/material.dart';

class CustomTextButton extends StatelessWidget {
  const CustomTextButton({
    super.key,
    required this.text,
    required this.color,
    required this.size,
    required this.weight,
    this.onPressed,
  });

  final String text;
  final Color color;
  final double size;
  final FontWeight weight;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
       style: TextButton.styleFrom(
        padding: EdgeInsets.zero,
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      child: CustomText(
        text: text,
        size: size,
        color: color,
        weight: weight,
      ),
    );
  }
}