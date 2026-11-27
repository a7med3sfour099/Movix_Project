import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movixapp/features/home/cubit/catalog_filter_state.dart';

class CatalogFilterCubit extends Cubit<CatalogFilterState> {
  CatalogFilterCubit() : super(const CatalogFilterState());

  /// Called when the user taps Apply in the genres sheet.
  void applyGenres(Set<int> ids) {
    emit(state.copyWith(genreIds: Set.of(ids)));
  }

  void selectSort(CatalogSort sort) {
    emit(state.copyWith(sort: sort));
  }

  // Arabic button: press once to show only Arabic, press again to show everything
  void toggleArabic() {
    emit(state.copyWith(arabicOnly: !state.arabicOnly));
  }
}
