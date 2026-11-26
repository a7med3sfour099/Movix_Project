import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:movixapp/Widgets/custom_back_button.dart';
import 'package:movixapp/core/bottom_bar.dart';
import 'package:movixapp/features/home/widgets/home_header.dart';
import 'package:movixapp/features/home/widgets/search_bar_field.dart';
import 'package:movixapp/features/search/cubit/history_cubit.dart';
import 'package:movixapp/features/search/cubit/search_cubit.dart';
import 'package:movixapp/features/search/data/search_api.dart';
import 'package:movixapp/features/search/data/search_filters.dart';
import 'package:movixapp/features/search/data/search_result.dart';
import 'package:movixapp/features/search/widgets/search_result_tile.dart';
import 'package:movixapp/features/search/widgets/search_sheets.dart';

class SearchScreen extends StatefulWidget {
  /// Opens the page with this text already searched (used by the Home search bar).
  final String initialQuery;

  const SearchScreen({super.key, this.initialQuery = ''});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _api = SearchApi();
  late final SearchCubit _cubit;
  late final HistoryCubit _history;
  late final TextEditingController _controller;
  Timer? _debounce;


  @override
  void initState() {
    super.initState();
    _cubit = SearchCubit(_api);
    _history = HistoryCubit();
    _controller = TextEditingController(text: widget.initialQuery);
    if (widget.initialQuery.trim().isNotEmpty) {
      _cubit.search(widget.initialQuery);
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    _cubit.close();
    _history.close();
    super.dispose();
  }

  void _onChanged(String text) {
    _debounce?.cancel();
    if (text.trim().isNotEmpty) _cubit.showLoading(text);
    // Wait until the user stops typing before calling the API.
    // An empty box has nothing to wait for, so it is applied at once.
    final delay = text.trim().isEmpty ? Duration.zero : searchDelay;
    _debounce = Timer(delay, () {
      _cubit.search(text);
    });
  }

  void _onSubmitted(String text) {
    _debounce?.cancel();
    _cubit.search(text);
    _history.addSearch(text);
  }

  // Tap on a history chip: search for that text again.
  void _useSearch(String text) {
    _controller.text = text;
    _controller.selection = TextSelection.collapsed(offset: text.length);
    _debounce?.cancel();
    _cubit.search(text);
  }

  // Tap on a result: save the search text and the item.
  void _onOpened(SearchResult result) {
    _history.addSearch(_cubit.state.query);
    _history.addViewed(result);
  }

  Future<void> _openFilters(SearchState state) async {
    final result = await showFilterSheet(
      context,
      current: state.filters,
      api: _api,
    );

    if (result != null) _cubit.applyFilters(result);
  }

  Future<void> _openSort(SearchState state) async {
    final choice = await showSortSheet(
      context,
      sort: state.sort,
      ascending: state.ascending,
    );
    if (choice != null) _cubit.applySort(choice.sort, choice.ascending);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: Scaffold(
        backgroundColor: const Color(0xFF0B1512),
        bottomNavigationBar: const BottomBar(),
        body: SafeArea(
          child: Column(
            children: [
              _header(),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
                child: CustomSearchBar(
                  controller: _controller,
                  hint: 'Search movies, TV shows, actors...',
                  onChanged: _onChanged,
                  onSubmitted: _onSubmitted,
                ),
              ),
              BlocBuilder<SearchCubit, SearchState>(
                builder: (context, state) => _chips(state),
              ),
              Expanded(
                child: BlocBuilder<SearchCubit, SearchState>(
                  builder: (context, state) => _body(state),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _header() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      child: Row(
        children: [
          const CustomBackButton(),
          const Expanded(
            child: Center(
              child: Text(
                'Search',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
          // Keeps the title centered.
          const SizedBox(width: 36),
        ],
      ),
    );
  }

  Widget _chips(SearchState state) {
    final active = state.filters.activeCount;
    final sortText =
        'Sort: ${state.sort.label} (${state.ascending ? 'Asc' : 'Desc'})';

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      child: Row(
        children: [
          _chip(
            icon: Symbols.tune,
            label: active == 0 ? 'Filter' : 'Filter ($active)',
            highlighted: active > 0,
            onTap: () => _openFilters(state),
          ),
          const SizedBox(width: 10),
          Flexible(
            child: _chip(
              icon: Symbols.swap_vert,
              label: sortText,
              highlighted:
              state.sort != SearchSort.popularity || state.ascending,
              onTap: () => _openSort(state),
            ),
          ),
        ],
      ),
    );
  }

  Widget _chip({
    required IconData icon,
    required String label,
    required bool highlighted,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: HomeHeader.darkColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: highlighted ? HomeHeader.greenColor : const Color(0xFF26322D),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: HomeHeader.greenColor),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _message(IconData icon, String text) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 44, color: const Color(0xFF3B4A44)),
          const SizedBox(height: 12),
          Text(
            text,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Color(0xFF7C8B85), fontSize: 14),
          ),
        ],
      ),
    );
  }

  // Shown when the search box is empty.
  Widget _historyView() {
    return BlocBuilder<HistoryCubit, HistoryState>(
      bloc: _history,
      builder: (context, history) {
        if (history.searches.isEmpty && history.viewed.isEmpty) {
          return _message(
            Symbols.search,
            'Search for movies, TV shows and actors',
          );
        }

        return ListView(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
          children: [
            if (history.searches.isNotEmpty) ...[
              _historyTitle('Search History', _history.clearSearches),
              const SizedBox(height: 10),
              SizedBox(
                height: 40,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: history.searches.length,
                  separatorBuilder: (_, _) => const SizedBox(width: 8),
                  itemBuilder: (context, index) =>
                      _historyChip(history.searches[index]),
                ),
              ),
              const SizedBox(height: 20),
            ],
            if (history.viewed.isNotEmpty) ...[
              _historyTitle('Recently Viewed', _history.clearViewed),
              const SizedBox(height: 10),
              for (final item in history.viewed) ...[
                SearchResultTile(
                  result: item,
                  onOpen: () => _history.addViewed(item),
                ),
                const SizedBox(height: 10),
              ],
            ],
          ],
        );
      },
    );
  }

  Widget _historyTitle(String text, VoidCallback onClear) {
    return Row(
      children: [
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        InkWell(
          onTap: onClear,
          customBorder: const CircleBorder(),
          child: const Padding(
            padding: EdgeInsets.all(6),
            child: Icon(Symbols.delete, color: Color(0xFF9AA8A2), size: 22),
          ),
        ),
      ],
    );
  }

  Widget _historyChip(String text) {
    return InkWell(
      onTap: () => _useSearch(text),
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: const Color(0xFF1B2823),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          text,
          style: const TextStyle(color: Colors.white, fontSize: 13),
        ),
      ),
    );
  }

  Widget _body(SearchState state) {
    // Empty box and no filters: history. Empty box + filters: their results.
    if (state.query.isEmpty && !state.browsing) {
      return _historyView();
    }

    if (state.loading) {
      return const Center(
        child: CircularProgressIndicator(color: HomeHeader.greenColor),
      );
    }

    if (state.error != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(state.error!, style: const TextStyle(color: Colors.white)),
            TextButton(
              onPressed: _cubit.retry,
              child: const Text('Try again'),
            ),
          ],
        ),
      );
    }

    final items = state.visible;

    if (items.isEmpty) {
      return _message(
        Symbols.search_off,
        state.results.isEmpty
            ? 'No results found'
            : 'No results match your filters',
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
      itemCount: items.length,
      separatorBuilder: (_, _) => const SizedBox(height: 10),
      itemBuilder: (context, index) => SearchResultTile(
        result: items[index],
        onOpen: () => _onOpened(items[index]),
      ),
    );
  }
}