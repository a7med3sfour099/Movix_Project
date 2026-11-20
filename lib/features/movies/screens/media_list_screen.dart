import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movixapp/core/bottom_bar.dart';
import 'package:movixapp/Widgets/custom_back_button.dart';
import 'package:movixapp/features/movies/cubit/media_grid_cubit.dart';
import 'package:movixapp/features/movies/data/movies_api.dart';
import 'package:movixapp/features/movies/widgets/media_grid_view.dart';
import 'package:movixapp/Widgets/custom_back_button.dart';

/// Used for: Popular Movies, Popular TV Shows, Top Movies, Top TV Shows,
/// Trending, Discover, Now Playing ("See More" from the home sections).
class MediaListScreen extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        final api = MoviesApi();
        return MediaGridCubit(
          (page) => api.getPage(
            path,
            type,
            page: page,
            params: upcoming ? MoviesApi.upcomingParams() : params,
          ),
        )..load();
      },
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
              ),
              Expanded(child: MediaGridView(upcoming: upcoming)),
            ],
          ),
        ),
      ),
    );
  }
}
