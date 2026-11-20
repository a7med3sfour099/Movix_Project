import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:movixapp/core/bottom_bar.dart';
import 'package:movixapp/features/home/widgets/home_header.dart';
import 'package:movixapp/features/movies/cubit/media_grid_cubit.dart';
import 'package:movixapp/features/movies/data/movies_api.dart';
import 'package:movixapp/features/movies/widgets/media_grid_view.dart';
import 'package:movixapp/Widgets/custom_back_button.dart';

enum CatalogSort { popular, topRated, newest }

/// The "Movies" / "Tv Shows" pages: genre chip + filter + grid.
/// [type] is 'movie' or 'tv'.
class CatalogScreen extends StatefulWidget {
  final String title;
  final String type;

  const CatalogScreen({super.key, required this.title, required this.type});

  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  final _api = MoviesApi();
  late final MediaGridCubit _cubit;
  Map<int, String> _genres = {};
  int? _genreId;
  CatalogSort _sort = CatalogSort.popular;

  @override
  void initState() {
    super.initState();
    _cubit = MediaGridCubit(
      (page) => _api.getPage(
        '/discover/${widget.type}',
        widget.type,
        page: page,
        params: _params(),
      ),
    )..load();
    _loadGenres();
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  Future<void> _loadGenres() async {
    try {
      final genres = await _api.getGenresFor(widget.type);
      if (mounted) setState(() => _genres = genres);
    } catch (_) {
      // Chip just shows "All Genres" without a count.
    }
  }

  Map<String, dynamic> _params() {
    final isMovie = widget.type == 'movie';
    final today = DateTime.now().toIso8601String().substring(0, 10);
    final dateField = isMovie ? 'primary_release_date' : 'first_air_date';
    final sortBy = switch (_sort) {
      CatalogSort.popular => 'popularity.desc',
      CatalogSort.topRated => 'vote_average.desc',
      CatalogSort.newest => '$dateField.desc',
    };
    return {
      if (_genreId != null) 'with_genres': _genreId,
      'sort_by': sortBy,
      if (_sort == CatalogSort.topRated) 'vote_count.gte': 300,
      if (_sort == CatalogSort.newest) '$dateField.lte': today,
      if (_sort == CatalogSort.newest) 'vote_count.gte': 10,
    };
  }

  void _apply({int? genreId, bool clearGenre = false, CatalogSort? sort}) {
    setState(() {
      if (clearGenre) _genreId = null;
      if (genreId != null) _genreId = genreId;
      if (sort != null) _sort = sort;
    });
    _cubit.load();
  }

  String get _genreLabel {
    if (_genreId != null) return _genres[_genreId] ?? 'Genre';
    return _genres.isEmpty ? 'All Genres' : 'All Genres (${_genres.length})';
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                child: Row(
                  children: [
                    const CustomBackButton(),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        widget.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    _chip(_genreLabel, selected: true, onTap: _openGenreSheet),
                    const SizedBox(width: 10),
                    _chip(
                      'Filter',
                      icon: Symbols.tune,
                      selected: false,
                      highlighted: _sort != CatalogSort.popular,
                      onTap: _openSortSheet,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              const Expanded(child: MediaGridView()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _chip(
    String label, {
    required bool selected,
    required VoidCallback onTap,
    IconData? icon,
    bool highlighted = false,
  }) {
    final textColor =
        selected ? const Color(0xFF0B1512) : const Color(0xFF9AA8A2);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? HomeHeader.greenColor : HomeHeader.darkColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: highlighted ? HomeHeader.greenColor : const Color(0xFF26322D),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 16, color: textColor),
              const SizedBox(width: 6),
            ],
            Text(
              label,
              style: TextStyle(
                color: textColor,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openGenreSheet() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: HomeHeader.darkColor,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _sheetTitle('Genres'),
                const SizedBox(height: 12),
                Flexible(
                  child: SingleChildScrollView(
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _genreChoice(sheetContext, 'All', null),
                        for (final g in _genres.entries)
                          _genreChoice(sheetContext, g.value, g.key),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _genreChoice(BuildContext sheetContext, String name, int? id) {
    final selected = _genreId == id;
    return InkWell(
      onTap: () {
        Navigator.pop(sheetContext);
        if (id == null) {
          _apply(clearGenre: true);
        } else {
          _apply(genreId: id);
        }
      },
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? HomeHeader.greenColor : const Color(0xFF1B2823),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          name,
          style: TextStyle(
            color: selected ? const Color(0xFF0B1512) : Colors.white,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  void _openSortSheet() {
    const labels = {
      CatalogSort.popular: 'Most popular',
      CatalogSort.topRated: 'Top rated',
      CatalogSort.newest: 'Newest',
    };
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: HomeHeader.darkColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _sheetTitle('Sort by'),
                const SizedBox(height: 8),
                for (final entry in labels.entries)
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      entry.value,
                      style: const TextStyle(color: Colors.white),
                    ),
                    trailing: _sort == entry.key
                        ? const Icon(Symbols.check, color: HomeHeader.greenColor)
                        : null,
                    onTap: () {
                      Navigator.pop(sheetContext);
                      _apply(sort: entry.key);
                    },
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _sheetTitle(String text) => Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w800,
        ),
      );
}
