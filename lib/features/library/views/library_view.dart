import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:movixapp/Widgets/are_you_sure_dialog.dart';
import 'package:movixapp/Widgets/custom_back_button.dart';
import 'package:movixapp/Widgets/media_poster.dart';
import 'package:movixapp/Widgets/underline_tabs.dart';
import 'package:movixapp/core/bottom_bar.dart';
import 'package:movixapp/core/constants/app_colors.dart';
import 'package:movixapp/features/details/views/media_details_view.dart';
import 'package:movixapp/features/home/data/media_item.dart';
import 'package:movixapp/features/home/widgets/home_header.dart';
import 'package:movixapp/features/library/cubit/library_cubit.dart';
import 'package:movixapp/features/library/cubit/library_state.dart';

class LibraryView extends StatefulWidget {
  const LibraryView({super.key});

  @override
  State<LibraryView> createState() => _LibraryViewState();
}

class _LibraryViewState extends State<LibraryView> {
  int _selectedTab = 0; // 0: Favorites, 1: Watchlist

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
            final currentItems = _selectedTab == 0 ? favorites : watchlist;

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
                  selectedIndex: _selectedTab,
                  onTap: (index) {
                    setState(() {
                      _selectedTab = index;
                    });
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
                                _selectedTab == 0
                                    ? Symbols.favorite
                                    : Symbols.bookmark,
                                size: 48,
                                color: HomeHeader.greenColor,
                              ),
                              const SizedBox(height: 12),
                              Text(
                                _selectedTab == 0
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
                      : LayoutBuilder(
                          builder: (context, constraints) {
                            const horizontalPadding = 16.0;
                            const spacing = 12.0;
                            final cellWidth =
                                (constraints.maxWidth - horizontalPadding * 2 - spacing) / 2;

                            return GridView.builder(
                              padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: spacing,
                                mainAxisSpacing: 16,
                                mainAxisExtent: cellWidth * 1.5 + 135,
                              ),
                              itemCount: currentItems.length,
                              itemBuilder: (context, index) {
                                final item = currentItems[index];
                                return LibraryCard(
                                  item: item,
                                  isFavoriteTab: _selectedTab == 0,
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
                                    showDialog(
                                      context: context,
                                      builder: (dialogContext) => AreYouSureDialog(
                                        title: _selectedTab == 0
                                            ? 'Remove from favorites?'
                                            : 'Remove from watchlist?',
                                        description: _selectedTab == 0
                                            ? 'Are you sure you want to remove this movie from your favorites? It will no longer appear in your saved library.'
                                            : 'Are you sure you want to remove this movie from your watchlist? It will no longer appear in your saved library.',
                                        icon: _selectedTab == 0
                                            ? Symbols.favorite
                                            : Symbols.bookmark,
                                        iconColor: const Color(0xFFE53935),
                                        iconBackgroundColor: const Color(0xFF331718),
                                        confirmText: 'Remove',
                                        confirmIcon: Symbols.delete,
                                        confirmColor: const Color(0xFF990000),
                                        onConfirm: () {
                                          Navigator.of(dialogContext).pop();
                                          if (_selectedTab == 0) {
                                            context
                                                .read<LibraryCubit>()
                                                .removeFromFavorites(item);
                                          } else {
                                            context
                                                .read<LibraryCubit>()
                                                .removeFromWatchlist(item);
                                          }
                                        },
                                      ),
                                    );
                                  },
                                );
                              },
                            );
                          },
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

class LibraryCard extends StatelessWidget {
  final MediaItem item;
  final bool isFavoriteTab;
  final VoidCallback onDelete;
  final VoidCallback onTap;

  const LibraryCard({
    super.key,
    required this.item,
    required this.isFavoriteTab,
    required this.onDelete,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final year = item.year;
    final rating = item.rating;

    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              MediaPoster(
                url: item.image,
                overlays: [
                  if (year.isNotEmpty)
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding:
                            const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                        decoration: BoxDecoration(
                          color: const Color(0x990F1F1A),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          year,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                      decoration: BoxDecoration(
                        color: const Color(0x990F1F1A),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Symbols.star,
                              size: 12, fill: 1, color: AppColors.primary),
                          const SizedBox(width: 3),
                          Text(
                            rating,
                            style: const TextStyle(
                              color: AppColors.primary,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Positioned(
                bottom: 8,
                right: 8,
                child: GestureDetector(
                  onTap: onDelete,
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: const Color(0xCC131D1B),
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0xFF2D3735)),
                    ),
                    child: const Icon(
                      Symbols.delete,
                      size: 18,
                      color: Color(0xFFE53935),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            item.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            item.type == 'tv' ? 'TV Show' : (item.date.isNotEmpty ? item.date : ''),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Color(0xFF7C8B85),
              fontSize: 12,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Added to history')),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: HomeHeader.greenColor,
                foregroundColor: const Color(0xFF0B1512),
                padding: const EdgeInsets.symmetric(vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: const Text(
                'Add to history',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
