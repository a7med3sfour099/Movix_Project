import 'package:flutter/material.dart';
import 'package:movixapp/features/home/widgets/home_header.dart';

// Small rounded label with an optional highlight style.
class InfoChip extends StatelessWidget {
  final String text;
  final IconData? icon;
  final bool highlight;
  final double fontSize;

  const InfoChip({
    super.key,
    required this.text,
    this.icon,
    this.highlight = false,
    this.fontSize = 13,
  });

  @override
  Widget build(BuildContext context) {
    final color = highlight ? HomeHeader.greenColor : const Color(0xFFDBE5E2);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: highlight ? const Color(0x224FE4A6) : HomeHeader.darkColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: highlight ? HomeHeader.greenColor : const Color(0xFF1E2E29),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: fontSize + 2, color: color),
            const SizedBox(width: 4),
          ],
          Text(
            text,
            style: TextStyle(
              color: color,
              fontSize: fontSize,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
