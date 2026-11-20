import 'package:movixapp/features/movies/data/movies_api.dart';
import 'package:movixapp/features/search/data/search_result.dart';

enum SearchType { all, movies, tv }

enum SearchSort { popularity, rating, releaseDate, title }

extension SearchSortText on SearchSort {
  String get label => switch (this) {
    SearchSort.popularity => 'Popularity',
    SearchSort.rating => 'Rating',
    SearchSort.releaseDate => 'Release Date',
    SearchSort.title => 'Title',
  };

  /// The little hint shown next to each option in the sort sheet.
  String hint(bool ascending) => switch (this) {
    SearchSort.popularity => ascending ? 'Least popular first' : 'Most popular first',
    SearchSort.rating => ascending ? '0 → 10' : '10 → 0',
    SearchSort.releaseDate => ascending ? 'Oldest first' : 'Newest first',
    SearchSort.title => ascending ? 'A → Z' : 'Z → A',
  };
}

/// Decade chips: null = all time, 1980 = "older than 1990".
const searchDecades = <int?>[null, 2020, 2010, 2000, 1990, 1980];

String decadeLabel(int? decade) => switch (decade) {
  null => 'All Time',
  1980 => 'Older',
  _ => '${decade}s',
};

/// Turns a year into its decade (1980 = older than 1990).
int decadeOf(int year) {
  if (year >= 2020) return 2020;
  if (year >= 2010) return 2010;
  if (year >= 2000) return 2000;
  if (year >= 1990) return 1990;
  return 1980;
}

class SearchFilters {
  final SearchType type;

  /// Genre names (they come from the API), so movie and TV genres can be mixed.
  final Set<String> genres;
  final double minRating;
  final int? decade;

  const SearchFilters({
    this.type = SearchType.all,
    this.genres = const {},
    this.minRating = 0,
    this.decade,
  });

  SearchFilters copyWith({
    SearchType? type,
    Set<String>? genres,
    double? minRating,
    int? decade,
    bool clearDecade = false,
  }) {
    return SearchFilters(
      type: type ?? this.type,
      genres: genres ?? this.genres,
      minRating: minRating ?? this.minRating,
      decade: clearDecade ? null : (decade ?? this.decade),
    );
  }

  int get activeCount =>
      (type != SearchType.all ? 1 : 0) +
          (genres.isNotEmpty ? 1 : 0) +
          (minRating > 0 ? 1 : 0) +
          (decade != null ? 1 : 0);

  bool matches(SearchResult r) {
    // People have no genre, rating or release date.
    if (r.isPerson) {
      return genres.isEmpty && minRating == 0 && decade == null;
    }

    if (genres.isNotEmpty) {
      final names = r.genreIds.map((id) => MoviesApi.genres[id]);
      if (!names.any(genres.contains)) return false;
    }

    if (minRating > 0 && r.rating < minRating) return false;

    if (decade != null) {
      final year = r.year;
      if (year == null || decadeOf(year) != decade) return false;
    }
    return true;
  }
}