enum CatalogSort { popular, topRated, newest }

class CatalogFilterState {
  /// The genres picked in the sheet (empty = all genres).
  final Set<int> genreIds;
  final CatalogSort sort;

  // true when the Arabic button is pressed
  final bool arabicOnly;

  const CatalogFilterState({
    this.genreIds = const {},
    this.sort = CatalogSort.popular,
    this.arabicOnly = false,
  });

  CatalogFilterState copyWith({
    Set<int>? genreIds,
    CatalogSort? sort,
    bool? arabicOnly,
  }) =>
      CatalogFilterState(
        genreIds: genreIds ?? this.genreIds,
        sort: sort ?? this.sort,
        arabicOnly: arabicOnly ?? this.arabicOnly,
      );

  Map<String, dynamic> toParams({required bool isMovie}) {
    final today = DateTime.now().toIso8601String().substring(0, 10);
    final dateField = isMovie ? 'primary_release_date' : 'first_air_date';
    final sortBy = switch (sort) {
      CatalogSort.popular => 'popularity.desc',
      CatalogSort.topRated => 'vote_average.desc',
      CatalogSort.newest => '$dateField.desc',
    };
    return {
      // "|" means OR: titles from any of the picked genres.
      if (genreIds.isNotEmpty) 'with_genres': genreIds.join('|'),
      // if Arabic is on, ask TMDB only for titles whose original language is Arabic
      if (arabicOnly) 'with_original_language': 'ar',
      'sort_by': sortBy,
      if (sort == CatalogSort.topRated) 'vote_count.gte': 300,
      if (sort == CatalogSort.newest) '$dateField.lte': today,
      if (sort == CatalogSort.newest) 'vote_count.gte': 10,
    };
  }
}
