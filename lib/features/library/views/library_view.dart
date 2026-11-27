import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:movixapp/Widgets/custom_back_button.dart';
import 'package:movixapp/Widgets/underline_tabs.dart';
import 'package:movixapp/core/bottom_bar.dart';
import 'package:movixapp/features/details/views/media_details_view.dart';
import 'package:movixapp/features/history/widgets/history_card_widget.dart';
import 'package:movixapp/features/home/data/media_item.dart';
import 'package:movixapp/features/home/widgets/home_header.dart';
import 'package:movixapp/features/home/widgets/home_tabs.dart';
import 'package:movixapp/features/library/cubit/library_cubit.dart';
import 'package:movixapp/features/library/cubit/library_state.dart';
import 'package:movixapp/features/library/data/library_filter.dart';
import 'package:movixapp/features/library/widgets/library_card_widget.dart';

class LibraryView extends StatefulWidget {
  /// Which tab to open first (e.g. from a Profile card).
  /// null = open the tab that was selected last time.
  final LibraryTab? initialTab;

  /// Which Movies / TV filter to start with.
  final MediaFilter initialFilter;

  const LibraryView({
    super.key,
    this.initialTab,
    this.initialFilter = MediaFilter.all,
  });

  @override
  State<LibraryView> createState() => _LibraryViewState();
}

class _LibraryViewState extends State<LibraryView> {
  late LibraryTab _tab;
  // Each tab remembers its own Movies / TV filter (default: All).
  // Leaving the Library and coming back starts again from All.
  late final Map<LibraryTab, MediaFilter> _filters;

  // The three tabs are pages you can swipe between (or tap).
  late final PageController _pageController;

  // True while a tap on a tab is animating the PageView, so the pages we
  // pass on the way do not flicker the selected tab.
  bool _animating = false;

  static const _tabs = LibraryTab.values;

  @override
  void initState() {
    super.initState();
    final saved = context.read<LibraryCubit>().state.selectedTab;
    _tab = widget.initialTab ?? _tabs[saved.clamp(0, _tabs.length - 1).toInt()];
    _filters = {for (final tab in _tabs) tab: MediaFilter.all};
    // filter from Profile affects only its tab
    _filters[_tab] = widget.initialFilter;
    _pageController = PageController(initialPage: _tab.index);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _goToTab(LibraryTab tab) async {
    setState(() => _tab = tab);
    context.read<LibraryCubit>().selectTab(tab.index);
    if (!_pageController.hasClients) return;
    _animating = true;
    await _pageController.animateToPage(
      tab.index,
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOut,
    );
    _animating = false;
  }

  MediaFilter _filterOf(LibraryTab tab) => _filters[tab] ?? MediaFilter.all;

  List<MediaItem> _itemsFor(LibraryState state, LibraryTab tab) {
    final all = switch (tab) {
      // Newest added first
      LibraryTab.favorites => state.favorites.reversed,
      LibraryTab.watchlist => state.watchlist.reversed,
      LibraryTab.history => state.history,
    };
    return all.where(_filterOf(tab).matches).toList();
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

  // The "are you sure" dialog is inside the cards, so this only removes.
  void _remove(MediaItem item, LibraryTab tab) {
    final cubit = context.read<LibraryCubit>();
    switch (tab) {
      case LibraryTab.favorites:
        cubit.removeFromFavorites(item);
      case LibraryTab.watchlist:
        cubit.removeFromWatchlist(item);
      case LibraryTab.history:
        cubit.removeFromHistory(item);
    }
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
                      context.read<LibraryCubit>().selectTab(index);
                    },
                    children: [for (final tab in _tabs) _page(state, tab)],
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
  Widget _filterBar(LibraryTab tab) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: HomeTabs(
          tabs: [for (final f in MediaFilter.values) f.label],
          selectedIndex: MediaFilter.values.indexOf(_filterOf(tab)),
          onTap: (index) =>
              setState(() => _filters[tab] = MediaFilter.values[index]),
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
        final extent = cellWidth * 1.5 + (isHistory ? 130 : 135);

        return CustomScrollView(
          key: PageStorageKey<String>('library_scroll_${tab.name}'),
          slivers: [
            SliverToBoxAdapter(child: _filterBar(tab)),
            if (items.isEmpty)
              SliverFillRemaining(hasScrollBody: false, child: _emptyState(tab))
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
      isInWatchlist: cubit.isInWatchlist(item.id),
      onTap: () => _openDetails(item),
      onDelete: () => _remove(item, tab),
      // add to History, or remove it if it is already there
      onToggleHistory: () {
        if (cubit.isWatched(item.id, item.type)) {
          cubit.removeFromHistory(item);
          _snack('Removed from history');
        } else {
          cubit.markWatched(item);
          _snack('Added to history');
        }
      },
      // add to Watchlist, or remove it if it is already there
      onToggleWatchlist: () {
        if (cubit.isWatched(item.id, item.type)) {
          _snack('Already watched, so it can\'t go to the watchlist');
        } else if (cubit.isInWatchlist(item.id)) {
          cubit.removeFromWatchlist(item);
          _snack('Removed from watchlist');
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
    final filter = _filterOf(tab);
    final filtered = filter != MediaFilter.all;

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
            filtered ? 'Nothing here for "${filter.label}"' : subtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Color(0xFF7C8B85), fontSize: 13),
          ),
        ],
      ),
    );
  }
}
