import 'package:movixapp/features/calendar/data/reminder_item.dart';

class CalendarState {
  final DateTime selectedDate;
  final DateTime currentMonth;
  final List<ReminderItem> reminders;
  final String? error;

  const CalendarState({
    required this.selectedDate,
    required this.currentMonth,
    this.reminders = const [],
    this.error,
  });

  CalendarState copyWith({
    DateTime? selectedDate,
    DateTime? currentMonth,
    List<ReminderItem>? reminders,
    String? error,
    bool clearError = false,
  }) {
    return CalendarState(
      selectedDate: selectedDate ?? this.selectedDate,
      currentMonth: currentMonth ?? this.currentMonth,
      reminders: reminders ?? this.reminders,
      error: clearError ? null : (error ?? this.error),
    );
  }
}
