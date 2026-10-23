import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:movixapp/Widgets/custom_text.dart';
import 'package:movixapp/core/constants/app_colors.dart';

class CustomTextfield extends StatefulWidget {
  const CustomTextfield({
    super.key,
    required this.hint,
    required this.isPass,
    required this.controller,
    required this.textFieldName,
    this.keyboard,
    this.validator,
    this.onChanged,
    this.textInputAction,
    this.icon,
  });

  final String hint;
  final bool isPass;
  final TextEditingController controller;
  final TextInputType? keyboard;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final TextInputAction? textInputAction;
  final IconData? icon;
  final String textFieldName;

  @override
  State<CustomTextfield> createState() => _CustomTextfieldState();
}

class _CustomTextfieldState extends State<CustomTextfield> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.isPass;
  }

  @override
  void didUpdateWidget(covariant CustomTextfield oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isPass != widget.isPass) {
      _obscureText = widget.isPass;
    }
  }

  void _togglePasswordVisibility() {
    setState(() => _obscureText = !_obscureText);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: widget.textFieldName,
          size: 20,
          color: AppColors.secondary,
          weight: FontWeight.w500,
        ),
        Gap(12),
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: TextFormField(
            onChanged: widget.onChanged,
            textInputAction: widget.textInputAction,
            maxLines: 1,
            style: const TextStyle(color: AppColors.secondary),
            keyboardType: widget.isPass
                ? TextInputType.visiblePassword
                : widget.keyboard,
            controller: widget.controller,
            cursorColor: AppColors.primary,
            cursorHeight: 20,
            validator: widget.validator,
            obscureText: _obscureText,
            decoration: InputDecoration(
              prefixIcon: widget.icon != null
                  ? SizedBox(
                      width: 48,
                      height: 48,
                      child: Icon(
                        widget.icon,
                        color: AppColors.secondary,
                        size: 22,
                      ),
                    )
                  : null,
              suffixIcon: widget.isPass
                  ? IconButton(
                      onPressed: _togglePasswordVisibility,
                      tooltip: _obscureText ? 'Show password' : 'Hide password',
                      icon: Icon(
                        _obscureText
                            ? CupertinoIcons.eye_slash_fill
                            : CupertinoIcons.eye_fill,
                        color: AppColors.secondary,
                      ),
                    )
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: AppColors.primary, width: 1),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: AppColors.background, width: 1.5),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: AppColors.primary, width: 2),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(
                  color: AppColors.error,
                  width: 1.5,
                ),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: AppColors.error, width: 2),
              ),
              labelText: widget.textFieldName,
              hintText: widget.hint,
              labelStyle: TextStyle(color: AppColors.secondary, fontSize: 18),
              hintStyle: TextStyle(color: AppColors.secondary.withOpacity(0.6)),
              fillColor: AppColors.InputFiledBackground,
              filled: true,
            ),
          ),
        ),
      ],
    );
  }
}
