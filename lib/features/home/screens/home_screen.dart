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
import 'package:movixapp/features/search/data/search_filters.dart';
import 'package:movixapp/features/actors/data/actors_api.dart';
import 'package:movixapp/features/actors/screens/actors_catalog_screen.dart';
import 'package:movixapp/features/actors/widgets/actor_section.dart';
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
        bool upcoming = false,
      }) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MediaListScreen(
          title: title,
          path: path,
          type: type,
          upcoming: upcoming,
        ),
      ),
    );
  }

  static const _allSections = [
    _SectionDef('Trending Today', '/trending/all/day', 'movie'),
    _SectionDef('Trending This Week', '/trending/all/week', 'movie'),
    _SectionDef('Discover', '/discover/movie', 'movie'),
    _SectionDef('Top Movies', '/movie/top_rated', 'movie'),
    _SectionDef('Top TV Shows', '/tv/top_rated', 'tv'),
    _SectionDef('Popular Movies', '/movie/popular', 'movie'),
    _SectionDef('Popular TV Shows', '/tv/popular', 'tv'),
    _SectionDef('Now Playing', '/movie/now_playing', 'movie'),
    _SectionDef('Upcoming', '/discover/movie', 'movie', upcoming: true),
  ];

  static const _movieSections = [
    _SectionDef('Trending Today', '/trending/movie/day', 'movie'),
    _SectionDef('Trending This Week', '/trending/movie/week', 'movie'),
    _SectionDef('Discover', '/discover/movie', 'movie'),
    _SectionDef('Top Movies', '/movie/top_rated', 'movie'),
    _SectionDef('Popular Movies', '/movie/popular', 'movie'),
    _SectionDef('Now Playing', '/movie/now_playing', 'movie'),
    _SectionDef('Upcoming', '/discover/movie', 'movie', upcoming: true),
  ];

  static const _tvSections = [
    _SectionDef('Trending Today', '/trending/tv/day', 'tv'),
    _SectionDef('Trending This Week', '/trending/tv/week', 'tv'),
    _SectionDef('Top TV Shows', '/tv/top_rated', 'tv'),
    _SectionDef('Popular TV Shows', '/tv/popular', 'tv'),
    _SectionDef('On The Air', '/tv/on_the_air', 'tv'),
    _SectionDef('Airing Today', '/tv/airing_today', 'tv'),
  ];
  static const _actorSections = [
    _SectionDef('Popular Actors', ActorsApi.popularPath, 'person'),
    _SectionDef('Trending Today', ActorsApi.trendingDayPath, 'person'),
    _SectionDef('Trending This Week', ActorsApi.trendingWeekPath, 'person'),
  ];

  void _openActors(BuildContext context, String title, String path) {
    final sort = ActorSort.values.firstWhere((s) => s.path == path);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ActorsCatalogScreen(title: title, initialSort: sort),
      ),
    );
  }
  /// Everything under the tabs. Tabs: 0 All, 1 Movies, 2 TV Shows, 3 Actors.
  Widget _content(BuildContext context, int tab) {
    if (tab == 3) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final s in _actorSections) ...[
            ActorSection(
              key: ValueKey('actors-${s.title}'),
              title: s.title,
              path: s.path,
              onSeeMore: () => _openActors(context, s.title, s.path),
            ),
            const SizedBox(height: 24),
          ],
        ],
      );
    }

    final sections = switch (tab) {
      1 => _movieSections,
      2 => _tvSections,
      _ => _allSections,
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (tab == 0) ...[
          const HeroSection(),
          const SizedBox(height: 24),
        ],
        if (tab == 0) ...[
          const ExploreVaults(),
          const SizedBox(height: 24),
        ],
        for (final s in sections) ...[
          SectionContainer(
            // Key per tab so each tab loads its own data.
            key: ValueKey('$tab-${s.title}'),
            title: s.title,
            upcoming: s.upcoming,
            fetch: s.upcoming
                ? () => MoviesApi().getUpcoming()
                : () => MoviesApi().getList(s.path, s.type),
            onSeeMore: () => _openList(
              context,
              s.title,
              s.path,
              type: s.type,
              upcoming: s.upcoming,
            ),
          ),
          const SizedBox(height: 24),
        ],
      ],
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
                          // Looks like a field, but a tap opens the Search page
                          // (blurred Home behind it, keyboard already open).
                          readOnly: true,
                          onChanged: (_) {},
                          onSubmitted: (_) {},
                          onTap: () => BottomBar.open(
                            context,
                            1,
                            // Actors tab searches everything until the
                            // "people" type is added to SearchType.
                            searchType: switch (selectedTab) {
                              1 => SearchType.movies,
                              2 => SearchType.tv,
                              _ => SearchType.all,
                            },
                          ),
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
                BlocBuilder<HomeTabCubit, int>(
                  builder: (context, selectedTab) =>
                      _content(context, selectedTab),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SectionDef {
  final String title;
  final String path;
  final String type;
  final bool upcoming;

  const _SectionDef(this.title, this.path, this.type, {this.upcoming = false});
}