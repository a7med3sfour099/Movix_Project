import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movixapp/features/home/cubit/catalog_filter_state.dart';

class CatalogFilterCubit extends Cubit<CatalogFilterState> {
  CatalogFilterCubit() : super(const CatalogFilterState());

  void selectGenre(int? id) {
    emit(state.copyWith(genreId: id, clearGenre: id == null));
  }

  void selectSort(CatalogSort sort) {
    emit(state.copyWith(sort: sort));
  }
}