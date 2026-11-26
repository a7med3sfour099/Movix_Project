import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movixapp/features/home/data/media_item.dart';
import 'package:movixapp/features/profile/data/profile_database.dart';
import 'library_state.dart';

class LibraryCubit extends Cubit<LibraryState> {
  LibraryCubit() : super(const LibraryState()) {
    _authSubscription =
        FirebaseAuth.instance.authStateChanges().listen((user) async {
      if (user == null) {
        if (!isClosed) emit(const LibraryState());
        return;
      }
      await loadLibraryForUser(user.uid);
    });

    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      loadLibraryForUser(currentUser.uid);
    }
  }

  final ProfileDatabase _database = ProfileDatabase();
  late final StreamSubscription<User?> _authSubscription;

  void selectTab(int index) {
    if (state.selectedTab != index) {
      emit(state.copyWith(selectedTab: index));
    }
  }

  Future<void> loadLibraryForUser(String userId) async {
    try {
      final lib = await _database.getLibrary(userId);
      if (!isClosed && FirebaseAuth.instance.currentUser?.uid == userId) {
        emit(LibraryState(
          favorites: lib.favorites,
          watchlist: lib.watchlist,
          selectedTab: state.selectedTab,
        ));
      }
    } catch (_) {}
  }

  Future<void> _persist() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;
    try {
      await _database.saveLibrary(userId, state.favorites, state.watchlist);
    } catch (_) {}
  }

  void toggleFavorite(MediaItem item) {
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
    final favorites = List<MediaItem>.from(state.favorites);
    favorites.removeWhere((element) => element.id == item.id);
    emit(state.copyWith(favorites: favorites));
    _persist();
  }

  void toggleWatchlist(MediaItem item) {
    final watchlist = List<MediaItem>.from(state.watchlist);
    final index = watchlist.indexWhere((element) => element.id == item.id);
    if (index >= 0) {
      watchlist.removeAt(index);
    } else {
      watchlist.add(item);
    }
    emit(state.copyWith(watchlist: watchlist));
    _persist();
  }

  void removeFromWatchlist(MediaItem item) {
    final watchlist = List<MediaItem>.from(state.watchlist);
    watchlist.removeWhere((element) => element.id == item.id);
    emit(state.copyWith(watchlist: watchlist));
    _persist();
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
