import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

class PersonAvatar extends StatelessWidget {
  final String name;
  final String? subtitle;
  final String? image;
  final VoidCallback? onTap;

  const PersonAvatar({
    super.key,
    required this.name,
    this.subtitle,
    this.image,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const placeholder = ColoredBox(
      color: Color(0xFF0F1F1A),
      child: Icon(Symbols.person, color: Color(0xFF26322D), size: 36),
    );
    final link = image;
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 92,
            height: 92,
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFF1E2E29), width: 2),
            ),
            child: ClipOval(
              child: link == null
                  ? placeholder
                  : Image.network(
                      link,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stack) => placeholder,
                    ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            name,
            maxLines: 2,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w600,
              height: 1.2,
            ),
          ),
          if (subtitle != null && subtitle!.isNotEmpty) ...[
            const SizedBox(height: 2),
            Text(
              subtitle!,
              maxLines: 1,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Color(0xFF7C8B85), fontSize: 12),
            ),
          ],
        ],
      ),
    );
  }
}
