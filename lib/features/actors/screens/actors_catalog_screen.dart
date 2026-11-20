import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:movixapp/Widgets/custom_text.dart';
import 'package:movixapp/core/bottom_bar.dart';
import 'package:movixapp/features/actors/cubit/actors_cubit.dart';
import 'package:movixapp/features/actors/data/actor.dart';
import 'package:movixapp/features/actors/data/actors_api.dart';
import 'package:movixapp/features/actors/widgets/actors_grid_view.dart';
import 'package:movixapp/features/home/widgets/home_header.dart';
import 'package:movixapp/Widgets/custom_back_button.dart';

enum ActorSort {
  popular('Most popular', ActorsApi.popularPath),
  trendingDay('Trending today', ActorsApi.trendingDayPath),
  trendingWeek('Trending this week', ActorsApi.trendingWeekPath);

  final String label;
  final String path;
  const ActorSort(this.label, this.path);
}

/// Actors page with gender and sorting filters.
class ActorsCatalogScreen extends StatefulWidget {
  final String title;
  final ActorSort initialSort;

  const ActorsCatalogScreen({
    super.key,
    this.title = 'Actors',
    this.initialSort = ActorSort.popular,
  });

  @override
  State<ActorsCatalogScreen> createState() => _ActorsCatalogScreenState();
}

class _ActorsCatalogScreenState extends State<ActorsCatalogScreen> {
  final _api = ActorsApi();
  late final ActorsCubit _cubit;
  late ActorSort _sort = widget.initialSort;
  ActorGender _gender = ActorGender.all;

  static const _genderLabels = {
    ActorGender.all: 'All Actors',
    ActorGender.female: 'Actresses',
    ActorGender.male: 'Actors (Male)',
  };

  @override
  void initState() {
    super.initState();
    // Uses the latest filter values whenever load() is called
    _cubit = ActorsCubit(
          (page) => _api.getPage(_sort.path, page: page, gender: _gender),
    )..load();
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  void _apply({ActorGender? gender, ActorSort? sort}) {
    setState(() {
      if (gender != null) _gender = gender;
      if (sort != null) _sort = sort;
    });
    _cubit.load();
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
              _header(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    _chip(
                      _genderLabels[_gender]!,
                      selected: true,
                      onTap: _openGenderSheet,
                    ),
                    const SizedBox(width: 10),
                    _chip(
                      _sort == ActorSort.popular ? 'Filter' : _sort.label,
                      icon: Symbols.tune,
                      highlighted: _sort != ActorSort.popular,
                      onTap: _openSortSheet,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              const Expanded(child: ActorsGridView()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _header() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Row(
        children: [
          const CustomBackButton(),
          const SizedBox(width: 12),
          Expanded(
            child: CustomText(
              text: widget.title,
              size: 18,
              weight: FontWeight.w800,
              textAlign: TextAlign.start,
            ),
          ),
        ],
      ),
    );
  }

  Widget _chip(
      String label, {
        bool selected = false,
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
            CustomText(
              text: label,
              color: textColor,
              size: 13,
              weight: FontWeight.w600,
            ),
          ],
        ),
      ),
    );
  }

  void _openGenderSheet() {
    _openSheet(
      title: 'Show',
      options: _genderLabels,
      selected: _gender,
      onSelected: (g) => _apply(gender: g),
    );
  }

  void _openSortSheet() {
    _openSheet(
      title: 'Sort by',
      options: {for (final s in ActorSort.values) s: s.label},
      selected: _sort,
      onSelected: (s) => _apply(sort: s),
    );
  }

  void _openSheet<T>({
    required String title,
    required Map<T, String> options,
    required T selected,
    required ValueChanged<T> onSelected,
  }) {
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
                CustomText(
                  text: title,
                  size: 16,
                  weight: FontWeight.w800,
                  textAlign: TextAlign.start,
                ),
                const SizedBox(height: 8),
                for (final entry in options.entries)
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: CustomText(
                      text: entry.value,
                      textAlign: TextAlign.start,
                    ),
                    trailing: entry.key == selected
                        ? const Icon(Symbols.check, color: HomeHeader.greenColor)
                        : null,
                    onTap: () {
                      Navigator.pop(sheetContext);
                      onSelected(entry.key);
                    },
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}