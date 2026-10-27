import 'package:flutter/material.dart';
import 'package:movixapp/core/constants/app_colors.dart';

class AppToggleSwitch extends StatelessWidget {
  const AppToggleSwitch({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final bool value;
  final ValueChanged<bool> onChanged;

  static const double _width = 32.5;
  static const double _height = 17.84;
  static const double _knob = 12.5;
  static const double _padding = (_height - _knob) / 2;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        width: _width,
        height: _height,
        decoration: BoxDecoration(
          color: value ? AppColors.primary : Color(0xFF78958E).withOpacity(0.4),
          borderRadius: BorderRadius.circular(_height),
        ),
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          alignment: value ? Alignment.centerRight : Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: _padding),
            child: Container(
              width: _knob,
              height: _knob,
              decoration: const BoxDecoration(
                color: Color(0xFF061614),
                shape: BoxShape.circle,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
