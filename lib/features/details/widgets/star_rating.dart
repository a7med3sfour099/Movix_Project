import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:movixapp/features/home/widgets/home_header.dart';

/// Read-only 5 stars. [score] is TMDB's 0-10 average.
class StarRating extends StatelessWidget {
  final double score;
  final double size;

  const StarRating({super.key, required this.score, this.size = 30});

  @override
  Widget build(BuildContext context) {
    final filled = (score / 2).round();
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
        5,
        (i) => Padding(
          padding: const EdgeInsets.only(right: 6),
          child: Icon(
            Symbols.star,
            size: size,
            fill: i < filled ? 1 : 0,
            color: HomeHeader.greenColor,
          ),
        ),
      ),
    );
  }
}
