import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:movixapp/Widgets/custom_text.dart';
import 'package:movixapp/core/constants/app_colors.dart';

class CalendarMonthCard extends StatelessWidget {
  final DateTime currentMonth;
  final DateTime selectedDate;
  final Set<int> reminderDays;
  final ValueChanged<DateTime> onSelectDate;
  final VoidCallback onPreviousMonth;
  final VoidCallback onNextMonth;

  const CalendarMonthCard({
    super.key,
    required this.currentMonth,
    required this.selectedDate,
    required this.reminderDays,
    required this.onSelectDate,
    required this.onPreviousMonth,
    required this.onNextMonth,
  });

  static const _weekDays = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];
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

  @override
  Widget build(BuildContext context) {
    final monthName = _months[currentMonth.month - 1];
    final yearName = '${currentMonth.year}';

    final firstDayOfMonth =
        DateTime(currentMonth.year, currentMonth.month, 1);
    final daysInMonth =
        DateTime(currentMonth.year, currentMonth.month + 1, 0).day;
    final startingWeekday = firstDayOfMonth.weekday % 7;

    final prevMonthDays =
        DateTime(currentMonth.year, currentMonth.month, 0).day;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF131D1B),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFF23322E),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: monthName,
                    size: 18,
                    weight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  const Gap(2),
                  CustomText(
                    text: yearName,
                    size: 18,
                    weight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ],
              ),
              Row(
                children: [
                  _navButton(
                    icon: Icons.chevron_left_rounded,
                    onTap: onPreviousMonth,
                  ),
                  const Gap(8),
                  _navButton(
                    icon: Icons.chevron_right_rounded,
                    onTap: onNextMonth,
                  ),
                ],
              ),
            ],
          ),
          const Gap(16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: _weekDays
                .map(
                  (day) => SizedBox(
                    width: 32,
                    child: CustomText(
                      text: day,
                      size: 13,
                      weight: FontWeight.w600,
                      color: const Color(0xFF6B7C76),
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
                .toList(),
          ),
          const Gap(12),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 35,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              mainAxisSpacing: 8,
              crossAxisSpacing: 4,
            ),
            itemBuilder: (context, index) {
              int dayNumber;
              bool isCurrentMonth = true;

              if (index < startingWeekday) {
                dayNumber = prevMonthDays - (startingWeekday - 1 - index);
                isCurrentMonth = false;
              } else if (index >= startingWeekday + daysInMonth) {
                dayNumber = index - (startingWeekday + daysInMonth) + 1;
                isCurrentMonth = false;
              } else {
                dayNumber = index - startingWeekday + 1;
              }

              final date = DateTime(
                  currentMonth.year, currentMonth.month, dayNumber);
              final isSelected = isCurrentMonth &&
                  selectedDate.year == currentMonth.year &&
                  selectedDate.month == currentMonth.month &&
                  selectedDate.day == dayNumber;
              final hasDot = isCurrentMonth && reminderDays.contains(dayNumber);

              return GestureDetector(
                onTap: () {
                  if (isCurrentMonth) {
                    onSelectDate(date);
                  }
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.transparent,
                        border: isSelected
                            ? Border.all(color: AppColors.primary, width: 2)
                            : null,
                      ),
                      child: CustomText(
                        text: '$dayNumber',
                        size: 14,
                        weight: isSelected ? FontWeight.bold : FontWeight.w500,
                        color: !isCurrentMonth
                            ? const Color(0xFF3B4844)
                            : (isSelected ? AppColors.primary : Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const Gap(2),
                    if (hasDot)
                      Container(
                        width: 4,
                        height: 4,
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                      )
                    else
                      const SizedBox(height: 4),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _navButton({required IconData icon, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: const Color(0xFF1B2825),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          icon,
          color: const Color(0xFFB4C2BC),
          size: 20,
        ),
      ),
    );
  }
}
