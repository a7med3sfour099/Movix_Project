import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:movixapp/Widgets/are_you_sure_dialog.dart';
import 'package:movixapp/Widgets/custom_text.dart';
import 'package:movixapp/core/constants/app_colors.dart';
import 'package:movixapp/features/calendar/data/reminder_item.dart';

class ReminderCardWidget extends StatelessWidget {
  final ReminderItem item;
  final ValueChanged<bool> onToggle;
  final VoidCallback onDelete;

  const ReminderCardWidget({
    super.key,
    required this.item,
    required this.onToggle,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF131D1B),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFF23322E)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: SizedBox(
              width: 72,
              height: 104,
              child: item.posterUrl.isNotEmpty
                  ? Image.network(
                      item.posterUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          _posterPlaceholder(),
                    )
                  : _posterPlaceholder(),
            ),
          ),
          const Gap(12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomText(
                      text: item.category,
                      size: 12,
                      weight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                    InkWell(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (dialogContext) => AreYouSureDialog(
                            title: 'Remove Reminder?',
                            description:
                                'Are you sure you want to remove this reminder for "${item.title}"?',
                            icon: Symbols.notifications_off,
                            iconColor: const Color(0xFFE53935),
                            iconBackgroundColor: const Color(0xFF331718),
                            confirmText: 'Remove',
                            confirmIcon: Symbols.delete,
                            confirmColor: const Color(0xFF990000),
                            onConfirm: () {
                              Navigator.of(dialogContext).pop();
                              onDelete();
                            },
                          ),
                        );
                      },
                      child: const Icon(
                        Symbols.delete,
                        size: 18,
                        color: Color(0xFFB4C2BC),
                      ),
                    ),
                  ],
                ),
                const Gap(4),
                CustomText(
                  text: item.title,
                  size: 15,
                  weight: FontWeight.bold,
                  color: Colors.white,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const Gap(2),
                CustomText(
                  text: item.subtitle,
                  size: 12,
                  weight: FontWeight.w400,
                  color: const Color(0xFF8B9B95),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const Gap(10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Symbols.notifications,
                          size: 16,
                          color: AppColors.primary,
                        ),
                        const Gap(4),
                        CustomText(
                          text: item.time,
                          size: 13,
                          weight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ],
                    ),
                    Transform.scale(
                      scale: 0.8,
                      child: Switch(
                        value: item.isEnabled,
                        onChanged: onToggle,
                        activeThumbColor: const Color(0xFF0B1512),
                        activeTrackColor: AppColors.primary,
                        inactiveTrackColor: const Color(0xFF1E2E29),
                        inactiveThumbColor: const Color(0xFF8B9B95),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _posterPlaceholder() {
    return Container(
      color: const Color(0xFF1B2825),
      child: const Center(
        child: Icon(
          Symbols.movie,
          color: Color(0xFF4FE4A6),
          size: 32,
        ),
      ),
    );
  }
}
