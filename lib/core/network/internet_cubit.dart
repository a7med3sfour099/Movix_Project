import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

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

class InternetCubit extends Cubit<InternetState> with WidgetsBindingObserver {
  InternetCubit() : super(const InternetState()) {
    WidgetsBinding.instance.addObserver(this);
    _checkInitialConnection();

    _subscription = InternetConnection().onStatusChange.listen((status) {
      if (status == InternetStatus.disconnected) {
        _scheduleOfflineCheck();
      } else if (status == InternetStatus.connected) {
        _offlineTimer?.cancel();
        _checkId++;

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
  @override
  void didChangeAppLifecycleState(AppLifecycleState lifecycleState) {
    if (lifecycleState == AppLifecycleState.paused ||
        lifecycleState == AppLifecycleState.inactive ||
        lifecycleState == AppLifecycleState.hidden) {
      _offlineTimer?.cancel();
      _checkId++;
    } else if (lifecycleState == AppLifecycleState.resumed) {
      _scheduleOfflineCheck();
    }
  }

  late final StreamSubscription<InternetStatus> _subscription;
  Timer? _offlineTimer;
  int _checkId = 0;

  void dismissOfflineScreen() {
    emit(state.copyWith(showOfflineScreen: false));
  }

  void _scheduleOfflineCheck() {
    _offlineTimer?.cancel();

    final currentCheck = ++_checkId;

    _offlineTimer = Timer(const Duration(seconds: 5), () async {
      try {
        var connected = await InternetConnection().hasInternetAccess;

        if (isClosed || currentCheck != _checkId) return;

        // Confirm the connection status one more time.
        if (!connected) {
          await Future.delayed(const Duration(seconds: 3));

          if (isClosed || currentCheck != _checkId) return;

          connected = await InternetConnection().hasInternetAccess;
        }

        if (isClosed || currentCheck != _checkId) return;

        emit(
          state.copyWith(
            isConnected: connected,
            isLoading: false,
            showOfflineScreen: !connected,
            clearError: connected,
          ),
        );
      } catch (_) {
        if (isClosed || currentCheck != _checkId) return;

        emit(
          state.copyWith(
            isConnected: false,
            isLoading: false,
            showOfflineScreen: true,
          ),
        );
      }
    });
  }

  Future<void> _checkInitialConnection() async {
    final checkId = _checkId;

    final connected = await InternetConnection().hasInternetAccess;

    if (isClosed || checkId != _checkId) return;

    if (connected) {
      emit(state.copyWith(isConnected: true, showOfflineScreen: false));
    } else {
      _scheduleOfflineCheck();
    }
  }

  Future<void> checkConnection() async {
    emit(state.copyWith(isLoading: true, clearError: true));

    try {
      await Future.delayed(const Duration(seconds: 5));

      if (isClosed) return;

      final connected = await InternetConnection().hasInternetAccess;

      if (isClosed) return;

      if (connected) {
        _offlineTimer?.cancel();
        _checkId++;

        emit(const InternetState(isConnected: true, showOfflineScreen: false));
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
    WidgetsBinding.instance.removeObserver(this);
    _offlineTimer?.cancel();
    _subscription.cancel();
    return super.close();
  }
}
