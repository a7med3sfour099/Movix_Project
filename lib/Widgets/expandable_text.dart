import 'package:flutter/material.dart';
import 'package:movixapp/features/home/widgets/home_header.dart';

// Shows a shortened text with a Read More option when needed.
class ExpandableText extends StatefulWidget {
  final String text;
  final int collapsedLines;

  const ExpandableText({super.key, required this.text, this.collapsedLines = 6});

  @override
  State<ExpandableText> createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<ExpandableText> {
  bool _expanded = false;

  static const _style = TextStyle(
    color: Color(0xFFB4C2BC),
    fontSize: 16,
    height: 1.7,
  );

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final painter = TextPainter(
          text: TextSpan(text: widget.text, style: _style),
          maxLines: widget.collapsedLines,
          textDirection: TextDirection.ltr,
        )..layout(maxWidth: constraints.maxWidth);
        final overflows = painter.didExceedMaxLines;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AnimatedSize(
              duration: const Duration(milliseconds: 200),
              alignment: Alignment.topCenter,
              child: Text(
                widget.text,
                style: _style,
                maxLines: _expanded ? null : widget.collapsedLines,
                overflow: _expanded ? TextOverflow.visible : TextOverflow.ellipsis,
              ),
            ),
            if (overflows) ...[
              const SizedBox(height: 10),
              InkWell(
                onTap: () => setState(() => _expanded = !_expanded),
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                  decoration: BoxDecoration(
                    color: HomeHeader.darkColor,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFF1E2E29)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _expanded ? 'Show Less' : 'Read More',
                        style: const TextStyle(
                          color: HomeHeader.greenColor,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Icon(
                        _expanded ? Icons.expand_less : Icons.expand_more,
                        color: HomeHeader.greenColor,
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        );
      },
    );
  }
}
