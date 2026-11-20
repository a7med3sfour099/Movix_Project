import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movixapp/features/search/data/search_history_database.dart';
import 'package:movixapp/features/search/data/search_result.dart';

class HistoryState {
  final List<String> searches;
  final List<SearchResult> viewed;

  const HistoryState({this.searches = const [], this.viewed = const []});
}

class HistoryCubit extends Cubit<HistoryState> {
  final SearchHistoryDatabase _db = SearchHistoryDatabase();

  HistoryCubit() : super(const HistoryState()) {
    load();
  }

  Future<void> load() async {
    final searches = await _db.getSearches();
    final viewed = await _db.getViewed();
    if (isClosed) return;
    emit(HistoryState(searches: searches, viewed: viewed));
  }

  Future<void> addSearch(String text) async {
    final clean = text.trim();
    if (clean.isEmpty) return;
    await _db.addSearch(clean);
    await load();
  }

  Future<void> addViewed(SearchResult result) async {
    await _db.addViewed(result);
    await load();
  }

  Future<void> clearSearches() async {
    await _db.clearSearches();
    await load();
  }

  Future<void> clearViewed() async {
    await _db.clearViewed();
    await load();
  }
}