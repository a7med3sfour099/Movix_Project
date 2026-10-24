import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SvgImage extends StatelessWidget {
  const SvgImage({super.key, required this.path, this.color, this.size });

  final String path;
  final Color? color;
  final double? size;
  
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SvgPicture.asset(
        path,
        fit: BoxFit.cover,
        colorFilter: color != null
            ? ColorFilter.mode(color!, BlendMode.srcIn)
            : null,
        height: size,
        width: size,
      ),
    );
  }
}
