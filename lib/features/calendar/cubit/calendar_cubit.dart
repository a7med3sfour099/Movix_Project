import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movixapp/features/calendar/data/reminder_item.dart';
import 'package:movixapp/features/profile/data/profile_database.dart';
import 'calendar_state.dart';

class CalendarCubit extends Cubit<CalendarState> {
  CalendarCubit()
      : super(
          CalendarState(
            selectedDate: DateTime.now(),
            currentMonth: DateTime(DateTime.now().year, DateTime.now().month, 1),
            reminders: const [],
          ),
        ) {
    _authSubscription =
        FirebaseAuth.instance.authStateChanges().listen((user) async {
      if (user == null) {
        if (!isClosed) {
          emit(state.copyWith(reminders: const []));
        }
        return;
      }
      await loadRemindersForUser(user.uid);
    });

    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      loadRemindersForUser(currentUser.uid);
    }
  }

  final ProfileDatabase _database = ProfileDatabase();
  late final StreamSubscription<User?> _authSubscription;

  Future<void> loadRemindersForUser(String userId) async {
    try {
      final list = await _database.getReminders(userId);
      if (!isClosed && FirebaseAuth.instance.currentUser?.uid == userId) {
        list.sort((a, b) => a.date.compareTo(b.date));
        emit(state.copyWith(reminders: list));
      }
    } catch (_) {}
  }

  Future<void> _persist() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;
    try {
      await _database.saveReminders(userId, state.reminders);
    } catch (_) {}
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
    final prev =
        DateTime(state.currentMonth.year, state.currentMonth.month - 1, 1);
    emit(state.copyWith(currentMonth: prev));
  }

  void addReminder(ReminderItem item) {
    final updated = [...state.reminders, item];
    updated.sort((a, b) => a.date.compareTo(b.date));
    emit(state.copyWith(reminders: updated));
    _persist();
  }

  void updateReminder(ReminderItem item) {
    final updated = state.reminders.map((r) {
      if (r.id == item.id) return item;
      return r;
    }).toList();
    updated.sort((a, b) => a.date.compareTo(b.date));
    emit(state.copyWith(reminders: updated));
    _persist();
  }

  void toggleReminder(String id) {
    final updated = state.reminders.map((r) {
      if (r.id == id) {
        return r.copyWith(isEnabled: !r.isEnabled);
      }
      return r;
    }).toList();
    emit(state.copyWith(reminders: updated));
    _persist();
  }

  void removeReminder(String id) {
    final updated = state.reminders.where((r) => r.id != id).toList();
    emit(state.copyWith(reminders: updated));
    _persist();
  }

  @override
  Future<void> close() {
    _authSubscription.cancel();
    return super.close();
  }
}
