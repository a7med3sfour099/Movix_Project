import 'package:flutter/material.dart';
import 'package:movixapp/Widgets/section_title.dart';
import 'package:movixapp/features/actors/screens/photos_screen.dart';


class PhotoGallery extends StatelessWidget {
  final String title;
  final List<String> photos;
  final int previewCount;

  const PhotoGallery({
    super.key,
    required this.title,
    required this.photos,
    this.previewCount = 10,
  });

  @override
  Widget build(BuildContext context) {
    if (photos.isEmpty) return const SizedBox.shrink();
    final preview = photos.take(previewCount).toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitle(
          title: 'Photos Gallery',
          actionText: 'View all ${photos.length} photos',
          onAction: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => PhotosScreen(title: title, photos: photos),
            ),
          ),
        ),
        const SizedBox(height: 14),
        SizedBox(
          height: 200,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: preview.length,
            separatorBuilder: (context, i) => const SizedBox(width: 12),
            itemBuilder: (context, i) => GestureDetector(
              onTap: () => showPhotoViewer(context, preview[i]),
              child: AspectRatio(
                aspectRatio: 0.72,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: Image.network(
                    preview[i],
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stack) =>
                        const ColoredBox(color: Color(0xFF0F1F1A)),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
