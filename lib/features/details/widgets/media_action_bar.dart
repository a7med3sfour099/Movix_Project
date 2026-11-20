import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:movixapp/features/home/widgets/home_header.dart';

/// Rate Now / Watchlist / Favorite / Watched.
///
/// TEMPORARY: only the look. No cubit and no saving yet, so every button
/// is unselected and does nothing. Later: pass `selected` + `onTap` per item.
class MediaActionBar extends StatelessWidget {
  const MediaActionBar({super.key});

  static const _items = [
    (Symbols.star, 'Rate Now'),
    (Symbols.bookmark, 'Watchlist'),
    (Symbols.favorite, 'Favorite'),
    (Symbols.check_circle, 'Watched'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: const Color(0xFF0C1A16),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF1E2E29)),
      ),
      child: Row(
        children: [
          for (final item in _items) ...[
            Expanded(child: _ActionButton(icon: item.$1, label: item.$2)),
            if (item != _items.last) const SizedBox(width: 8),
          ],
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback? onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    this.selected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = selected ? const Color(0xFF0B1512) : HomeHeader.greenColor;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: selected ? HomeHeader.greenColor : HomeHeader.darkColor,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 26, fill: selected ? 1 : 0),
            const SizedBox(height: 6),
            FittedBox(
              child: Text(
                label,
                style: TextStyle(
                  color: color,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
