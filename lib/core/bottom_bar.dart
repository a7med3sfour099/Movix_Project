import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:movixapp/core/bottom_bar_cubit.dart';
import 'package:movixapp/core/network/internet_cubit.dart';
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
        return MaterialPageRoute<void>(builder: (_) => const SearchScreen());

      case 2:
        return MaterialPageRoute<void>(
          builder: (_) =>
              LibraryView(initialTab: libraryTab, initialFilter: libraryFilter),
        );

      default:
        return MaterialPageRoute<void>(builder: (_) => const ProfileScreen());
    }
  }

  static void open(
    BuildContext context,
    int index, {
    SearchType searchType = SearchType.all,
    LibraryTab? libraryTab,
    MediaFilter libraryFilter = MediaFilter.all,
    bool allowOffline = false,
  }) {
    final isOffline = !context.read<InternetCubit>().state.isConnected;

    if (isOffline && !allowOffline) return;

    final isGuest = FirebaseAuth.instance.currentUser?.isAnonymous ?? false;

    if (isGuest && (index == 2 || index == 3)) {
      Navigator.pushNamed(context, '/guest-mode-error');
      return;
    }

    final cubit = context.read<BottomBarCubit>();
    final navigator = Navigator.of(context);

    if (index != 0 && cubit.state == index) return;

    cubit.selectItem(index);

    if (index == 0) {
      navigator.popUntil((route) => route.isFirst);
      return;
    }

    navigator
        .pushAndRemoveUntil(
          _routeFor(index, searchType, libraryTab, libraryFilter),
          (route) => route.isFirst,
        )
        .then((_) {
          if (cubit.state == index) {
            cubit.selectItem(0);
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InternetCubit, InternetState>(
      builder: (context, internetState) {
        final isOffline = !internetState.isConnected;

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
                      (index) => buildItem(context, index, selected, isOffline),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget buildItem(
    BuildContext context,
    int index,
    int selected,
    bool isOffline,
  ) {
    final isSelected = index == selected;

    final color = isOffline
        ? const Color(0xFF66716C)
        : isSelected
        ? HomeHeader.greenColor
        : const Color(0xFFB4C2BC);

    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: isOffline ? null : () => open(context, index),
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
              backgroundColor: isSelected && !isOffline
                  ? HomeHeader.greenColor
                  : Colors.transparent,
            ),
          ],
        ),
      ),
    );
  }
}
