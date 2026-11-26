import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:movixapp/Widgets/are_you_sure_dialog.dart';
import 'package:movixapp/Widgets/custom_elevated_button.dart';
import 'package:movixapp/Widgets/custom_text.dart';
import 'package:movixapp/core/constants/app_colors.dart';
import 'package:movixapp/features/history/widgets/custom_history_container.dart';
import 'package:movixapp/features/home/data/media_item.dart';

class HistoryCard extends StatelessWidget {
  final MediaItem item;
  final VoidCallback onDelete;
  final VoidCallback onFavorite;
  final VoidCallback? onTap;

  const HistoryCard({
    super.key,
    required this.item,
    required this.onDelete,
    required this.onFavorite,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
      decoration: BoxDecoration(
        color: Color(0xff182120),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
                child: AspectRatio(
                  aspectRatio: 2 / 3,
                  child: item.image != null && item.image!.isNotEmpty
                      ? Image.network(
                          item.image!,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => _placeholder(),
                        )
                      : _placeholder(),
                ),
              ),
              Positioned(
                top: 8,
                left: 8,
                child: CustomHistoryContainer(
                  child: CustomText(
                    text: item.year,
                    color: Colors.white,
                    size: 12,
                  ),
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: CustomHistoryContainer(
                  child: Row(
                    children: [
                      const Icon(
                        Icons.star,
                        color: AppColors.primary,
                        size: 14,
                      ),
                      const Gap(2),
                      CustomText(
                        text: item.rating,
                        color: Colors.white,
                        size: 12,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            text: item.title,
                            color: Colors.white,
                            size: 14,
                            weight: FontWeight.bold,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const Gap(8),
                          CustomText(
                            text: item.type.toUpperCase(),
                            color: AppColors.tertiary,
                            size: 13,
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        final shouldDelete = await showDialog<bool>(
                          context: context,
                          builder: (context) => AreYouSureDialog(
                            title: 'Delete from History',
                            description:
                                'Are you sure you want to remove this item?',
                            icon: Symbols.heart_broken_sharp,
                            iconColor: Color(0xffFFB4AB),
                            iconBackgroundColor: Color(0xff93000A),
                            confirmIcon: Symbols.delete,
                            confirmText: 'Remove',
                            onConfirm: () => Navigator.pop(context, true),
                            onCancel: () => Navigator.pop(context),
                          ),
                        );

                        if (shouldDelete == true) {
                          onDelete();
                        }
                      },
                      child: CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.redAccent.withOpacity(0.15),
                        child: const Icon(
                          Symbols.delete,
                          color: Colors.red,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
                const Gap(12),

                /// Add to favorite button (stays on this page)
                SizedBox(
                  width: double.infinity,
                  height: 35,
                  child: CustomElevatedbutton(
                    text: "Add to favorite",
                    size: 14,
                    onPressed: onFavorite,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
    );
  }

  Widget _placeholder() {
    return Container(
      color: Colors.grey[800],
      child: const Icon(Icons.movie, color: Colors.white54, size: 50),
    );
  }
}
