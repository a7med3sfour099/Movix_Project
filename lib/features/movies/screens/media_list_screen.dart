import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:movixapp/core/bottom_bar.dart';
import 'package:movixapp/features/home/widgets/home_header.dart';
import 'package:movixapp/features/movies/cubit/media_grid_cubit.dart';
import 'package:movixapp/features/movies/data/movies_api.dart';
import 'package:movixapp/features/movies/widgets/media_grid_view.dart';

/// Used for: Popular Movies, Popular TV Shows, Top Movies, Top TV Shows,
/// Trending, Discover, Now Playing ("See More" from the home sections).
class MediaListScreen extends StatelessWidget {
  final String title;
  final String path;
  final String type;
  final Map<String, dynamic>? params;

  const MediaListScreen({
    super.key,
    required this.title,
    required this.path,
    this.type = 'movie',
    this.params,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        final api = MoviesApi();
        return MediaGridCubit(
          (page) => api.getPage(path, type, page: page, params: params),
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
                    InkWell(
                      onTap: () => Navigator.maybePop(context),
                      customBorder: const CircleBorder(),
                      child: Container(
                        width: 36,
                        height: 36,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: HomeHeader.darkColor,
                        ),
                        child: const Icon(
                          Symbols.arrow_back,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
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
              const Expanded(child: MediaGridView()),
            ],
          ),
        ),
      ),
    );
  }
}
