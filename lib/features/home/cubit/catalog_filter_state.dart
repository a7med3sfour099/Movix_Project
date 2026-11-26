enum CatalogSort { popular, topRated, newest }

class CatalogFilterState {
  final int? genreId;
  final CatalogSort sort;

  const CatalogFilterState({
    this.genreId,
    this.sort = CatalogSort.popular,
  });

  CatalogFilterState copyWith({
    int? genreId,
    bool clearGenre = false,
    CatalogSort? sort,
  }) =>
      CatalogFilterState(
        genreId: clearGenre ? null : (genreId ?? this.genreId),
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
      if (genreId != null) 'with_genres': genreId,
      'sort_by': sortBy,
      if (sort == CatalogSort.topRated) 'vote_count.gte': 300,
      if (sort == CatalogSort.newest) '$dateField.lte': today,
      if (sort == CatalogSort.newest) 'vote_count.gte': 10,
    };
  }
}
