import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:movixapp/features/home/widgets/home_header.dart';
import 'package:movixapp/features/search/data/search_api.dart';
import 'package:movixapp/features/search/data/search_filters.dart';

const _sheetColor = Color(0xFF0F1F1A);
const _chipColor = Color(0xFF1B2823);
const _mutedColor = Color(0xFF9AA8A2);

const _sheetShape = RoundedRectangleBorder(
  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
);

Future<SearchFilters?> showFilterSheet(
  BuildContext context, {
  required SearchFilters current,
  required SearchApi api,
}) {
  return showModalBottomSheet<SearchFilters>(
    context: context,
    isScrollControlled: true,
    backgroundColor: _sheetColor,
    shape: _sheetShape,
    builder: (_) => _FilterSheet(initial: current, api: api),
  );
}

class SortChoice {
  final SearchSort sort;
  final bool ascending;

  const SortChoice(this.sort, this.ascending);
}

Future<SortChoice?> showSortSheet(
  BuildContext context, {
  required SearchSort sort,
  required bool ascending,
}) {
  return showModalBottomSheet<SortChoice>(
    context: context,
    backgroundColor: _sheetColor,
    shape: _sheetShape,
    builder: (_) => _SortSheet(sort: sort, ascending: ascending),
  );
}

// ---------------------------------------------------------------- shared bits

class _SheetHeader extends StatelessWidget {
  final IconData icon;
  final String title;
  final List<Widget> actions;

  const _SheetHeader({
    required this.icon,
    required this.title,
    this.actions = const [],
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: HomeHeader.greenColor, size: 22),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        ...actions,
        const SizedBox(width: 8),
        InkWell(
          onTap: () => Navigator.pop(context),
          customBorder: const CircleBorder(),
          child: Container(
            width: 32,
            height: 32,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: _chipColor,
            ),
            child: const Icon(Icons.close, color: Colors.white, size: 18),
          ),
        ),
      ],
    );
  }
}

class _ApplyButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _ApplyButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: HomeHeader.greenColor,
          foregroundColor: const Color(0xFF0B1512),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
        icon: const Icon(Icons.check, size: 20),
        label: const Text(
          'Apply',
          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
        ),
      ),
    );
  }
}

Widget _sectionTitle(String text, {String? trailing}) {
  return Row(
    children: [
      Expanded(
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      if (trailing != null)
        Text(
          trailing,
          style: const TextStyle(
            color: HomeHeader.greenColor,
            fontSize: 13,
            fontWeight: FontWeight.w700,
          ),
        ),
    ],
  );
}

class _Pill extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final bool showCheck;

  const _Pill({
    required this.label,
    required this.selected,
    required this.onTap,
    this.showCheck = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? HomeHeader.greenColor : _chipColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (selected && showCheck) ...[
              const Icon(Icons.check, size: 14, color: Color(0xFF0B1512)),
              const SizedBox(width: 4),
            ],
            Text(
              label,
              style: TextStyle(
                color: selected ? const Color(0xFF0B1512) : Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// --------------------------------------------------------------- filter sheet

class _FilterSheet extends StatefulWidget {
  final SearchFilters initial;
  final SearchApi api;

  const _FilterSheet({required this.initial, required this.api});

  @override
  State<_FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends State<_FilterSheet> {
  late SearchFilters _draft = widget.initial;
  late Future<List<String>> _genres = widget.api.genreNames(_draft.type);

  static const _typeLabels = {
    SearchType.all: 'All',
    SearchType.movies: 'Movies',
    SearchType.tv: 'TV Shows',
  };

  void _setType(SearchType type) {
    if (type == _draft.type) return;
    setState(() {
      // Genres differ between movies and TV, so start the genres again.
      _draft = _draft.copyWith(type: type, genres: {});
      _genres = widget.api.genreNames(type);
    });
  }

  void _toggleGenre(String name) {
    final genres = {..._draft.genres};
    if (!genres.remove(name)) genres.add(name);
    setState(() => _draft = _draft.copyWith(genres: genres));
  }

  void _reset() {
    setState(() {
      _draft = const SearchFilters();
      _genres = widget.api.genreNames(SearchType.all);
    });
  }

  @override
  Widget build(BuildContext context) {
    final maxHeight = MediaQuery.of(context).size.height * 0.88;

    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: maxHeight),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _SheetHeader(
                icon: Symbols.tune,
                title: 'Filters',
                actions: [
                  TextButton(
                    onPressed: _reset,
                    child: const Text(
                      'Reset',
                      style: TextStyle(color: _mutedColor),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Flexible(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _typeSelector(),
                      const SizedBox(height: 20),
                      _sectionTitle('Genres'),
                      const SizedBox(height: 10),
                      _genreChips(),
                      const SizedBox(height: 20),
                      _ratingSlider(),
                      const SizedBox(height: 20),
                      _sectionTitle('Release Year'),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          for (final decade in searchDecades)
                            _Pill(
                              label: decadeLabel(decade),
                              selected: _draft.decade == decade,
                              onTap: () => setState(() {
                                _draft = decade == null
                                    ? _draft.copyWith(clearDecade: true)
                                    : _draft.copyWith(decade: decade);
                              }),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              _ApplyButton(onPressed: () => Navigator.pop(context, _draft)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _typeSelector() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: _chipColor,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          for (final entry in _typeLabels.entries)
            Expanded(
              child: GestureDetector(
                onTap: () => _setType(entry.key),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: _draft.type == entry.key
                        ? HomeHeader.greenColor
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (_draft.type == entry.key) ...[
                        const Icon(
                          Icons.check,
                          size: 14,
                          color: Color(0xFF0B1512),
                        ),
                        const SizedBox(width: 4),
                      ],
                      Text(
                        entry.value,
                        style: TextStyle(
                          color: _draft.type == entry.key
                              ? const Color(0xFF0B1512)
                              : _mutedColor,
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _genreChips() {
    return FutureBuilder<List<String>>(
      future: _genres,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Center(
              child: SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: HomeHeader.greenColor,
                ),
              ),
            ),
          );
        }
        if (snapshot.hasError || (snapshot.data ?? []).isEmpty) {
          return const Text(
            'Could not load genres',
            style: TextStyle(color: _mutedColor, fontSize: 13),
          );
        }
        return Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final name in snapshot.data!)
              _Pill(
                label: name,
                selected: _draft.genres.contains(name),
                showCheck: true,
                onTap: () => _toggleGenre(name),
              ),
          ],
        );
      },
    );
  }

  Widget _ratingSlider() {
    final value = _draft.minRating;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle(
          'Rating',
          trailing: value == 0 ? 'Any' : '${value.toStringAsFixed(1)}+',
        ),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: HomeHeader.greenColor,
            inactiveTrackColor: _chipColor,
            thumbColor: HomeHeader.greenColor,
            overlayColor: HomeHeader.greenColor.withValues(alpha: 0.15),
            trackHeight: 4,
          ),
          child: Slider(
            value: value,
            min: 0,
            max: 10,
            divisions: 20,
            onChanged: (v) =>
                setState(() => _draft = _draft.copyWith(minRating: v)),
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('0', style: TextStyle(color: _mutedColor, fontSize: 11)),
              Text('2.5', style: TextStyle(color: _mutedColor, fontSize: 11)),
              Text('5', style: TextStyle(color: _mutedColor, fontSize: 11)),
              Text('7.5', style: TextStyle(color: _mutedColor, fontSize: 11)),
              Text('10', style: TextStyle(color: _mutedColor, fontSize: 11)),
            ],
          ),
        ),
      ],
    );
  }
}

// ----------------------------------------------------------------- sort sheet

class _SortSheet extends StatefulWidget {
  final SearchSort sort;
  final bool ascending;

  const _SortSheet({required this.sort, required this.ascending});

  @override
  State<_SortSheet> createState() => _SortSheetState();
}

class _SortSheetState extends State<_SortSheet> {
  late SearchSort _sort = widget.sort;
  late bool _ascending = widget.ascending;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SheetHeader(
              icon: Symbols.swap_vert,
              title: 'Sort By',
              actions: [
                InkWell(
                  onTap: () => setState(() => _ascending = !_ascending),
                  customBorder: const CircleBorder(),
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: _chipColor,
                    ),
                    child: Icon(
                      _ascending ? Icons.arrow_upward : Icons.arrow_downward,
                      color: HomeHeader.greenColor,
                      size: 18,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            for (final option in SearchSort.values) _option(option),
            const SizedBox(height: 12),
            _ApplyButton(
              onPressed: () =>
                  Navigator.pop(context, SortChoice(_sort, _ascending)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _option(SearchSort option) {
    final selected = _sort == option;
    return InkWell(
      onTap: () => setState(() => _sort = option),
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Icon(
              selected
                  ? Symbols.radio_button_checked
                  : Symbols.radio_button_unchecked,
              color: selected ? HomeHeader.greenColor : _mutedColor,
              size: 22,
            ),
            const SizedBox(width: 12),
            Text(
              option.label,
              style: TextStyle(
                color: selected ? Colors.white : _mutedColor,
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              '(${option.hint(_ascending)})',
              style: const TextStyle(color: _mutedColor, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
