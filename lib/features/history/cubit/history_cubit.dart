import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movixapp/features/history/data/watched_database.dart';
import 'history_state.dart';

class HistoryCubit extends Cubit<HistoryState> {
  final WatchedDatabase _database = WatchedDatabase();
  final String? _filter;

  HistoryCubit({this._filter}) : super(HistoryInitial());

  Future<void> fetchHistory() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      emit(HistoryLoaded(const []));
      return;
    }

    emit(HistoryLoading());
    final all = await _database.getWatched(userId);
    final items = _filter == null
        ? all
        : all.where((item) => item.type == _filter).toList();
    emit(HistoryLoaded(items));
  }

  Future<void> removeItem(int id) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    final current = state;
    if (userId == null || current is! HistoryLoaded) return;

    final item = current.items.firstWhere((item) => item.id == id);
    await _database.removeWatched(userId, item.id, item.type);
    emit(HistoryLoaded(current.items.where((item) => item.id != id).toList()));
  }
}