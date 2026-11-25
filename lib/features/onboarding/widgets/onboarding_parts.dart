import 'package:flutter/material.dart';
import 'package:movixapp/core/constants/app_colors.dart';

/// Dark, slightly see-through card with a green border (used in all scenes).
class GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;

  const GlassCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(14),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: const Color(0xFF0E1F1B).withValues(alpha: 0.88),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.25)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.35),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: child,
    );
  }
}

/// An image with rounded corners (from the app assets or the network).
/// If the url is missing or fails, a dark green box is shown instead.
class PosterImage extends StatelessWidget {
  final String? url;
  final double radius;

  const PosterImage({super.key, required this.url, this.radius = 16});

  @override
  Widget build(BuildContext context) {
    final fallback = Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1D4A40), Color(0xFF0E1F1B)],
        ),
      ),
    );

    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: url == null
          ? fallback
          : url!.startsWith('assets/')
          ? Image.asset(
        url!,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => fallback,
      )
          : Image.network(
        url!,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => fallback,
      ),
    );
  }
}