import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:movixapp/core/bottom_bar_cubit.dart';
import 'package:movixapp/features/home/widgets/home_header.dart';

class BottomBar extends StatelessWidget {
  const BottomBar({super.key});

  static const icons = [
    Symbols.movie,
    Symbols.search,
    Symbols.video_library,
    Symbols.person,
  ];

  static const names = ['Discover', 'Search', 'Library', 'Profile'];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BottomBarCubit, int>(
      builder: (context, selected) {
        return Material(
          color: const Color(0xFF08130F),
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(20),
          ),
          child: SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.only(top: 6, bottom: 2),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(
                  4,
                      (index) => buildItem(context, index, selected),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget buildItem(BuildContext context, int index, int selected) {
    final isSelected = index == selected;
    final color = isSelected
        ? HomeHeader.greenColor
        : const Color(0xFFB4C2BC);

    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () => context.read<BottomBarCubit>().selectItem(index),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icons[index],
              color: color,
              size: 22,
              fill: isSelected ? 1 : 0,
            ),
            const SizedBox(height: 2),
            Text(
              names[index],
              style: TextStyle(
                color: color,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 2),
            CircleAvatar(
              radius: 2,
              backgroundColor:
              isSelected ? HomeHeader.greenColor : Colors.transparent,
            ),
          ],
        ),
      ),
    );
  }
}
