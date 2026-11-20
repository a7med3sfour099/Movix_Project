import 'package:flutter/material.dart';
import 'package:movixapp/features/home/widgets/home_header.dart';

/// Displays actor info like age, birth date, and birthplace.
class StatBoxes extends StatelessWidget {
  final List<(String, String)> stats;

  const StatBoxes({super.key, required this.stats});

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final stat in stats) ...[
            Expanded(child: _box(stat.$1, stat.$2)),
            if (stat != stats.last) const SizedBox(width: 10),
          ],
        ],
      ),
    );
  }

  Widget _box(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 14),
      decoration: BoxDecoration(
        color: HomeHeader.darkColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFF1E2E29)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: const TextStyle(color: Color(0xFFB4C2BC), fontSize: 15),
          ),
          const SizedBox(height: 4),
          Text(
            value.isEmpty ? '-' : value,
            textAlign: TextAlign.center,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w700,
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}
