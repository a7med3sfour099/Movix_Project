import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movixapp/features/calendar/cubit/calendar_cubit.dart';
import 'package:movixapp/features/calendar/data/reminder_item.dart';
import 'package:movixapp/features/search/data/search_api.dart';
import 'package:movixapp/features/search/data/search_filters.dart';
import 'package:movixapp/features/search/data/search_result.dart';
import 'add_reminder_state.dart';

class AddReminderCubit extends Cubit<AddReminderState> {
  final ReminderItem? initialItem;
  final TextEditingController titleController = TextEditingController();

  AddReminderCubit({this.initialItem}) : super(const AddReminderState()) {
    if (initialItem != null) {
      titleController.text = initialItem!.title;
      TimeOfDay? parsedTime;
      try {
        final parts = initialItem!.time.split(' ');
        final hm = parts[0].split(':');
        int hour = int.parse(hm[0]);
        final minute = int.parse(hm[1]);
        if (parts.length > 1 && parts[1].toUpperCase() == 'PM' && hour < 12) {
          hour += 12;
        }
        if (parts.length > 1 && parts[1].toUpperCase() == 'AM' && hour == 12) {
          hour = 0;
        }
        parsedTime = TimeOfDay(hour: hour, minute: minute);
      } catch (_) {
        parsedTime = TimeOfDay.now();
      }

      emit(state.copyWith(
        isEditing: true,
        reminderTitle: initialItem!.title,
        selectedDate: initialItem!.date,
        selectedTime: parsedTime,
        repeat: initialItem!.repeat,
        type: initialItem!.category.contains('TV')
            ? SearchType.tv
            : SearchType.movies,
      ));
    }
  }

  final SearchApi _searchApi = SearchApi();

  void selectType(SearchType type) {
    if (state.type != type) {
      emit(state.copyWith(
        type: type,
        clearSelectedMedia: true,
        searchResults: const [],
      ));
      if (state.searchQuery.trim().isNotEmpty) {
        search(state.searchQuery);
      }
    }
  }

  void selectRepeat(String repeat) {
    emit(state.copyWith(repeat: repeat));
  }

  Future<void> search(String query) async {
    emit(state.copyWith(searchQuery: query));
    if (query.trim().isEmpty) {
      emit(state.copyWith(searchResults: const [], isSearching: false));
      return;
    }

    emit(state.copyWith(isSearching: true));
    try {
      final results = await _searchApi.search(query.trim(), state.type);
      if (!isClosed) {
        emit(state.copyWith(searchResults: results, isSearching: false));
      }
    } catch (_) {
      if (!isClosed) {
        emit(state.copyWith(
          isSearching: false,
          error: 'Failed to fetch search results',
        ));
      }
    }
  }

  void selectMedia(SearchResult result) {
    if (titleController.text.isEmpty) {
      titleController.text = result.title;
      emit(state.copyWith(selectedMedia: result, reminderTitle: result.title));
    } else {
      emit(state.copyWith(selectedMedia: result));
    }
  }

  void updateTitle(String title) {
    emit(state.copyWith(reminderTitle: title));
  }

  void selectDate(DateTime date) {
    emit(state.copyWith(selectedDate: date));
  }

  void selectTime(TimeOfDay time) {
    emit(state.copyWith(selectedTime: time));
  }

  bool saveReminder(CalendarCubit calendarCubit) {
    if (state.selectedMedia == null && state.reminderTitle.trim().isEmpty) {
      emit(state.copyWith(
          error: 'Please select a movie/show or enter a title'));
      return false;
    }
    if (state.selectedDate == null) {
      emit(state.copyWith(error: 'Please select a date'));
      return false;
    }
    if (state.selectedTime == null) {
      emit(state.copyWith(error: 'Please select a time'));
      return false;
    }

    final media = state.selectedMedia;
    final category = state.type == SearchType.movies
        ? 'MOVIE PREMIERE'
        : (media?.type == 'tv'
            ? 'TV SHOW'
            : (initialItem?.category ?? 'SHOW PREMIERE'));

    final title = state.reminderTitle.trim().isNotEmpty
        ? state.reminderTitle.trim()
        : (media?.title ?? (initialItem?.title ?? 'Scheduled Reminder'));

    final date = DateTime(
      state.selectedDate!.year,
      state.selectedDate!.month,
      state.selectedDate!.day,
      state.selectedTime!.hour,
      state.selectedTime!.minute,
    );

    final hour = state.selectedTime!.hourOfPeriod == 0
        ? 12
        : state.selectedTime!.hourOfPeriod;
    final minuteStr = state.selectedTime!.minute.toString().padLeft(2, '0');
    final periodStr =
        state.selectedTime!.period == DayPeriod.am ? 'AM' : 'PM';
    final timeStr = '$hour:$minuteStr $periodStr';

    final reminder = ReminderItem(
      id: initialItem?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      category: category,
      title: title,
      subtitle: media != null
          ? 'Scheduled Premiere'
          : (initialItem?.subtitle ?? 'Custom Alert'),
      time: timeStr,
      posterUrl: media?.image ?? (initialItem?.posterUrl ?? ''),
      date: date,
      repeat: state.repeat,
      isEnabled: initialItem?.isEnabled ?? true,
    );

    if (state.isEditing) {
      calendarCubit.updateReminder(reminder);
    } else {
      calendarCubit.addReminder(reminder);
    }
    return true;
  }

  @override
  Future<void> close() {
    titleController.dispose();
    return super.close();
  }
}
