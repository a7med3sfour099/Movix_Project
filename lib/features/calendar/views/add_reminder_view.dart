import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:movixapp/Widgets/custom_elevated_button.dart';
import 'package:movixapp/Widgets/custom_text.dart';
import 'package:movixapp/core/constants/app_colors.dart';
import 'package:movixapp/features/calendar/cubit/add_reminder_cubit.dart';
import 'package:movixapp/features/calendar/cubit/add_reminder_state.dart';
import 'package:movixapp/features/calendar/cubit/calendar_cubit.dart';
import 'package:movixapp/features/calendar/data/reminder_item.dart';
import 'package:movixapp/features/calendar/widgets/reminder_type_card.dart';
import 'package:movixapp/features/calendar/widgets/schedule_picker_card.dart';
import 'package:movixapp/features/calendar/widgets/selected_media_card.dart';
import 'package:movixapp/features/search/data/search_filters.dart';

class AddReminderView extends StatefulWidget {
  final CalendarCubit calendarCubit;
  final ReminderItem? initialItem;

  const AddReminderView({
    super.key,
    required this.calendarCubit,
    this.initialItem,
  });

  @override
  State<AddReminderView> createState() => _AddReminderViewState();
}

class _AddReminderViewState extends State<AddReminderView> {
  late final AddReminderCubit _cubit =
      AddReminderCubit(initialItem: widget.initialItem);

  // Built ONCE. The keyboard changes the bottom padding on every frame while
  // it opens; because this widget is the very same object each time, the
  // whole form is not rebuilt on those frames, so the keyboard opens smoothly.
  late final Widget _form = _ReminderForm(calendarCubit: widget.calendarCubit);

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: Container(
        decoration: const BoxDecoration(
          color: Color(0xFF0F1F1A),
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: EdgeInsets.only(
          bottom: MediaQuery.viewInsetsOf(context).bottom + 16,
          left: 18,
          right: 18,
          top: 20,
        ),
        child: SingleChildScrollView(child: _form),
      ),
    );
  }
}

class _ReminderForm extends StatelessWidget {
  final CalendarCubit calendarCubit;

  const _ReminderForm({required this.calendarCubit});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AddReminderCubit, AddReminderState>(
      listenWhen: (previous, current) =>
          current.error != null && current.error != previous.error,
      listener: (context, state) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(state.error!)),
        );
        context.read<AddReminderCubit>().clearError();
      },
      // Typing in the search box must NOT rebuild the whole sheet.
      // The search part has its own BlocBuilder (_SearchSection).
      buildWhen: (previous, current) =>
          previous.type != current.type ||
          previous.selectedDate != current.selectedDate ||
          previous.selectedTime != current.selectedTime ||
          previous.repeat != current.repeat ||
          previous.isEditing != current.isEditing ||
          previous.isSaving != current.isSaving,
      builder: (context, state) {
        final cubit = context.read<AddReminderCubit>();

        String formattedDate = 'Enter a date';
        if (state.selectedDate != null) {
          final d = state.selectedDate!;
          final m = d.month.toString().padLeft(2, '0');
          final day = d.day.toString().padLeft(2, '0');
          formattedDate = '$m/$day/${d.year}';
        }

        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      text: state.isEditing
                          ? 'Edit Reminder'
                          : 'App Reminder',
                      size: 22,
                      weight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    const Gap(4),
                    const CustomText(
                      text: 'Schedule alerts for upcoming premiers',
                      size: 13,
                      color: Color(0xFF8B9B95),
                    ),
                  ],
                ),
                InkWell(
                  onTap: () => Navigator.of(context).pop(),
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: Color(0xFF1B2A25),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Symbols.close,
                      color: Color(0xFFB4C2BC),
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
            const Gap(20),
            const Divider(color: Color(0xFF1E2E29)),
            const Gap(16),

            // Reminder Type
            const CustomText(
              text: 'Reminder Type',
              size: 14,
              weight: FontWeight.bold,
              color: Colors.white,
            ),
            const Gap(10),
            Row(
              children: [
                Expanded(
                  child: ReminderTypeCard(
                    icon: Symbols.local_activity,
                    title: 'Movie',
                    isSelected: state.type == SearchType.movies,
                    onTap: () => cubit.selectType(SearchType.movies),
                  ),
                ),
                const Gap(12),
                Expanded(
                  child: ReminderTypeCard(
                    icon: Symbols.smart_display,
                    title: 'Tv Show',
                    isSelected: state.type == SearchType.tv,
                    onTap: () => cubit.selectType(SearchType.tv),
                  ),
                ),
              ],
            ),
            const Gap(20),

            CustomText(
              text: state.type == SearchType.movies
                  ? 'Select a movie'
                  : 'Select a show',
              size: 14,
              weight: FontWeight.bold,
              color: Colors.white,
            ),
            const Gap(10),
            const _SearchSection(),
            const Gap(20),

            // Reminder Title
            const CustomText(
              text: 'Reminder Title',
              size: 14,
              weight: FontWeight.bold,
              color: Colors.white,
            ),
            const Gap(10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: const Color(0xFF13221C),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFF23352E)),
              ),
              child: TextField(
                controller: cubit.titleController,
                onChanged: (val) => cubit.updateTitle(val),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
                decoration: const InputDecoration(
                  hintText: 'Enter a title',
                  hintStyle: TextStyle(
                    color: Color(0xFF5C6C66),
                    fontSize: 14,
                  ),
                  border: InputBorder.none,
                ),
              ),
            ),
            const Gap(20),

            // Reminder Schedule
            const CustomText(
              text: 'Reminder Schedule',
              size: 14,
              weight: FontWeight.bold,
              color: Colors.white,
            ),
            const Gap(10),
            Row(
              children: [
                Expanded(
                  child: SchedulePickerCard(
                    text: formattedDate,
                    isSelected: state.selectedDate != null,
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate:
                            state.selectedDate ?? DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2030),
                        builder: (context, child) {
                          return Theme(
                            data: ThemeData.dark().copyWith(
                              colorScheme: const ColorScheme.dark(
                                primary: AppColors.primary,
                                onPrimary: Color(0xFF0B1512),
                                surface: Color(0xFF13221C),
                                onSurface: Colors.white,
                              ),
                            ),
                            child: child!,
                          );
                        },
                      );
                      if (picked != null) {
                        cubit.selectDate(picked);
                      }
                    },
                  ),
                ),
                const Gap(12),
                Expanded(
                  child: SchedulePickerCard(
                    text: state.selectedTime != null
                        ? state.selectedTime!.format(context)
                        : 'Enter a time',
                    isSelected: state.selectedTime != null,
                    onTap: () async {
                      final picked = await showTimePicker(
                        context: context,
                        initialTime: state.selectedTime ??
                            TimeOfDay.now(),
                        builder: (context, child) {
                          return Theme(
                            data: ThemeData.dark().copyWith(
                              colorScheme: const ColorScheme.dark(
                                primary: AppColors.primary,
                                onPrimary: Color(0xFF0B1512),
                                surface: Color(0xFF13221C),
                                onSurface: Colors.white,
                              ),
                            ),
                            child: child!,
                          );
                        },
                      );
                      if (picked != null) {
                        cubit.selectTime(picked);
                      }
                    },
                  ),
                ),
              ],
            ),
            const Gap(20),

            // Repeat Frequency
            const CustomText(
              text: 'Repeat Frequency',
              size: 14,
              weight: FontWeight.bold,
              color: Colors.white,
            ),
            const Gap(10),
            Row(
              children: [
                Expanded(
                  child: ReminderTypeCard(
                    icon: Symbols.event,
                    title: 'None',
                    isSelected: state.repeat == 'none',
                    onTap: () => cubit.selectRepeat('none'),
                  ),
                ),
                const Gap(8),
                Expanded(
                  child: ReminderTypeCard(
                    icon: Symbols.update,
                    title: 'Daily',
                    isSelected: state.repeat == 'daily',
                    onTap: () => cubit.selectRepeat('daily'),
                  ),
                ),
                const Gap(8),
                Expanded(
                  child: ReminderTypeCard(
                    icon: Symbols.date_range,
                    title: 'Weekly',
                    isSelected: state.repeat == 'weekly',
                    onTap: () => cubit.selectRepeat('weekly'),
                  ),
                ),
              ],
            ),
            const Gap(32),

            // Save Button
            CustomElevatedbutton(
              text: state.isEditing ? 'Save changes' : 'Save reminder',
              backgroundColor: AppColors.primary,
              isLoading: state.isSaving,
  onPressed: state.isSaving
      ? null
      : () async {
          final success = await cubit.saveReminder(calendarCubit);

          if (!context.mounted) return;

          if (success) {
            Navigator.of(context).pop();
          }
        },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Symbols.notification_add,
                    size: 20,
                    color: Color(0xFF0B1512),
                  ),
                  const Gap(8),
                  CustomText(
                    text:
                        state.isEditing ? 'Save changes' : 'Save reminder',
                    size: 16,
                    weight: FontWeight.bold,
                    color: const Color(0xFF0B1512),
                  ),
                ],
              ),
            ),
            const Gap(12),
          ],
        );
      },
    );
  }
}

/// Search box + the list of suggestions. It has its own BlocBuilder, so only
/// this part rebuilds while typing. Behaves like the other searches in the
/// app (loading right away, results after [searchDelay]), but it only looks
/// inside the selected type (Movie or Tv Show).
class _SearchSection extends StatefulWidget {
  const _SearchSection();

  @override
  State<_SearchSection> createState() => _SearchSectionState();
}

class _SearchSectionState extends State<_SearchSection> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AddReminderCubit>();

    return BlocBuilder<AddReminderCubit, AddReminderState>(
      buildWhen: (previous, current) =>
          previous.type != current.type ||
          previous.isSearching != current.isSearching ||
          previous.searchResults != current.searchResults ||
          previous.selectedMedia != current.selectedMedia,
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: const Color(0xFF13221C),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFF23352E)),
              ),
              child: Row(
                children: [
                  const Icon(
                    Symbols.search,
                    color: Color(0xFF8B9B95),
                    size: 20,
                  ),
                  const Gap(10),
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      onChanged: cubit.onSearchChanged,
                      onSubmitted: cubit.search,
                      textInputAction: TextInputAction.search,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                      decoration: InputDecoration(
                        hintText: state.type == SearchType.movies
                            ? 'Search movies...'
                            : 'Search TV shows...',
                        hintStyle: const TextStyle(
                          color: Color(0xFF5C6C66),
                          fontSize: 14,
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  if (state.isSearching)
                    const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.primary,
                      ),
                    ),
                ],
              ),
            ),
            const Gap(10),

            if (state.selectedMedia != null)
              SelectedMediaCard(media: state.selectedMedia!)
            else if (state.searchResults.isNotEmpty)
              Container(
                constraints: const BoxConstraints(maxHeight: 180),
                decoration: BoxDecoration(
                  color: const Color(0xFF13221C),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFF23352E)),
                ),
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: state.searchResults.length,
                  separatorBuilder: (context, index) =>
                      const Divider(color: Color(0xFF1E2E29), height: 1),
                  itemBuilder: (context, index) {
                    final item = state.searchResults[index];
                    return ListTile(
                      dense: true,
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: item.image != null
                            ? Image.network(
                                item.image!,
                                width: 32,
                                height: 48,
                                fit: BoxFit.cover,
                                errorBuilder:
                                    (context, error, stackTrace) =>
                                        Container(
                                  width: 32,
                                  height: 48,
                                  color: const Color(0xFF1B2825),
                                  child: const Icon(
                                    Symbols.movie,
                                    size: 18,
                                    color: AppColors.primary,
                                  ),
                                ),
                              )
                            : Container(
                                width: 32,
                                height: 48,
                                color: const Color(0xFF1B2825),
                                child: const Icon(
                                  Symbols.movie,
                                  size: 18,
                                  color: AppColors.primary,
                                ),
                              ),
                      ),
                      title: Text(
                        item.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        item.year != null ? '${item.year}' : item.type,
                        style: const TextStyle(
                          color: Color(0xFF8B9B95),
                          fontSize: 11,
                        ),
                      ),
                      onTap: () => cubit.selectMedia(item),
                    );
                  },
                ),
              ),
          ],
        );
      },
    );
  }
}
