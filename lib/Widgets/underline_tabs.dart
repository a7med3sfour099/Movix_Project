import 'package:flutter/material.dart';
import 'package:movixapp/features/home/widgets/home_header.dart';

// Tabs with a green underline and optional count pills next to labels.
class UnderlineTabs extends StatelessWidget {
  final List<String> tabs;
  final List<int?>? counts;
  final int selectedIndex;
  final ValueChanged<int> onTap;

  const UnderlineTabs({
    super.key,
    required this.tabs,
    required this.selectedIndex,
    required this.onTap,
    this.counts,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFF1E2E29))),
      ),
      child: Row(
        children: List.generate(
          tabs.length,
          (i) => Expanded(child: _tab(i)),
        ),
      ),
    );
  }

  Widget _tab(int index) {
    final selected = index == selectedIndex;
    final count = counts == null ? null : counts![index];
    return InkWell(
      onTap: () => onTap(index),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: selected ? HomeHeader.greenColor : Colors.transparent,
              width: 2.5,
            ),
          ),
        ),
        child: Row(
  mainAxisAlignment: MainAxisAlignment.center,
  mainAxisSize: MainAxisSize.min,
  children: [
    Flexible(
      child: Text(
        tabs[index],
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: selected
              ? HomeHeader.greenColor
              : const Color(0xFFB4C2BC),
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    if (count != null) ...[
      const SizedBox(width: 6),
      Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 8,
          vertical: 2,
        ),
        decoration: BoxDecoration(
          color: HomeHeader.darkColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          '$count',
          style: const TextStyle(
            color: Color(0xFFDBE5E2),
            fontSize: 13,
          ),
        ),
      ),
    ],
  ],
),
      ),
    );
  }
}
