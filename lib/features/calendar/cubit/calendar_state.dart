import 'package:movixapp/features/calendar/data/reminder_item.dart';

class CalendarState {
  final DateTime selectedDate;
  final DateTime currentMonth;
  final List<ReminderItem> reminders;

  const CalendarState({
    required this.selectedDate,
    required this.currentMonth,
    this.reminders = const [],
  });

  CalendarState copyWith({
    DateTime? selectedDate,
    DateTime? currentMonth,
    List<ReminderItem>? reminders,
  }) {
    return CalendarState(
      selectedDate: selectedDate ?? this.selectedDate,
      currentMonth: currentMonth ?? this.currentMonth,
      reminders: reminders ?? this.reminders,
    );
  }
}
