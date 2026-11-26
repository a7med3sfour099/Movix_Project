import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movixapp/core/data/media_repository.dart';
import 'history_state.dart';

class HistoryCubit extends Cubit<HistoryState> {
  final MediaRepository _repository;
  final String? _filter;

  HistoryCubit(this._repository, {this._filter}) : super(HistoryInitial());

  Future<void> fetchHistory() async {
    emit(HistoryLoading());

    final result = await _repository.getHistory(filter: _filter);

    result.when(
      success: (items) => emit(HistoryLoaded(items)),
      failure: (exception) => emit(HistoryError(exception)),
    );
  }

  void removeItem(int id) {
    if (state is HistoryLoaded) {
      final currentItems = (state as HistoryLoaded).items;
      final updatedItems = currentItems.where((item) => item.id != id).toList();
      emit(HistoryLoaded(updatedItems));
    }
  }
}
