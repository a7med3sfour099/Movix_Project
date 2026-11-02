import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:movixapp/Widgets/custom_text.dart';
import 'package:movixapp/core/constants/app_colors.dart';

class CustomTextfield extends StatelessWidget {
  CustomTextfield({
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
  }) : _obscureText = ValueNotifier<bool>(isPass);

  final String hint;
  final bool isPass;
  final TextEditingController controller;
  final TextInputType? keyboard;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final TextInputAction? textInputAction;
  final IconData? icon;
  final String textFieldName;

  final ValueNotifier<bool> _obscureText;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: textFieldName,
          size: 20,
          color: AppColors.secondary,
          weight: FontWeight.w500,
        ),
        const Gap(12),
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: ValueListenableBuilder<bool>(
            valueListenable: _obscureText,
            builder: (context, obscureText, child) {
              return TextFormField(
                onChanged: onChanged,
                textInputAction: textInputAction,
                maxLines: 1,
                style: const TextStyle(color: AppColors.secondary),
                keyboardType: isPass
                    ? TextInputType.visiblePassword
                    : keyboard,
                controller: controller,
                cursorColor: AppColors.primary,
                cursorHeight: 20,
                validator: validator,
                obscureText: obscureText,
                decoration: InputDecoration(
                  prefixIcon: icon != null
                      ? SizedBox(
                          width: 48,
                          height: 48,
                          child: Icon(
                            icon,
                            color: AppColors.secondary,
                            size: 22,
                          ),
                        )
                      : null,
                  suffixIcon: isPass
                      ? IconButton(
                          onPressed: () {
                            _obscureText.value = !_obscureText.value;
                          },
                          tooltip: obscureText ? 'Show password' : 'Hide password',
                          icon: Icon(
                            obscureText
                                ? CupertinoIcons.eye_slash_fill
                                : CupertinoIcons.eye_fill,
                            color: AppColors.secondary,
                          ),
                        )
                      : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: AppColors.primary,
                      width: 1,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: AppColors.background,
                      width: 1.5,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: AppColors.primary,
                      width: 2,
                    ),
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
                    borderSide: const BorderSide(
                      color: AppColors.error,
                      width: 2,
                    ),
                  ),
                  hintText: hint,
                  labelStyle: const TextStyle(
                    color: AppColors.secondary,
                    fontSize: 18,
                  ),
                  hintStyle: TextStyle(
                    color: AppColors.secondary.withOpacity(0.6),
                  ),
                  fillColor: AppColors.InputFiledBackground,
                  filled: true,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}