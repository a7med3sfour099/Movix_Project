import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:movixapp/core/bottom_bar.dart';
import 'package:movixapp/Widgets/custom_back_button.dart';
import 'package:movixapp/features/home/widgets/home_header.dart';
import 'package:movixapp/features/home/widgets/search_bar_field.dart';
import 'package:movixapp/features/movies/cubit/media_grid_cubit.dart';
import 'package:movixapp/features/movies/data/movies_api.dart';
import 'package:movixapp/features/movies/widgets/media_grid_view.dart';

/// Used for: Popular Movies, Popular TV Shows, Top Movies, Top TV Shows,
/// Trending, Discover, Now Playing ("See More" from the home sections).
/// Has a search bar (by title) and a Sort button that work on the list.
class MediaListScreen extends StatefulWidget {
  final String title;
  final String path;
  final String type;
  final Map<String, dynamic>? params;

  /// Shows the "COMING SOON" overlay on every card and only upcoming movies.
  final bool upcoming;

  const MediaListScreen({
    super.key,
    required this.title,
    required this.path,
    this.type = 'movie',
    this.params,
    this.upcoming = false,
  });

  @override
  State<MediaListScreen> createState() => _MediaListScreenState();
}

class _MediaListScreenState extends State<MediaListScreen> {
  late final MediaGridCubit _cubit;
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    final api = MoviesApi();
    _cubit = MediaGridCubit(
      (page) => api.getPage(
        widget.path,
        widget.type,
        page: page,
        params: widget.upcoming ? MoviesApi.upcomingParams() : widget.params,
      ),
    )..load();
  }

  @override
  void dispose() {
    _controller.dispose();
    _cubit.close();
    super.dispose();
  }

  void _openSort() {
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
                const Text(
                  'Sort by',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 8),
                for (final option in GridSort.values)
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      option.label,
                      style: const TextStyle(color: Colors.white),
                    ),
                    trailing: _cubit.state.sort == option
                        ? const Icon(Symbols.check, color: HomeHeader.greenColor)
                        : null,
                    onTap: () {
                      Navigator.pop(sheetContext);
                      _cubit.setSort(option);
                    },
                  ),
              ],
            ),
          ),
        );
      },
    );
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
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 4),
                child: Row(
                  children: [
                    Expanded(
                      child: SearchBarField(
                        controller: _controller,
                        hint: 'Search in ${widget.title}',
                        onChanged: _cubit.setQuery,
                        onSubmitted: _cubit.setQuery,
                      ),
                    ),
                    const SizedBox(width: 10),
                    BlocBuilder<MediaGridCubit, MediaGridState>(
                      builder: (context, state) => _sortButton(
                        highlighted: state.sort != GridSort.original,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(child: MediaGridView(upcoming: widget.upcoming)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sortButton({required bool highlighted}) {
    return InkWell(
      onTap: _openSort,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: HomeHeader.darkColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: highlighted ? HomeHeader.greenColor : const Color(0xFF26322D),
          ),
        ),
        child: const Icon(Symbols.swap_vert, color: HomeHeader.greenColor),
      ),
    );
  }
}
