import 'package:flutter/material.dart';
import 'package:movixapp/features/home/widgets/home_header.dart';


class MediaPoster extends StatelessWidget {
  final String? url;
  final String? bannerText;
  final double aspectRatio;
  final double radius;
  final IconData? placeholderIcon;
  final Color accentColor;
  final List<Widget> overlays;
  // Small poster mode: only a corner ribbon, no dark overlay
  final bool compact;

  const MediaPoster({
    super.key,
    required this.url,
    this.bannerText,
    this.aspectRatio = 2 / 3,
    this.radius = 14,
    this.placeholderIcon,
    this.accentColor = HomeHeader.greenColor,
    this.overlays = const [],
    this.compact = false,
  });

  static const comingSoon = 'COMING SOON';
  static const stayTuned = 'STAY TUNED';
  // Fixed text for the Watch feature (it is not available yet for any title)
  static const watchSoon = 'WATCHING SOON';


  static const _grayscale = ColorFilter.matrix(<double>[
    0.2126, 0.7152, 0.0722, 0, 0, //
    0.2126, 0.7152, 0.0722, 0, 0,
    0.2126, 0.7152, 0.0722, 0, 0,
    0, 0, 0, 1, 0,
  ]);

  /// Checks if [date] (yyyy-MM-dd) is in the future.
  static bool isUnreleased(String? date) {
    final parsed = DateTime.tryParse(date ?? '');
    return parsed != null && parsed.isAfter(DateTime.now());
  }

  /// Shows COMING SOON for known future dates, or STAY TUNED when no date is set.
  static String bannerFor(String? date) =>
      (date == null || date.isEmpty) ? stayTuned : comingSoon;

  @override
  Widget build(BuildContext context) {
    final banner = bannerText;
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: AspectRatio(
        aspectRatio: aspectRatio,
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (banner == null)
              _image()
            else ...[
              compact ? _image() : ColorFiltered(colorFilter: _grayscale, child: _image()),
              if (compact)
                Align(
                  alignment: Alignment.topLeft,
                  child: _CornerRibbon(text: banner, color: accentColor),
                )
              else ...[
                const ColoredBox(color: Color(0x99000000)),
                Center(child: _Banner(text: banner, color: accentColor)),
              ],
            ],
            ...overlays,
          ],
        ),
      ),
    );
  }

  Widget _image() {
    final placeholder = ColoredBox(
      color: const Color(0xFF0F1F1A),
      child: placeholderIcon == null
          ? null
          : Center(
        child: Icon(placeholderIcon, color: const Color(0xFF26322D), size: 48),
      ),
    );
    final link = url;
    if (link == null) return placeholder;
    return Image.network(
      link,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stack) => placeholder,
    );
  }
}

class _Banner extends StatelessWidget {
  final String text;
  final Color color;
  const _Banner({required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xCC0B1512),
        border: Border.symmetric(
          horizontal: BorderSide(color: color, width: 2),
        ),
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w800,
          letterSpacing: 1.5,
        ),
      ),
    );
  }
}

// Diagonal ribbon across the top-left corner (used on small posters)
class _CornerRibbon extends StatelessWidget {
  final String text;
  final Color color;
  const _CornerRibbon({required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, c) {
        final leg = c.maxWidth * 0.75; // size of the corner it covers
        final center = leg * 0.36;
        final bandW = leg * 1.6;
        final bandH = leg * 0.24;
        return SizedBox(
          width: leg,
          height: leg,
          child: ClipRect(
            child: Stack(
              children: [
                Positioned(
                  left: center - bandW / 2,
                  top: center - bandH / 2,
                  child: Transform.rotate(
                    angle: -0.785398, // -45 degrees
                    child: Container(
                      width: bandW,
                      height: bandH,
                      alignment: Alignment.center,
                      padding: EdgeInsets.symmetric(horizontal: leg * 0.4),
                      decoration: BoxDecoration(
                        color: const Color(0xCC0B1512),
                        border: Border.symmetric(
                          horizontal: BorderSide(color: color, width: 1.5),
                        ),
                      ),
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          text,
                          style: TextStyle(
                            color: color,
                            fontSize: 9,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}