import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movixapp/features/history/data/watched_database.dart';
import 'package:movixapp/features/home/data/media_item.dart';
import 'package:movixapp/features/profile/data/profile_database.dart';
import 'library_state.dart';

class LibraryCubit extends Cubit<LibraryState> {
  LibraryCubit() : super(const LibraryState()) {
    _authSubscription = FirebaseAuth.instance.authStateChanges().listen((
      user,
    ) async {
      if (isClosed) return;

      // Clear previous user's data immediately.
      emit(LibraryState(selectedTab: state.selectedTab));

      // Guest and signed-out users start with an empty library.
      if (user == null || user.isAnonymous) return;

      await loadLibraryForUser(user.uid);
    });
  }

  final ProfileDatabase _database = ProfileDatabase();
  final WatchedDatabase _watchedDatabase = WatchedDatabase();
  late final StreamSubscription<User?> _authSubscription;

  void selectTab(int index) {
    if (state.selectedTab != index) {
      emit(state.copyWith(selectedTab: index));
    }
  }

  Future<void> loadLibraryForUser(String userId) async {
    try {
      final lib = await _database.getLibrary(userId);

      // History lives in its own table (watched). If it fails to load,
      // favorites and watchlist must still show up.
      var watched = <MediaItem>[];
      try {
        watched = await _watchedDatabase.getWatched(userId);
      } catch (_) {}

      if (!isClosed && FirebaseAuth.instance.currentUser?.uid == userId) {
        emit(
          LibraryState(
            favorites: lib.favorites,
            watchlist: lib.watchlist,
            history: watched,
            selectedTab: state.selectedTab,
          ),
        );
      }
    } catch (_) {}
  }

  /// Saves favorites + watchlist (history is saved item by item).
  Future<void> _persist() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;
    try {
      await _database.saveLibrary(userId, state.favorites, state.watchlist);
    } catch (_) {}
  }

  Future<void> _saveWatched(MediaItem item) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;
    try {
      await _watchedDatabase.addWatched(userId, item);
    } catch (_) {}
  }

  Future<void> _deleteWatched(MediaItem item) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;
    try {
      await _watchedDatabase.removeWatched(userId, item.id, item.type);
    } catch (_) {}
  }

  // TMDB uses the same id for a movie and a TV show sometimes,
  // so history always compares id + type.
  bool _same(MediaItem item, int id, String type) =>
      item.id == id && item.type == type;
  void toggleFavorite(MediaItem item) {
    if (FirebaseAuth.instance.currentUser?.isAnonymous ?? true) return;

    final favorites = List<MediaItem>.from(state.favorites);
    final index = favorites.indexWhere((element) => element.id == item.id);

    if (index >= 0) {
      favorites.removeAt(index);
    } else {
      favorites.add(item);
    }

    emit(state.copyWith(favorites: favorites));
    _persist();
  }

  void removeFromFavorites(MediaItem item) {
    if (FirebaseAuth.instance.currentUser?.isAnonymous ?? true) return;

    final favorites = List<MediaItem>.from(state.favorites);
    favorites.removeWhere((element) => element.id == item.id);

    emit(state.copyWith(favorites: favorites));
    _persist();
  }

  /// Adds / removes from the watchlist.
  /// Returns false (and changes nothing) when the item is already watched,
  /// because a watched title can never be in the watchlist.
  bool toggleWatchlist(MediaItem item) {
    if (FirebaseAuth.instance.currentUser?.isAnonymous ?? true) return false;

    if (isWatched(item.id, item.type) && !isInWatchlist(item.id)) {
      return false;
    }

    final watchlist = List<MediaItem>.from(state.watchlist);
    final index = watchlist.indexWhere((element) => element.id == item.id);

    if (index >= 0) {
      watchlist.removeAt(index);
    } else {
      watchlist.add(item);
    }

    emit(state.copyWith(watchlist: watchlist));
    _persist();
    return true;
  }

  void removeFromWatchlist(MediaItem item) {
    if (FirebaseAuth.instance.currentUser?.isAnonymous ?? true) return;

    final watchlist = List<MediaItem>.from(state.watchlist);
    watchlist.removeWhere((element) => element.id == item.id);
    emit(state.copyWith(watchlist: watchlist));
    _persist();
  }

  /// Marks a title as watched: it goes to History (newest first)
  /// and automatically leaves the Watchlist.
  void markWatched(MediaItem item) {
    if (FirebaseAuth.instance.currentUser?.isAnonymous ?? true) return;
    if (isWatched(item.id, item.type)) return;

    final history = [item, ...state.history];
    final watchlist = state.watchlist
        .where((element) => !_same(element, item.id, item.type))
        .toList();
    final watchlistChanged = watchlist.length != state.watchlist.length;

    emit(state.copyWith(history: history, watchlist: watchlist));
    unawaited(_saveWatched(item));
    if (watchlistChanged) _persist();
  }

  void removeFromHistory(MediaItem item) {
    if (FirebaseAuth.instance.currentUser?.isAnonymous ?? true) return;

    final history = state.history
        .where((element) => !_same(element, item.id, item.type))
        .toList();

    emit(state.copyWith(history: history));
    unawaited(_deleteWatched(item));
  }

  /// Favorite -> Watchlist. The title STAYS in Favorites (it is copied, not
  /// moved). Returns false if it is already watched, because a watched title
  /// can never be in the Watchlist.
  bool addFavoriteToWatchlist(MediaItem item) {
    if (FirebaseAuth.instance.currentUser?.isAnonymous ?? true) {
      return false;
    }

    if (isWatched(item.id, item.type)) return false;
    if (isInWatchlist(item.id)) return true;

    final watchlist = List<MediaItem>.from(state.watchlist)..add(item);

    emit(state.copyWith(watchlist: watchlist));
    _persist();
    return true;
  }

  /// Adds to favorites only (never removes). Used by the History card.
  void addToFavorites(MediaItem item) {
    if (FirebaseAuth.instance.currentUser?.isAnonymous ?? true) return;

    if (isFavorite(item.id)) return;

    final favorites = List<MediaItem>.from(state.favorites)..add(item);

    emit(state.copyWith(favorites: favorites));
    _persist();
  }

  bool isWatched(int id, String type) {
    return state.history.any((item) => _same(item, id, type));
  }

  bool isFavorite(int id) {
    return state.favorites.any((item) => item.id == id);
  }

  bool isInWatchlist(int id) {
    return state.watchlist.any((item) => item.id == id);
  }

  @override
  Future<void> close() {
    _authSubscription.cancel();
    return super.close();
  }
}
