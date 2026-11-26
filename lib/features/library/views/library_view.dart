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
import 'package:movixapp/features/history/widgets/history_card_widget.dart';
import 'package:movixapp/features/home/data/media_item.dart';
import 'package:movixapp/features/home/widgets/home_header.dart';
import 'package:movixapp/features/home/widgets/home_tabs.dart';
import 'package:movixapp/features/library/cubit/library_cubit.dart';
import 'package:movixapp/features/library/cubit/library_state.dart';
import 'package:movixapp/features/library/data/library_filter.dart';

class LibraryView extends StatefulWidget {
  /// Which tab to open first (e.g. from a Profile card).
  final LibraryTab initialTab;

  /// Which Movies / TV filter to start with.
  final MediaFilter initialFilter;

  const LibraryView({
    super.key,
    this.initialTab = LibraryTab.favorites,
    this.initialFilter = MediaFilter.all,
  });

  @override
  State<LibraryView> createState() => _LibraryViewState();
}

class _LibraryViewState extends State<LibraryView> {
  late LibraryTab _tab = widget.initialTab;
  late MediaFilter _filter = widget.initialFilter;

  // The three tabs are pages you can swipe between (or tap).
  late final PageController _pageController =
      PageController(initialPage: widget.initialTab.index);

  // True while a tap on a tab is animating the PageView, so the pages we
  // pass on the way do not flicker the selected tab.
  bool _animating = false;

  static const _tabs = LibraryTab.values;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _goToTab(LibraryTab tab) async {
    setState(() => _tab = tab);
    if (!_pageController.hasClients) return;
    _animating = true;
    await _pageController.animateToPage(
      tab.index,
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOut,
    );
    _animating = false;
  }

  List<MediaItem> _itemsFor(LibraryState state, LibraryTab tab) {
    final all = switch (tab) {
      // Newest added first (these two lists are stored oldest first).
      LibraryTab.favorites => state.favorites.reversed,
      LibraryTab.watchlist => state.watchlist.reversed,
      // History is already newest first (read ordered by watched_at).
      LibraryTab.history => state.history,
    };
    return all.where(_filter.matches).toList();
  }

  void _snack(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  void _openDetails(MediaItem item) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MediaDetailsView(id: item.id, type: item.type),
      ),
    );
  }

  void _confirmRemove(MediaItem item, LibraryTab tab) {
    final (title, description, icon) = switch (tab) {
      LibraryTab.favorites => (
          'Remove from favorites?',
          'Are you sure you want to remove this title from your favorites? It will no longer appear in your saved library.',
          Symbols.favorite,
        ),
      LibraryTab.watchlist => (
          'Remove from watchlist?',
          'Are you sure you want to remove this title from your watchlist? It will no longer appear in your saved library.',
          Symbols.bookmark,
        ),
      LibraryTab.history => (
          'Delete from History',
          'Are you sure you want to remove this title from your history?',
          Symbols.history,
        ),
    };

    showDialog(
      context: context,
      builder: (dialogContext) => AreYouSureDialog(
        title: title,
        description: description,
        icon: icon,
        iconColor: const Color(0xFFE53935),
        iconBackgroundColor: const Color(0xFF331718),
        confirmText: 'Remove',
        confirmIcon: Symbols.delete,
        confirmColor: const Color(0xFF990000),
        onConfirm: () {
          Navigator.of(dialogContext).pop();
          final cubit = context.read<LibraryCubit>();
          switch (tab) {
            case LibraryTab.favorites:
              cubit.removeFromFavorites(item);
            case LibraryTab.watchlist:
              cubit.removeFromWatchlist(item);
            case LibraryTab.history:
              cubit.removeFromHistory(item);
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B1512),
      bottomNavigationBar: const BottomBar(),
      body: SafeArea(
        child: BlocBuilder<LibraryCubit, LibraryState>(
          builder: (context, state) {
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
                // Tabs: Favorites | Watchlist | History
                UnderlineTabs(
                  tabs: const ['Favorites', 'Watchlist', 'History'],
                  counts: [
                    state.favorites.length,
                    state.watchlist.length,
                    state.history.length,
                  ],
                  selectedIndex: _tabs.indexOf(_tab),
                  onTap: (index) => _goToTab(_tabs[index]),
                ),
                // Swipe left / right to move between the 3 pages.
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    onPageChanged: (index) {
                      if (_animating) return;
                      setState(() => _tab = _tabs[index]);
                    },
                    children: [
                      for (final tab in _tabs) _page(state, tab),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  /// Filter chips (All / Movies / TV Shows). They live INSIDE each page's
  /// scroll view, so they scroll away with the content.
  Widget _filterBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: HomeTabs(
          tabs: [for (final f in MediaFilter.values) f.label],
          selectedIndex: MediaFilter.values.indexOf(_filter),
          onTap: (index) =>
              setState(() => _filter = MediaFilter.values[index]),
        ),
      ),
    );
  }

  Widget _page(LibraryState state, LibraryTab tab) {
    final items = _itemsFor(state, tab);

    return LayoutBuilder(
      builder: (context, constraints) {
        final isHistory = tab == LibraryTab.history;
        final width = constraints.maxWidth;
        const horizontalPadding = 16.0;

        // History keeps the card from the Figma design.
        final double gap = isHistory ? 18 : 12;
        final columns = !isHistory
            ? 2
            : width < 600
                ? 2
                : width < 900
                    ? 3
                    : 4;
        final cellWidth =
            (width - horizontalPadding * 2 - gap * (columns - 1)) / columns;
        // Poster is 2:3, then a fixed block for the texts and the button.
        // A fixed height (not a ratio) so the card never overflows.
        final extent = cellWidth * 1.5 + (isHistory ? 130 : 135);

        return CustomScrollView(
          key: PageStorageKey<String>('library_scroll_${tab.name}'),
          slivers: [
            SliverToBoxAdapter(child: _filterBar()),
            if (items.isEmpty)
              SliverFillRemaining(
                hasScrollBody: false,
                child: _emptyState(tab),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                sliver: SliverGrid(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: columns,
                    crossAxisSpacing: gap,
                    mainAxisSpacing: isHistory ? 18 : 16,
                    mainAxisExtent: extent,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => _card(items[index], tab),
                    childCount: items.length,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _card(MediaItem item, LibraryTab tab) {
    final cubit = context.read<LibraryCubit>();

    if (tab == LibraryTab.history) {
      return HistoryCard(
        item: item,
        onTap: () => _openDetails(item),
        onDelete: () => cubit.removeFromHistory(item),
        onFavorite: () {
          if (cubit.isFavorite(item.id)) {
            _snack('Already in your favorites');
          } else {
            cubit.addToFavorites(item);
            _snack('Added to favorites');
          }
        },
      );
    }

    return LibraryCard(
      item: item,
      isFavoriteTab: tab == LibraryTab.favorites,
      isWatched: cubit.isWatched(item.id, item.type),
      onTap: () => _openDetails(item),
      onDelete: () => _confirmRemove(item, tab),
      onAddToHistory: () {
        cubit.markWatched(item);
        _snack('Added to history');
      },
      onAddToWatchlist: () {
        if (cubit.isWatched(item.id, item.type)) {
          _snack('Already watched, so it can\'t go to the watchlist');
        } else if (cubit.isInWatchlist(item.id)) {
          _snack('Already in your watchlist');
        } else {
          cubit.addFavoriteToWatchlist(item);
          _snack('Added to watchlist');
        }
      },
    );
  }

  Widget _emptyState(LibraryTab tab) {
    final (icon, title, subtitle) = switch (tab) {
      LibraryTab.favorites => (
          Symbols.favorite,
          'No favorites yet',
          'Saved movies and shows will show up here',
        ),
      LibraryTab.watchlist => (
          Symbols.bookmark,
          'Your watchlist is empty',
          'Saved movies and shows will show up here',
        ),
      LibraryTab.history => (
          Symbols.history,
          'No History Yet',
          'Movies and shows you mark as watched will show up here',
        ),
    };
    final filtered = _filter != MediaFilter.all;

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 48, color: HomeHeader.greenColor),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            filtered ? 'Nothing here for "${_filter.label}"' : subtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Color(0xFF7C8B85), fontSize: 13),
          ),
        ],
      ),
    );
  }
}

class LibraryCard extends StatelessWidget {
  final MediaItem item;
  final bool isFavoriteTab;
  final bool isWatched;
  final VoidCallback onDelete;
  final VoidCallback onTap;
  final VoidCallback onAddToHistory;
  final VoidCallback onAddToWatchlist;

  const LibraryCard({
    super.key,
    required this.item,
    required this.isFavoriteTab,
    required this.isWatched,
    required this.onDelete,
    required this.onTap,
    required this.onAddToHistory,
    required this.onAddToWatchlist,
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
                    top: isFavoriteTab ? null : 8,
                    bottom: isFavoriteTab ? 8 : null,
                    right: isFavoriteTab ? null : 8,
                    left: isFavoriteTab ? 8 : null,
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
                  if (isFavoriteTab)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: GestureDetector(
                        onTap: onAddToWatchlist,
                        child: Container(
                          width: 34,
                          height: 34,
                          decoration: BoxDecoration(
                            color: const Color(0xCC131D1B),
                            shape: BoxShape.circle,
                            border: Border.all(color: HomeHeader.greenColor),
                          ),
                          child: Icon(
                            Symbols.bookmark,
                            size: 18,
                            color: HomeHeader.greenColor,
                          ),
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
              onPressed: isWatched ? null : onAddToHistory,
              style: ElevatedButton.styleFrom(
                backgroundColor: HomeHeader.greenColor,
                foregroundColor: const Color(0xFF0B1512),
                padding: const EdgeInsets.symmetric(vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
                disabledBackgroundColor: const Color(0xFF1E2E29),
                disabledForegroundColor: const Color(0xFF7C8B85),
              ),
              child: Text(
                isWatched ? 'In history' : 'Add to history',
                style: const TextStyle(
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
