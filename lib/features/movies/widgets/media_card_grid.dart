import 'package:flutter/material.dart';
import 'package:movixapp/features/home/widgets/media_card.dart';
import 'package:movixapp/features/home/data/media_item.dart';

/// Two-column grid of [MediaCard]s that sits inside another scroll view
/// (e.g. the Movies / TV Shows tabs on the actor profile).
class MediaCardGrid extends StatelessWidget {
  final List<MediaItem> items;
  final String emptyMessage;

  const MediaCardGrid({
    super.key,
    required this.items,
    this.emptyMessage = 'Nothing here yet',
  });

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 40),
        child: Center(
          child: Text(
            emptyMessage,
            style: const TextStyle(color: Color(0xFF7C8B85)),
          ),
        ),
      );
    }
    return LayoutBuilder(
      builder: (context, constraints) {
        const spacing = 12.0;
        final cellWidth = (constraints.maxWidth - spacing) / 2;
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: spacing,
            mainAxisSpacing: 16,
            mainAxisExtent: cellWidth * 1.5 + 56,
          ),
          itemCount: items.length,
          itemBuilder: (context, i) =>
              MediaCard(item: items[i], width: double.infinity),
        );
      },
    );
  }
}
