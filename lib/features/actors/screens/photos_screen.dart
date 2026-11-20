import 'package:flutter/material.dart';
import 'package:movixapp/Widgets/details_scaffold.dart';

// Opens the photo in full screen with zoom support
void showPhotoViewer(BuildContext context, String url) {
  showDialog(
    context: context,
    builder: (_) => Dialog.fullscreen(
      backgroundColor: Colors.black,
      child: Stack(
        children: [
          Positioned.fill(
            child: InteractiveViewer(
              child: Image.network(
                url.replaceFirst('/w500/', '/w1280/'),
                fit: BoxFit.contain,
                errorBuilder: (context, error, stack) => const Center(
                  child: Icon(Icons.broken_image, color: Colors.white54),
                ),
              ),
            ),
          ),
          SafeArea(
            child: Align(
              alignment: Alignment.topRight,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

class PhotosScreen extends StatelessWidget {
  final String title;
  final List<String> photos;

  const PhotosScreen({super.key, required this.title, required this.photos});

  @override
  Widget build(BuildContext context) {
    return DetailsScaffold(
      title: title,
      body: GridView.builder(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 2 / 3,
        ),
        itemCount: photos.length,
        itemBuilder: (context, i) => GestureDetector(
          onTap: () => showPhotoViewer(context, photos[i]),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.network(
              photos[i],
              fit: BoxFit.cover,
              errorBuilder: (context, error, stack) =>
                  const ColoredBox(color: Color(0xFF0F1F1A)),
            ),
          ),
        ),
      ),
    );
  }
}
