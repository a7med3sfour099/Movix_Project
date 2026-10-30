import 'package:flutter/material.dart';
import 'home_header.dart';

class HomeTabs extends StatelessWidget {
  final List<String> tabs;
  final int selectedIndex;
  final ValueChanged<int> onTap;

  const HomeTabs({
    super.key,
    required this.tabs,
    required this.selectedIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(tabs.length, (index) {
          return Padding(
            padding: const EdgeInsets.only(right: 10),
            child: buildTab(index),
          );
        }),
      ),
    );
  }

  Widget buildTab(int index) {
    bool isSelected = index == selectedIndex;

    return InkWell(
      onTap: () => onTap(index),
      borderRadius: BorderRadius.circular(20),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 9),
        decoration: BoxDecoration(
          color: isSelected ? HomeHeader.greenColor : HomeHeader.darkColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          tabs[index],
          style: TextStyle(
            color: isSelected ? const Color(0xFF0B1512) : const Color(0xFF9AA8A2),
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
