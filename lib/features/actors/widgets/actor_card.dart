import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:movixapp/Widgets/custom_text.dart';
import 'package:movixapp/features/actors/data/actor.dart';
import 'package:movixapp/features/home/widgets/home_header.dart';
import 'package:movixapp/features/actors/screens/actor_profile_screen.dart';

class ActorCard extends StatelessWidget {
  final Actor actor;
  final double width;
  final VoidCallback? onTap;

  const ActorCard({
    super.key,
    required this.actor,
    this.width = 150,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final subtitle = actor.knownFor.isEmpty ? 'Actor' : actor.knownFor.first;

    return GestureDetector(
      onTap: onTap ??
              () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ActorProfileScreen(id: actor.id),
            ),
          ),
      child: SizedBox(
        width: width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: AspectRatio(
                aspectRatio: 2 / 3,
                child: _image(actor.image),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: CustomText(
                    text: actor.name,
                    size: 14,
                    weight: FontWeight.w700,
                    textAlign: TextAlign.start,
                  ),
                ),
                const Icon(
                  Symbols.chevron_right,
                  size: 16,
                  color: Color(0xFFB4C2BC),
                ),
              ],
            ),
            const SizedBox(height: 2),
            CustomText(
              text: subtitle,
              color: HomeHeader.greenColor,
              size: 11,
              weight: FontWeight.w600,
              textAlign: TextAlign.start,
            ),
          ],
        ),
      ),
    );
  }

  Widget _image(String? url) {
    const placeholder = ColoredBox(
      color: Color(0xFF0F1F1A),
      child: Center(
        child: Icon(Symbols.person, color: Color(0xFF26322D), size: 48),
      ),
    );
    if (url == null) return placeholder;
    return Image.network(
      url,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stack) => placeholder,
    );
  }
}
