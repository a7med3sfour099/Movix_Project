import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  const CustomText({
    super.key,
    required this.text,
    this.color = Colors.white,
    this.size = 16,
    this.weight = FontWeight.normal,
    this.textAlign = TextAlign.center,
    this.fontFamily = 'JakartaSans',
    this.overflow = TextOverflow.ellipsis,
    this.maxLines = 1,
    this.height = 1,
  });
  final String text;
  final Color color;
  final double size;
  final FontWeight weight;
  final TextAlign textAlign;
  final String fontFamily;
  final TextOverflow overflow;
  final int maxLines;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      overflow: overflow,
      maxLines: maxLines,
      textAlign: textAlign,
      style: TextStyle(
        color: color,
        fontSize: size,
        fontWeight: weight,
        fontFamily: fontFamily,
        height: height,
      ),
    );
  }
}
