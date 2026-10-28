import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movixapp/core/constants/app_colors.dart';
import 'package:movixapp/core/services/app_navigation_service.dart';
import 'package:movixapp/core/utils/email_validator.dart';
import 'package:movixapp/features/auth/cubit/reset_password_cubit.dart';
import 'package:movixapp/features/auth/widgets/custom_auth_appbar.dart';
import 'package:movixapp/Widgets/custom_text_field.dart';
import 'package:gap/gap.dart';
import 'package:movixapp/features/auth/widgets/password_req.dart';
import 'package:movixapp/Widgets/custom_elevated_button.dart';
import 'package:movixapp/features/auth/widgets/custom_snackbar.dart';

class ResetPassword extends StatelessWidget {
  ResetPassword({super.key, required this.oobCode});
  final String oobCode;
  final _formKey = GlobalKey<FormState>();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  void _submit(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      context.read<ResetPasswordCubit>().resetPassword(
        newPassword: newPasswordController.text,
      );
    }
  }

  void _clearFields() {
    newPasswordController.clear();
    confirmPasswordController.clear();
    _formKey.currentState?.reset();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ResetPasswordCubit(oobCode: oobCode),
      child: Builder(
        builder: (context) {
          return Scaffold(
            backgroundColor: AppColors.background,
            appBar: CustomAppbar(title: "Reset Password", back: false),
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomTextfield(
                          hint: "Create New Password",
                          isPass: true,
                          controller: newPasswordController,
                          icon: Icons.lock_outlined,
                          textFieldName: "New Password",
                          validator: validateStrongPassword,
                          onChanged: (value) {},
                        ),
                        const Gap(15),
                        ValueListenableBuilder<TextEditingValue>(
                          valueListenable: newPasswordController,
                          builder: (context, value, _) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                PasswordRequirement(
                                  text: "At least 8 characters",
                                  isChecked:
                                      newPasswordController.text.length >= 8,
                                ),
                                PasswordRequirement(
                                  text: "At least one uppercase letter",
                                  isChecked: RegExp(r'[A-Z]')
                                      .hasMatch(newPasswordController.text),
                                ),
                                PasswordRequirement(
                                  text: "At least one lowercase letter",
                                  isChecked: RegExp(r'[a-z]')
                                      .hasMatch(newPasswordController.text),
                                ),
                                PasswordRequirement(
                                  text: "At least one number and one special character",
                                  isChecked:
                                      RegExp(
                                        r'[0-9]',
                                      ).hasMatch(newPasswordController.text) &&
                                      RegExp(r'[^a-zA-Z0-9]')
                                          .hasMatch(newPasswordController.text),
                                ),
                              ],
                            );
                          },
                        ),
                        const Gap(15),
                        CustomTextfield(
                          hint: "Password Confirmation",
                          isPass: true,
                          controller: confirmPasswordController,
                          icon: Icons.lock_outlined,
                          textFieldName: 'Confirm your Password',
                          onChanged: (value) {},
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return "Please confirm your password";
                            }
                            if (value != newPasswordController.text) {
                              return "Passwords do not match";
                            }
                            return null;
                          },
                        ),
                        ValueListenableBuilder(
                          valueListenable: confirmPasswordController,
                          builder: (context, value, _) {
                            return PasswordRequirement(
                              text: "Password must match",
                              isChecked:
                                  confirmPasswordController.text.isNotEmpty &&
                                  confirmPasswordController.text ==
                                      newPasswordController.text,
                            );
                          },
                        ),
                        const Gap(20),
                        BlocConsumer<ResetPasswordCubit, ResetPasswordState>(
                          listener: (context, state) async {
                            if (state is ResetPasswordSuccess) {
                              await AppNavigationService.instance
                                  .clearPasswordResetLink();
                              if (!context.mounted) return;
                              showCustomSnackBar(
                                context,
                                message: "Password Reset successfully!",
                              );
                              Navigator.pushNamedAndRemoveUntil(
                                context,
                                "/login",
                                (route) => false,
                              );
                              AppNavigationService.instance
                                  .clearPasswordResetLink();
                              _clearFields();
                            } else if (state is ResetPasswordFailure) {
                              showCustomSnackBar(
                                context,
                                message: state.message,
                              );
                            }
                          },
                          builder: (context, state) {
                            return CustomElevatedbutton(
                              isLoading: state is ResetPasswordLoading,
                              text: "Reset Password",
                              size: 16,
                              onPressed: () => _submit(context),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
