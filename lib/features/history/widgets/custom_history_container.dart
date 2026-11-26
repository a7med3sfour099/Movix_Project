import 'package:flutter/material.dart';

class CustomHistoryContainer extends StatelessWidget {
  const CustomHistoryContainer({super.key, this.child});

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.black54,
        borderRadius: BorderRadius.circular(4),
      ),
      child: child,
    );
  }
}
