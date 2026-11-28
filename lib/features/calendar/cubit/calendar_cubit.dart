
import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movixapp/core/services/notification_service.dart';
import 'package:movixapp/features/calendar/data/reminder_item.dart';
import 'package:movixapp/features/profile/data/profile_database.dart';

import 'calendar_state.dart';

class CalendarCubit extends Cubit<CalendarState> {
  CalendarCubit()
      : super(
          CalendarState(
            selectedDate: DateTime.now(),
            currentMonth: DateTime(
              DateTime.now().year,
              DateTime.now().month,
              1,
            ),
            reminders: const [],
          ),
        ) {
    _authSubscription =
        FirebaseAuth.instance.authStateChanges().listen((user) {
      unawaited(_handleAuthChange(user));
    });
  }

  final ProfileDatabase _database = ProfileDatabase();
  final NotificationService _notifications = NotificationService.instance;

  late final StreamSubscription<User?> _authSubscription;

  Future<void> _mutationQueue = Future.value();

  int _authGeneration = 0;
  String? _loadedUserId;

  Future<void> _handleAuthChange(User? user) async {
    final generation = ++_authGeneration;
    _loadedUserId = null;

    if (user == null) {
      emit(state.copyWith(reminders: const []));

      try {
        await _notifications.cancelAllNotifications();
      } catch (_) {}

      return;
    }

    try {
      await _notifications.cancelAllNotifications();

      if (!_isCurrentUser(user.uid, generation)) return;

      final reminders = await _database.getReminders(user.uid);

      if (!_isCurrentUser(user.uid, generation)) return;

      reminders.sort((a, b) => a.date.compareTo(b.date));

      _loadedUserId = user.uid;
      emit(state.copyWith(reminders: reminders));

      for (final reminder in reminders) {
        if (!_isCurrentUser(user.uid, generation)) return;

        if (reminder.isEnabled) {
          await _scheduleReminder(reminder);
        }
      }
    } catch (_) {
      if (_isCurrentUser(user.uid, generation)) {
        _setError('Failed to load reminders. Please try again.');
      }
    }
  }

  bool _isCurrentUser(String userId, int generation) {
    return !isClosed &&
        generation == _authGeneration &&
        FirebaseAuth.instance.currentUser?.uid == userId;
  }

  Future<void> _persistAndSync(
    String userId,
    List<ReminderItem> reminders, {
    ReminderItem? changedReminder,
    String? removedReminderId,
    bool requestPermission = false,
  }) async {
    reminders.sort((a, b) => a.date.compareTo(b.date));

    await _database.saveReminders(userId, reminders);

    if (isClosed ||
        FirebaseAuth.instance.currentUser?.uid != userId ||
        _loadedUserId != userId) {
      return;
    }

    emit(state.copyWith(reminders: reminders));

    try {
      if (removedReminderId != null) {
        await _notifications.cancelNotification(removedReminderId);
      } else if (changedReminder != null) {
        if (!changedReminder.isEnabled) {
          await _notifications.cancelNotification(changedReminder.id);
        } else {
          if (requestPermission) {
            await _notifications.requestNotificationPermission();
          }

          await _scheduleReminder(changedReminder);
        }
      }
    } catch (_) {
      _setError(
        'Reminder saved, but its notification could not be updated.',
      );
    }
  }

  Future<void> _scheduleReminder(ReminderItem reminder) {
    return _notifications.scheduleReminder(
      id: reminder.id,
      title: reminder.title,
      body: reminder.subtitle,
      date: reminder.date,
      repeat: reminder.repeat,
    );
  }

  Future<bool> _enqueue(
    Future<void> Function(String userId) action,
  ) {
    final userId = FirebaseAuth.instance.currentUser?.uid;

    if (userId == null) {
      _setError('Please sign in to manage reminders.');
      return Future.value(false);
    }

    final result = _mutationQueue.then((_) async {
      try {
        if (isClosed ||
            FirebaseAuth.instance.currentUser?.uid != userId ||
            _loadedUserId != userId) {
          throw StateError('User changed or reminders are still loading.');
        }

        await action(userId);
        return true;
      } catch (_) {
        _setError('Failed to save reminder. Please try again.');
        return false;
      }
    });

    _mutationQueue = result.then<void>((_) {});
    return result;
  }

  void _setError(String message) {
    if (!isClosed) {
      emit(state.copyWith(error: message));
    }
  }

  void clearError() {
    emit(state.copyWith(clearError: true));
  }

  void selectDate(DateTime date) {
    emit(state.copyWith(selectedDate: date));
  }

  void nextMonth() {
    final next =
        DateTime(state.currentMonth.year, state.currentMonth.month + 1, 1);
    emit(state.copyWith(currentMonth: next));
  }

  void previousMonth() {
    final previous =
        DateTime(state.currentMonth.year, state.currentMonth.month - 1, 1);
    emit(state.copyWith(currentMonth: previous));
  }

  Future<bool> addReminder(ReminderItem item) {
    return _enqueue((userId) async {
      final updated = [...state.reminders, item];

      await _persistAndSync(
        userId,
        updated,
        changedReminder: item,
        requestPermission: item.isEnabled,
      );
    });
  }

  Future<bool> updateReminder(ReminderItem item) {
    return _enqueue((userId) async {
      final updated = state.reminders.map((reminder) {
        return reminder.id == item.id ? item : reminder;
      }).toList();

      await _persistAndSync(
        userId,
        updated,
        changedReminder: item,
        requestPermission: item.isEnabled,
      );
    });
  }

  Future<bool> setReminderEnabled(String id, bool enabled) {
    return _enqueue((userId) async {
      final index = state.reminders.indexWhere((item) => item.id == id);
      if (index == -1) return;

      final changedReminder =
          state.reminders[index].copyWith(isEnabled: enabled);

      final updated = [...state.reminders];
      updated[index] = changedReminder;

      await _persistAndSync(
        userId,
        updated,
        changedReminder: changedReminder,
        requestPermission: enabled,
      );
    });
  }

  Future<bool> removeReminder(String id) {
    return _enqueue((userId) async {
      final updated =
          state.reminders.where((item) => item.id != id).toList();

      await _persistAndSync(
        userId,
        updated,
        removedReminderId: id,
      );
    });
  }

  @override
  Future<void> close() async {
    await _authSubscription.cancel();
    await super.close();
  }
}
