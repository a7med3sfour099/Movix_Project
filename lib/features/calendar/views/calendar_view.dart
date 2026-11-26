import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:movixapp/Widgets/custom_back_button.dart';
import 'package:movixapp/Widgets/custom_elevated_button.dart';
import 'package:movixapp/Widgets/custom_text.dart';
import 'package:movixapp/core/constants/app_colors.dart';
import 'package:movixapp/features/calendar/cubit/calendar_cubit.dart';
import 'package:movixapp/features/calendar/cubit/calendar_state.dart';
import 'package:movixapp/features/calendar/data/reminder_item.dart';
import 'package:movixapp/features/calendar/widgets/calendar_month_card.dart';
import 'package:movixapp/features/calendar/widgets/reminder_card_widget.dart';

class CalendarView extends StatelessWidget {
  const CalendarView({super.key});

  static const _months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];

  static const _weekDaysFull = [
    'Sunday',
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday'
  ];

  String _formatDateHeader(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));
    final target = DateTime(date.year, date.month, date.day);

    final monthName = _months[date.month - 1];
    final dayStr = '$monthName ${date.day}';

    if (target.isAtSameMomentAs(today)) {
      return 'Today • $dayStr';
    } else if (target.isAtSameMomentAs(tomorrow)) {
      return 'Tomorrow • $dayStr';
    } else {
      final dayOfWeek = _weekDaysFull[date.weekday % 7];
      return '$dayOfWeek • $dayStr';
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CalendarCubit(),
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: BlocBuilder<CalendarCubit, CalendarState>(
            builder: (context, state) {
              final cubit = context.read<CalendarCubit>();

              final reminderDays = state.reminders
                  .where((r) =>
                      r.date.year == state.currentMonth.year &&
                      r.date.month == state.currentMonth.month)
                  .map((r) => r.date.day)
                  .toSet();

              // Group reminders by date (nearest day order)
              final sortedReminders = List<ReminderItem>.from(state.reminders)
                ..sort((a, b) => a.date.compareTo(b.date));

              final Map<String, List<ReminderItem>> grouped = {};
              for (final item in sortedReminders) {
                final key =
                    '${item.date.year}-${item.date.month}-${item.date.day}';
                grouped.putIfAbsent(key, () => []).add(item);
              }

              return Column(
                children: [
                  // App Bar
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: CustomBackButton(),
                        ),
                        const CustomText(
                          text: 'Calender',
                          size: 20,
                          weight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                  // Body content
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      children: [
                        CalendarMonthCard(
                          currentMonth: state.currentMonth,
                          selectedDate: state.selectedDate,
                          reminderDays: reminderDays,
                          onSelectDate: (date) => cubit.selectDate(date),
                          onPreviousMonth: () => cubit.previousMonth(),
                          onNextMonth: () => cubit.nextMonth(),
                        ),
                        const Gap(24),
                        // SCHEDULED QUEUE Header
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const CustomText(
                              text: 'SCHEDULED QUEUE',
                              size: 12,
                              weight: FontWeight.bold,
                              color: Color(0xFF8B9B95),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                color: const Color(0xFF0F261E),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: const Color(0xFF1B4033),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 6,
                                    height: 6,
                                    decoration: const BoxDecoration(
                                      color: AppColors.primary,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const Gap(6),
                                  CustomText(
                                    text:
                                        '${state.reminders.length} Reminders Scheduled',
                                    size: 11,
                                    weight: FontWeight.w600,
                                    color: AppColors.primary,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const Gap(16),
                        if (state.reminders.isEmpty)
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 32),
                            child: Center(
                              child: CustomText(
                                text: 'No reminders scheduled yet',
                                size: 14,
                                color: Color(0xFF8B9B95),
                              ),
                            ),
                          )
                        else
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: grouped.entries.map((entry) {
                              final items = entry.value;
                              final date = items.first.date;
                              final headerText = _formatDateHeader(date);

                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CustomText(
                                    text: headerText,
                                    size: 18,
                                    weight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                  const Gap(12),
                                  ListView.separated(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: items.length,
                                    separatorBuilder: (context, index) =>
                                        const Gap(12),
                                    itemBuilder: (context, index) {
                                      final item = items[index];
                                      return ReminderCardWidget(
                                        item: item,
                                        onToggle: (value) =>
                                            cubit.toggleReminder(item.id),
                                        onDelete: () =>
                                            cubit.removeReminder(item.id),
                                      );
                                    },
                                  ),
                                  const Gap(20),
                                ],
                              );
                            }).toList(),
                          ),
                        const Gap(16),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                    child: CustomElevatedbutton(
                      text: 'Add Reminder',
                      backgroundColor: AppColors.primary,
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Add Reminder tapped'),
                          ),
                        );
                      },
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Symbols.notification_add,
                            size: 22,
                            color: Color(0xFF0B1512),
                          ),
                          Gap(8),
                          CustomText(
                            text: 'Add Reminder',
                            size: 16,
                            weight: FontWeight.bold,
                            color: Color(0xFF0B1512),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
