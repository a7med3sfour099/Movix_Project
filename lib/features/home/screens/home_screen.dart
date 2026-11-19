import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../profile/cubit/profile_cubit.dart';
import '../cubit/home_tab_cubit.dart';
import '../widgets/home_header.dart';
import '../widgets/home_tabs.dart';
import '../widgets/search_bar_field.dart';
import '../widgets/hero_section.dart';
import '../widgets/explore_vaults.dart';
import '../widgets/section_container.dart';
import 'package:movixapp/core/bottom_bar.dart';
import 'package:movixapp/features/movies/screens/media_list_screen.dart';
import 'package:movixapp/features/movies/cubit/counts_cubit.dart';
import 'package:movixapp/features/movies/data/movies_api.dart';
import 'package:movixapp/features/settings/views/settings_view.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const List<String> hints = [
    'Search movies, TV shows, actors...',
    'Search movies...',
    'Search TV shows...',
    'Search actors...',
  ];

  void _openList(
    BuildContext context,
    String title,
    String path, {
    String type = 'movie',
  }) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MediaListScreen(title: title, path: path, type: type),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CountsCubit()..loadCounts(),
      child: Scaffold(
        backgroundColor: const Color(0xFF0B1512),
        bottomNavigationBar: const BottomBar(),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BlocBuilder<ProfileCubit, String>(
                  builder: (context, imagePath) {
                    return HomeHeader(
                      imagePath: imagePath,
                      onSettingsTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => SettingsView()),
                        );
                      },
                      onProfileTap: () {
                        BottomBar.open(context, 3);
                      },
                    );
                  },
                ),
                const SizedBox(height: 20),
                BlocBuilder<HomeTabCubit, int>(
                  builder: (context, selectedTab) {
                    final counts = context.watch<CountsCubit>().state;
                    var all = 'All';
                    var movies = 'Movies';
                    var tvShows = 'TV Shows';
                    var actors = 'Actors';
                    if (!counts.loading && counts.error == null) {
                      all = 'All (${counts.movies + counts.tvShows + counts.actors})';
                      movies = 'Movies (${counts.movies})';
                      tvShows = 'TV Shows (${counts.tvShows})';
                      actors = 'Actors (${counts.actors})';
                    }

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SearchBarField(
                          hint: hints[selectedTab],
                          onChanged: (text) {},
                          onSubmitted: (text) {},
                        ),
                        const SizedBox(height: 16),
                        HomeTabs(
                          tabs: [all, movies, tvShows, actors],
                          selectedIndex: selectedTab,
                          onTap: (index) {
                            context.read<HomeTabCubit>().selectTab(index);
                          },
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 20),
                const HeroSection(),
                const SizedBox(height: 24),
                const ExploreVaults(),
                const SizedBox(height: 24),
                SectionContainer(
                  title: 'Trending Today',
                  onSeeMore: () => _openList(context, 'Trending Today', '/trending/all/day'),
                  fetch: () => MoviesApi().getTrending('day'),
                ),
                const SizedBox(height: 24),
                SectionContainer(
                  title: 'Trending This Week',
                  onSeeMore: () => _openList(context, 'Trending This Week', '/trending/all/week'),
                  fetch: () => MoviesApi().getTrending('week'),
                ),
                const SizedBox(height: 24),
                SectionContainer(
                  title: 'Discover',
                  onSeeMore: () => _openList(context, 'Discover', '/discover/movie'),
                  fetch: () => MoviesApi().getList('/discover/movie', 'movie'),
                ),
                const SizedBox(height: 24),
                SectionContainer(
                  title: 'Top Movies',
                  onSeeMore: () => _openList(context, 'Top Movies', '/movie/top_rated'),
                  fetch: () => MoviesApi().getList('/movie/top_rated', 'movie'),
                ),
                const SizedBox(height: 24),
                SectionContainer(
                  title: 'Top TV Shows',
                  onSeeMore: () => _openList(context, 'Top TV Shows', '/tv/top_rated', type: 'tv'),
                  fetch: () => MoviesApi().getList('/tv/top_rated', 'tv'),
                ),
                const SizedBox(height: 24),
                SectionContainer(
                  title: 'Popular Movies',
                  onSeeMore: () => _openList(context, 'Popular Movies', '/movie/popular'),
                  fetch: () => MoviesApi().getList('/movie/popular', 'movie'),
                ),
                const SizedBox(height: 24),
                SectionContainer(
                  title: 'Popular TV Shows',
                  onSeeMore: () => _openList(context, 'Popular TV Shows', '/tv/popular', type: 'tv'),
                  fetch: () => MoviesApi().getList('/tv/popular', 'tv'),
                ),
                const SizedBox(height: 24),
                SectionContainer(
                  title: 'Now Playing',
                  onSeeMore: () => _openList(context, 'Now Playing', '/movie/now_playing'),
                  fetch: () => MoviesApi().getList('/movie/now_playing', 'movie'),
                ),
                const SizedBox(height: 24),
                SectionContainer(
                  title: 'Upcoming',
                  upcoming: true,
                  fetch: () => MoviesApi().getUpcoming(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}