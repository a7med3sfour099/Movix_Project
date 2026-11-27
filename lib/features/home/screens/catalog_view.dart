import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:movixapp/core/bottom_bar.dart';
import 'package:movixapp/core/constants/app_colors.dart';
import 'package:movixapp/core/data/media_repository.dart';
import 'package:movixapp/core/services/genres_service.dart';
import 'package:movixapp/features/home/cubit/catalog_filter_cubit.dart';
import 'package:movixapp/features/home/cubit/catalog_filter_state.dart';
import 'package:movixapp/features/home/cubit/media_grid_cubit.dart';
import 'package:movixapp/features/home/widgets/home_header.dart';
import 'package:movixapp/Widgets/custom_back_button.dart';
import 'package:movixapp/features/movies/widgets/media_grid_view.dart';

class CatalogView extends StatelessWidget {
  final String title;
  final String type;

  const CatalogView({super.key, required this.title, required this.type});

  @override
  Widget build(BuildContext context) {
    final repo = MediaRepository.instance;

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => CatalogFilterCubit(),
        ),
        BlocProvider(
          create: (context) => MediaGridCubit(
            (page) {
              final filter = context.read<CatalogFilterCubit>().state;
              return repo.getPage(
                '/discover/$type',
                type,
                page: page,
                params: filter.toParams(isMovie: type == 'movie'),
              );
            },
          )..load(),
        ),
      ],
      child: _CatalogView(title: title, type: type),
    );
  }
}

class _CatalogView extends StatelessWidget {
  final String title;
  final String type;

  const _CatalogView({required this.title, required this.type});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B1512),
      bottomNavigationBar: const BottomBar(),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _header(title),
            _filters(context),
            const SizedBox(height: 8),
            const Expanded(child: MediaGridView()),
          ],
        ),
      ),
    );
  }

  Widget _header(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Row(
        children: [
          const CustomBackButton(),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
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
    );
  }

  Widget _filters(BuildContext context) {
    return BlocBuilder<CatalogFilterCubit, CatalogFilterState>(
      builder: (context, filter) {
        return BlocBuilder<GenresService, Map<int, String>>(
          bloc: GenresService.instance,
          builder: (context, allGenres) {
            final typedGenres = GenresService.instance.forType(type);
            final picked = filter.genreIds;
            final genreLabel = picked.isEmpty
                ? (typedGenres.isEmpty
                    ? 'All Genres'
                    : 'All Genres (${typedGenres.length})')
                : picked.length == 1
                    ? typedGenres[picked.first] ?? 'Genre'
                    : '${picked.length} Genres';

            // scrollable
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  _chip(
                    genreLabel,
                    selected: true,
                    onTap: () => _openGenreSheet(context, typedGenres),
                  ),
                  const SizedBox(width: 10),
                  _chip(
                    'Sort',
                    icon: Symbols.tune,
                    selected: false,
                    highlighted: filter.sort != CatalogSort.popular,
                    onTap: () => _openSortSheet(context, filter.sort),
                  ),
                  const SizedBox(width: 10),
                  // Arabic button: green = only Arabic, press again to go back to all
                  _chip(
                    'Arabic',
                    selected: filter.arabicOnly,
                    highlighted: filter.arabicOnly,
                    onTap: () {
                      context.read<CatalogFilterCubit>().toggleArabic();
                      _reloadGrid(context);
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
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
          color: selected ? AppColors.primary : AppColors.background,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: highlighted ? AppColors.primary : const Color(0xFF26322D),
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

  void _openGenreSheet(BuildContext context, Map<int, String> genres) {
    final filterCubit = context.read<CatalogFilterCubit>();
    // The picks stay a draft until the user taps Apply.
    final draft = Set<int>.of(filterCubit.state.genreIds);

    showModalBottomSheet<void>(
      context: context,
      backgroundColor: HomeHeader.darkColor,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (_, setSheetState) {
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
                            _genreChoice(
                              'All',
                              selected: draft.isEmpty,
                              onTap: () => setSheetState(draft.clear),
                            ),
                            for (final g in genres.entries)
                              _genreChoice(
                                g.value,
                                selected: draft.contains(g.key),
                                onTap: () => setSheetState(() {
                                  if (!draft.remove(g.key)) draft.add(g.key);
                                }),
                              ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(sheetContext);
                          filterCubit.applyGenres(draft);
                          _reloadGrid(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: AppColors.background,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: const Text(
                          'Apply',
                          style: TextStyle(fontWeight: FontWeight.w800),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _genreChoice(
    String name, {
    required bool selected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
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

  void _openSortSheet(BuildContext context, CatalogSort current) {
    const labels = {
      CatalogSort.popular: 'Most popular',
      CatalogSort.topRated: 'Top rated',
      CatalogSort.newest: 'Newest',
    };
    final filterCubit = context.read<CatalogFilterCubit>();
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
                    trailing: current == entry.key
                        ? const Icon(Symbols.check, color: HomeHeader.greenColor)
                        : null,
                    onTap: () {
                      Navigator.pop(sheetContext);
                      filterCubit.selectSort(entry.key);
                      _reloadGrid(context);
                    },
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _reloadGrid(BuildContext context) {
    if (context.mounted) {
      context.read<MediaGridCubit>().load();
    }
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