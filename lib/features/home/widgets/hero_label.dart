import 'package:flutter/material.dart';

class HeroGenreLabel extends StatelessWidget {
  final String genre;

  const HeroGenreLabel({super.key, required this.genre});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 140),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0x990F1F1A),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        genre,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w300,
        ),
      ),
    );
  }
}
