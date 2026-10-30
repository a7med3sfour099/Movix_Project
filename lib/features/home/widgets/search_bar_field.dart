import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'home_header.dart';

class SearchBarField extends StatelessWidget {
  final String hint;
  final ValueChanged<String> onChanged;
  final ValueChanged<String> onSubmitted;

  const SearchBarField({
    super.key,
    required this.hint,
    required this.onChanged,
    required this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onChanged,
      onSubmitted: onSubmitted,
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
