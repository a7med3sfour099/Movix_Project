import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movixapp/features/actors/data/actor.dart';
import 'package:movixapp/features/actors/data/actors_api.dart';

typedef ActorsFetcher = Future<ActorsPage> Function(int page);

class ActorsState {
  final bool loading;
  final bool loadingMore;
  final bool hasMore;
  final String? error;
  final List<Actor> items;

  const ActorsState({
    this.loading = false,
    this.loadingMore = false,
    this.hasMore = false,
    this.error,
    this.items = const [],
  });
}

// Reloads from page 1 when filters change
class ActorsCubit extends Cubit<ActorsState> {
  final ActorsFetcher fetch;
  int _nextPage = 1;
  int _requestId = 0;

  ActorsCubit(this.fetch) : super(const ActorsState(loading: true));

  Future<void> load() async {
    final id = ++_requestId;
    emit(const ActorsState(loading: true));
    try {
      final result = await fetch(1);
      if (id != _requestId || isClosed) return;
      _nextPage = result.nextPage;
      emit(ActorsState(items: _merge(const [], result.items), hasMore: result.hasMore));
    } catch (e) {
      if (id != _requestId || isClosed) return;
      emit(const ActorsState(error: 'Something went wrong, try again'));
    }
  }

  Future<void> loadMore() async {
    final current = state;
    if (current.loading || current.loadingMore || !current.hasMore) return;
    final id = _requestId;
    emit(ActorsState(items: current.items, hasMore: true, loadingMore: true));
    try {
      final result = await fetch(_nextPage);
      if (id != _requestId || isClosed) return;
      _nextPage = result.nextPage;
      emit(ActorsState(
        items: _merge(current.items, result.items),
        hasMore: result.hasMore,
      ));
    } catch (e) {
      if (id != _requestId || isClosed) return;
      emit(ActorsState(items: current.items));
    }
  }

  List<Actor> _merge(List<Actor> old, List<Actor> added) {
    final seen = old.map((e) => e.id).toSet();
    return [...old, ...added.where((e) => seen.add(e.id))];
  }
}
