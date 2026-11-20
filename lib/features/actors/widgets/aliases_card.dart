import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:movixapp/Widgets/info_chip.dart';
import 'package:movixapp/features/home/widgets/home_header.dart';

// Shows the Known Aliases card when there are aliases to display.
class AliasesCard extends StatelessWidget {
  final List<String> aliases;
  final int maxItems;

  const AliasesCard({super.key, required this.aliases, this.maxItems = 8});

  @override
  Widget build(BuildContext context) {
    if (aliases.isEmpty) return const SizedBox.shrink();
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF0C1A16),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF1E2E29)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Symbols.badge, color: HomeHeader.greenColor),
              SizedBox(width: 10),
              Text(
                'Known Aliases',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final name in aliases.take(maxItems))
                InfoChip(text: name, fontSize: 15),
            ],
          ),
        ],
      ),
    );
  }
}
