import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:movixapp/core/bottom_bar.dart';
import 'package:movixapp/features/home/widgets/home_header.dart';

/// Placeholder until the Library design is ready.
class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFF0B1512),
      bottomNavigationBar: BottomBar(),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Symbols.video_library, size: 48, color: HomeHeader.greenColor),
              SizedBox(height: 12),
              Text(
                'Your library is empty',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Saved movies and shows will show up here',
                style: TextStyle(color: Color(0xFF7C8B85), fontSize: 13),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
