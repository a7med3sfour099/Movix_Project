import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:flutter/foundation.dart';

class InternetState {
  final bool isConnected;
  final bool isLoading;
  final bool showOfflineScreen;
  final String? errorMessage;

  const InternetState({
    this.isConnected = true,
    this.isLoading = false,
    this.showOfflineScreen = false,
    this.errorMessage,
  });

  InternetState copyWith({
    bool? isConnected,
    bool? isLoading,
    bool? showOfflineScreen,
    String? errorMessage,
    bool clearError = false,
  }) {
    return InternetState(
      isConnected: isConnected ?? this.isConnected,
      isLoading: isLoading ?? this.isLoading,
      showOfflineScreen: showOfflineScreen ?? this.showOfflineScreen,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }
}

class InternetCubit extends Cubit<InternetState> {
  InternetCubit() : super(const InternetState()) {
    _checkInitialConnection();

    _subscription = InternetConnection().onStatusChange.listen((status) {
      if (status == InternetStatus.disconnected) {
        emit(
          state.copyWith(
            isConnected: false,
            isLoading: false,
            showOfflineScreen: true,
          ),
        );
      } else if (status == InternetStatus.connected) {
        emit(
          state.copyWith(
            isConnected: true,
            isLoading: false,
            showOfflineScreen: false,
            clearError: true,
          ),
        );
      }
    });
  }

  late final StreamSubscription<InternetStatus> _subscription;

  void dismissOfflineScreen() {
    emit(state.copyWith(showOfflineScreen: false));
  }

  Future<void> _checkInitialConnection() async {
    await Future.delayed(const Duration(seconds: 3));

    final connected = await InternetConnection().hasInternetAccess;

    debugPrint('Initial Internet Check: $connected');

    if (!isClosed) {
      emit(
        state.copyWith(isConnected: connected, showOfflineScreen: !connected),
      );
    }
  }

  Future<void> checkConnection() async {
    emit(state.copyWith(isLoading: true, clearError: true));

    try {
      final connected = await InternetConnection().hasInternetAccess;
      await Future.delayed(const Duration(seconds: 3));

      if (isClosed) return;

      if (connected) {
        emit(const InternetState(isConnected: true));
      } else {
        emit(
          const InternetState(
            isConnected: false,
            showOfflineScreen: true,
            errorMessage: 'No internet connection. Please try again.',
          ),
        );
      }
    } catch (_) {
      if (!isClosed) {
        emit(
          const InternetState(
            isConnected: false,
            showOfflineScreen: true,
            errorMessage: 'Something went wrong. Please try again.',
          ),
        );
      }
    }
  }

  @override
  Future<void> close() {
    _subscription.cancel();
    return super.close();
  }
}
