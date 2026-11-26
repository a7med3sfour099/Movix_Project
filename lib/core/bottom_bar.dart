import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:movixapp/core/bottom_bar_cubit.dart';
import 'package:movixapp/features/home/widgets/home_header.dart';
import 'package:movixapp/features/library/data/library_filter.dart';
import 'package:movixapp/features/library/views/library_view.dart';
import 'package:movixapp/features/profile/screens/profile_screen.dart';
import 'package:movixapp/features/search/data/search_filters.dart';
import 'package:movixapp/features/search/screens/search_screen.dart';

class BottomBar extends StatelessWidget {
  const BottomBar({super.key});

  static const icons = [
    Symbols.movie,
    Symbols.search,
    Symbols.video_library,
    Symbols.person,
  ];

  static const names = ['Discover', 'Search', 'Library', 'Profile'];

  static Route<void> _routeFor(
    int index,
    SearchType searchType,
    LibraryTab? libraryTab,
    MediaFilter libraryFilter,
  ) {
    switch (index) {
      case 1:
        return MaterialPageRoute<void>(
          builder: (_) => const SearchScreen(),
        );
      case 2:
        return MaterialPageRoute<void>(
          builder: (_) => LibraryView(
            initialTab: libraryTab,
            initialFilter: libraryFilter,
          ),
        );
      default:
        return MaterialPageRoute<void>(builder: (_) => const ProfileScreen());
    }
  }

  /// Switches tab: goes back to Home, then opens the tab's page on top of it.
  /// [searchType] is only used when opening Search.
  /// [libraryTab] / [libraryFilter] are only used when opening Library.
  static void open(
      BuildContext context,
      int index, {
        SearchType searchType = SearchType.all,
        LibraryTab? libraryTab,
        MediaFilter libraryFilter = MediaFilter.all,
      }) {
    final cubit = context.read<BottomBarCubit>();
    final navigator = Navigator.of(context);
    if (index != 0 && cubit.state == index) return;

    cubit.selectItem(index);
    if (index == 0) {
      navigator.popUntil((route) => route.isFirst);
      return;
    }

    // Replace everything above Home in one step (no pop-then-push flicker).
    navigator
        .pushAndRemoveUntil(
      _routeFor(index, searchType, libraryTab, libraryFilter),
          (route) => route.isFirst,
    )
        .then((_) {
      // Back to Home (e.g. with the back button) -> Discover is selected again.
      if (cubit.state == index) cubit.selectItem(0);
    });
  }

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
      onTap: () => open(context, index),
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