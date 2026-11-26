import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:movixapp/Widgets/custom_back_button.dart';
import 'package:movixapp/Widgets/underline_tabs.dart';
import 'package:movixapp/core/bottom_bar.dart';
import 'package:movixapp/features/details/views/media_details_view.dart';
import 'package:movixapp/features/home/widgets/home_header.dart';
import 'package:movixapp/features/library/cubit/library_cubit.dart';
import 'package:movixapp/features/library/cubit/library_state.dart';
import 'package:movixapp/features/library/widgets/library_card_widget.dart';

class LibraryView extends StatelessWidget {
  const LibraryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B1512),
      bottomNavigationBar: const BottomBar(),
      body: SafeArea(
        child: BlocBuilder<LibraryCubit, LibraryState>(
          builder: (context, state) {
            final favorites = state.favorites;
            final watchlist = state.watchlist;
            final selectedTab = state.selectedTab;
            final currentItems = selectedTab == 0 ? favorites : watchlist;

            return Column(
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: CustomBackButton(),
                      ),
                      const Text(
                        'Library',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                // Tabs
                UnderlineTabs(
                  tabs: const ['Favorites', 'Watchlist'],
                  counts: [favorites.length, watchlist.length],
                  selectedIndex: selectedTab,
                  onTap: (index) {
                    context.read<LibraryCubit>().selectTab(index);
                  },
                ),
                // Content Grid or Empty State
                Expanded(
                  child: currentItems.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                selectedTab == 0
                                    ? Symbols.favorite
                                    : Symbols.bookmark,
                                size: 48,
                                color: HomeHeader.greenColor,
                              ),
                              const SizedBox(height: 12),
                              Text(
                                selectedTab == 0
                                    ? 'No favorites yet'
                                    : 'Your watchlist is empty',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                'Saved movies and shows will show up here',
                                style: TextStyle(
                                  color: Color(0xFF7C8B85),
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: LayoutBuilder(
                            builder: (context, constraints) {
                              int crossAxisCount;
                              double childAspectRatio;

                              if (constraints.maxWidth < 400) {
                                crossAxisCount = 2;
                                childAspectRatio = 0.46;
                              } else if (constraints.maxWidth < 600) {
                                crossAxisCount = 2;
                                childAspectRatio = 0.51;
                              } else if (constraints.maxWidth < 900) {
                                crossAxisCount = 3;
                                childAspectRatio = 0.55;
                              } else {
                                crossAxisCount = 4;
                                childAspectRatio = 0.6;
                              }

                              return GridView.builder(
                                itemCount: currentItems.length,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: crossAxisCount,
                                  childAspectRatio: childAspectRatio,
                                  crossAxisSpacing: 18,
                                  mainAxisSpacing: 18,
                                ),
                                itemBuilder: (context, index) {
                                  final item = currentItems[index];
                                  return LibraryCard(
                                    item: item,
                                    isFavoriteTab: selectedTab == 0,
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => MediaDetailsView(
                                            id: item.id,
                                            type: item.type,
                                          ),
                                        ),
                                      );
                                    },
                                    onDelete: () {
                                      if (selectedTab == 0) {
                                        context
                                            .read<LibraryCubit>()
                                            .removeFromFavorites(item);
                                      } else {
                                        context
                                            .read<LibraryCubit>()
                                            .removeFromWatchlist(item);
                                      }
                                    },
                                  );
                                },
                              );
                            },
                          ),
                        ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
