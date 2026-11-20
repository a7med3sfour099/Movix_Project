import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'home_header.dart';

class SearchBarField extends StatelessWidget {
  final String hint;
  final ValueChanged<String> onChanged;
  final ValueChanged<String> onSubmitted;
  final TextEditingController? controller;

  // Automatically focuses the field and opens the keyboard.
  final bool autofocus;
// Opens the Search screen when tapped instead of allowing text input.
  final bool readOnly;
  final VoidCallback? onTap;

  const SearchBarField({
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
      cursorColor: HomeHeader.greenColor,
      style: const TextStyle(color: Colors.white, fontSize: 15),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Color(0xFF7C8B85), fontSize: 15),
        prefixIcon: const Icon(
          Symbols.search,
          color: Color(0xFF7C8B85),
          weight: 200,
        ),
        filled: true,
        fillColor: HomeHeader.darkColor,
        contentPadding: const EdgeInsets.symmetric(vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}