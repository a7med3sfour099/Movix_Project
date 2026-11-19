import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movixapp/core/bottom_bar.dart';
import 'package:movixapp/features/home/widgets/search_bar_field.dart';
import 'package:movixapp/features/movies/cubit/media_grid_cubit.dart';
import 'package:movixapp/features/movies/data/movies_api.dart';
import 'package:movixapp/features/movies/widgets/media_grid_view.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _api = MoviesApi();
  late final MediaGridCubit _cubit;
  String _query = '';

  @override
  void initState() {
    super.initState();
    _cubit = MediaGridCubit(
      (page) => _api.getPage(
        '/search/multi',
        'movie',
        page: page,
        params: {'query': _query},
      ),
    );
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  void _submit(String text) {
    final query = text.trim();
    setState(() => _query = query);
    if (query.isNotEmpty) _cubit.load();
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
                padding: const EdgeInsets.all(16),
                child: SearchBarField(
                  hint: 'Search movies, TV shows...',
                  onChanged: (_) {},
                  onSubmitted: _submit,
                ),
              ),
              Expanded(
                child: _query.isEmpty
                    ? const Center(
                        child: Text(
                          'Search for a movie or TV show',
                          style: TextStyle(color: Color(0xFF7C8B85)),
                        ),
                      )
                    : const MediaGridView(emptyMessage: 'No results found'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
