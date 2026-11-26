enum CatalogSort { popular, topRated, newest }

class CatalogFilterState {
  /// The genres picked in the sheet (empty = all genres).
  final Set<int> genreIds;
  final CatalogSort sort;

  const CatalogFilterState({
    this.genreIds = const {},
    this.sort = CatalogSort.popular,
  });

  CatalogFilterState copyWith({
    Set<int>? genreIds,
    CatalogSort? sort,
  }) =>
      CatalogFilterState(
        genreIds: genreIds ?? this.genreIds,
        sort: sort ?? this.sort,
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
      'sort_by': sortBy,
      if (sort == CatalogSort.topRated) 'vote_count.gte': 300,
      if (sort == CatalogSort.newest) '$dateField.lte': today,
      if (sort == CatalogSort.newest) 'vote_count.gte': 10,
    };
  }
}
