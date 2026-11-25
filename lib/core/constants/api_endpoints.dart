class ApiEndpoints {
  ApiEndpoints._();

  // Trending
  static const String trendingAllDay = 'trending/all/day';
  static const String trendingAllWeek = 'trending/all/week';

  static const String trendingMoviesDay = 'trending/movie/day';
  static const String trendingMoviesWeek = 'trending/movie/week';

  static const String trendingTvDay = 'trending/tv/day';
  static const String trendingTvWeek = 'trending/tv/week';

  static const String trendingActorsDay = 'trending/person/day';
  static const String trendingActorsWeek = 'trending/person/week';

  // Movies
  static const String discoverMovies = 'discover/movie';
  static const String popularMovies = 'movie/popular';
  static const String topRatedMovies = 'movie/top_rated';
  static const String nowPlayingMovies = 'movie/now_playing';
  static const String upcomingMovies = 'movie/upcoming';

  // TV Shows
  static const String discoverTvShows = 'discover/tv';
  static const String popularTvShows = 'tv/popular';
  static const String topRatedTvShows = 'tv/top_rated';
  static const String airingTodayTvShows = 'tv/airing_today';
  static const String onTheAirTvShows = 'tv/on_the_air';

  // Actors
  static const String popularActors = 'person/popular';

  // Genres
  static const String movieGenres = 'genre/movie/list';
  static const String tvGenres = 'genre/tv/list';

  static String genreList(String type) => 'genre/$type/list';

  // Search
  static const String searchMulti = 'search/multi';
  static const String searchMovies = 'search/movie';
  static const String searchTvShows = 'search/tv';
  static const String searchActors = 'search/person';

  // Details
  static String movieDetails(int movieId) => 'movie/$movieId';
  static String tvDetails(int tvId) => 'tv/$tvId';
  static String actorDetails(int actorId) => 'person/$actorId';
}
