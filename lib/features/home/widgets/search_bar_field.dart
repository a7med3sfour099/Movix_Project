import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:movixapp/core/constants/app_colors.dart';

/// How long every search in the app waits after the last typed letter
/// before it starts searching. Change it here to change it everywhere.
const searchDelay = Duration(seconds: 3);

class CustomSearchBar extends StatelessWidget {
  final String hint;
  final ValueChanged<String> onChanged;
  final ValueChanged<String> onSubmitted;
  final TextEditingController? controller;

  final bool autofocus;
// Opens the Search screen when tapped instead of allowing text input.
  final bool readOnly;
  final VoidCallback? onTap;

  const CustomSearchBar({
    super.key,
    required this.hint,
    required this.onChanged,
    required this.onSubmitted,
    this.controller,
    this.autofocus = false,
    this.readOnly = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      autofocus: autofocus,
      readOnly: readOnly,
      onTap: onTap,
      // No cursor / selection handles on the Home bar, it is only a button
      showCursor: !readOnly,
      enableInteractiveSelection: !readOnly,
      textInputAction: TextInputAction.search,
      cursorColor: AppColors.primary,
      style: const TextStyle(color: Colors.white, fontSize: 15),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: AppColors.tertiary, fontSize: 15),
        prefixIcon: const Icon(
          Symbols.search,
          color: AppColors.tertiary,
          weight: 200,
        ),
        filled: true,
        fillColor: AppColors.quaternary,
        contentPadding: const EdgeInsets.symmetric(vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}