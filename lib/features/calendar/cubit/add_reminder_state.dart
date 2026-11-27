import 'package:flutter/material.dart';
import 'package:movixapp/features/search/data/search_filters.dart';
import 'package:movixapp/features/search/data/search_result.dart';

class AddReminderState {
  final SearchType type;
  final String searchQuery;
  final bool isSearching;
  final List<SearchResult> searchResults;
  final SearchResult? selectedMedia;
  final String reminderTitle;
  final DateTime? selectedDate;
  final TimeOfDay? selectedTime;
  final String repeat;
  final bool isEditing;
  final bool isSaving;
  final String? error;

  const AddReminderState({
    this.type = SearchType.movies,
    this.searchQuery = '',
    this.isSearching = false,
    this.searchResults = const [],
    this.selectedMedia,
    this.reminderTitle = '',
    this.selectedDate,
    this.selectedTime,
    this.repeat = 'none',
    this.isEditing = false,
    this.isSaving = false,
    this.error,
  });

  AddReminderState copyWith({
    SearchType? type,
    String? searchQuery,
    bool? isSearching,
    List<SearchResult>? searchResults,
    SearchResult? selectedMedia,
    bool clearSelectedMedia = false,
    String? reminderTitle,
    DateTime? selectedDate,
    TimeOfDay? selectedTime,
    String? repeat,
    bool? isEditing,
    bool? isSaving,
    String? error,
    bool clearError = false,
  }) {
    return AddReminderState(
      type: type ?? this.type,
      searchQuery: searchQuery ?? this.searchQuery,
      isSearching: isSearching ?? this.isSearching,
      searchResults: searchResults ?? this.searchResults,
      selectedMedia: clearSelectedMedia
          ? null
          : (selectedMedia ?? this.selectedMedia),
      reminderTitle: reminderTitle ?? this.reminderTitle,
      selectedDate: selectedDate ?? this.selectedDate,
      selectedTime: selectedTime ?? this.selectedTime,
      repeat: repeat ?? this.repeat,
      isEditing: isEditing ?? this.isEditing,
      isSaving: isSaving ?? this.isSaving,
      error: clearError ? null : (error ?? this.error),
    );
  }
}
