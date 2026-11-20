import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:movixapp/Widgets/info_chip.dart';
import 'package:movixapp/features/actors/data/person_details.dart';
// Shows a large faded photo with the actor's name and popularity.
class ActorHero extends StatelessWidget {
  final PersonDetails person;

  const ActorHero({super.key, required this.person});

  @override
  Widget build(BuildContext context) {
    const dark = ColoredBox(color: Color(0xFF0F1F1A));
    final url = person.image;
    return SizedBox(
      height: 440,
      child: Stack(
        fit: StackFit.expand,
        children: [
          url == null
              ? dark
              : Image.network(
                  url,
                  fit: BoxFit.cover,
                  alignment: Alignment.topCenter,
                  errorBuilder: (context, error, stack) => dark,
                ),
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0.4, 1],
                colors: [Colors.transparent, Color(0xFF0B1512)],
              ),
            ),
          ),
          Positioned(
            left: 16,
            right: 16,
            bottom: 8,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                InfoChip(
                  text: 'Popularity ${person.popularity.toStringAsFixed(1)}',
                  icon: Symbols.trending_up,
                  highlight: true,
                ),
                const SizedBox(height: 8),
                Text(
                  person.name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 34,
                    fontWeight: FontWeight.w800,
                    height: 1.1,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
