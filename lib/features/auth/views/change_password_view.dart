import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movixapp/core/constants/app_colors.dart';
import 'package:movixapp/core/utils/email_validator.dart';
import 'package:movixapp/features/auth/views/forget_password.dart';
import 'package:movixapp/features/auth/widgets/custom_auth_appbar.dart';
import 'package:movixapp/Widgets/custom_text.dart';
import 'package:movixapp/Widgets/custom_text_field.dart';
import 'package:gap/gap.dart';
import 'package:movixapp/features/auth/widgets/password_req.dart';
import 'package:movixapp/Widgets/custom_elevated_button.dart';
import 'package:movixapp/Widgets/custom_text_button.dart';
import 'package:movixapp/features/auth/widgets/custom_snackbar.dart';
import 'package:movixapp/features/auth/views/login_view.dart';
import 'package:movixapp/features/auth/cubit/change_password/change_password_cubit.dart';
import 'package:movixapp/features/auth/cubit/change_password/change_password_state.dart';

class changePassword extends StatelessWidget {
  changePassword({super.key});
  final _formKey = GlobalKey<FormState>();
  final currentPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  void _submit(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      context.read<ChangePasswordCubit>().changePassword(
        currentPassword: currentPasswordController.text,
        newPassword: newPasswordController.text,
      );
    }
  }

  void _clearFields() {
    currentPasswordController.clear();
    newPasswordController.clear();
    confirmPasswordController.clear();
    _formKey.currentState?.reset();

  }
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ChangePasswordCubit(),
      child: Builder(
        builder: (context) {
          return Scaffold(
          backgroundColor: AppColors.background,
          appBar: const CustomAppbar(
            title: "Change Password",
            back: true,
          ),
          body: Padding(
            padding: const EdgeInsets.all(15),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomTextfield(
                      hint: "Enter your Password",
                      isPass: true,
                      controller: currentPasswordController,
                      icon: Icons.lock_outlined,
                      textFieldName: "Current Password",
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "Please enter your current password";
                        }
                        return null;
                      },
                    ),
                    const Gap(15),
                    Row(
                      children: [
                        Spacer(),
                        InkWell(
                          onTap: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const ForgetPassword(),
                                ),
                              );
                          },
                          child: const CustomText(
                            text: 'Forgot Password?',
                            size: 12,
                            color: AppColors.primary,
                            weight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const Gap(15),
                     CustomTextfield(
                      hint: "Create your Password",
                      isPass: true,
                      controller: newPasswordController,
                      icon: Icons.lock_outlined,
                      textFieldName: "New Password",
                      validator: validateStrongPassword,
                      onChanged: (value) {
  context.read<ChangePasswordCubit>().updatePasswordRequirements();

                      },
                    ),
                    const Gap(15),
                    //  PasswordRequirement(
                    //   text: "At least 8 characters",
                    //   isChecked: newPasswordController.text.length >= 8,
                    // ),
                    //  PasswordRequirement(
                    //   text: "At least one uppercase letter",
                    //   isChecked:
                    //   RegExp(r'[A-Z]').hasMatch(newPasswordController.text),
                    // ),
                    //  PasswordRequirement(
                    //   text: "At least one lowercase letter",
                    //   isChecked:
                    //   RegExp(r'[a-z]').hasMatch(newPasswordController.text),
                    // ),
                    // PasswordRequirement(
                    //   text: "At least one number and one special character",
                    //   isChecked:
                    //   RegExp(r'[0-9]').hasMatch(newPasswordController.text) &&
                    //       RegExp(r'[^a-zA-Z0-9]')
                    //           .hasMatch(newPasswordController.text),
                    // ),
                    BlocBuilder<ChangePasswordCubit, ChangePasswordState>(
  builder: (context, state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PasswordRequirement(
          text: "At least 8 characters",
          isChecked: newPasswordController.text.length >= 8,
        ),
        PasswordRequirement(
          text: "At least one uppercase letter",
          isChecked:
              RegExp(r'[A-Z]').hasMatch(newPasswordController.text),
        ),
        PasswordRequirement(
          text: "At least one lowercase letter",
          isChecked:
              RegExp(r'[a-z]').hasMatch(newPasswordController.text),
        ),
        PasswordRequirement(
          text: "At least one number and one special character",
          isChecked:
              RegExp(r'[0-9]').hasMatch(newPasswordController.text) &&
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
                      onChanged: (value) {
  context.read<ChangePasswordCubit>().updatePasswordRequirements();

                      },
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
                    //  PasswordRequirement(
                    //   text: "Password must match",
                    //   isChecked: confirmPasswordController.text.isNotEmpty &&
                    //       confirmPasswordController.text ==
                    //           newPasswordController.text,
                    // ),
                    BlocBuilder<ChangePasswordCubit, ChangePasswordState>(
  builder: (context, state) {
    return PasswordRequirement(
      text: "Password must match",
      isChecked: confirmPasswordController.text.isNotEmpty &&
          confirmPasswordController.text == newPasswordController.text,
    );
  },
),
                    const Gap(20),
                     BlocConsumer<ChangePasswordCubit, ChangePasswordState>(
                      listener: (context, state) {
                        if (state is ChangePasswordSuccess) {
                          showCustomSnackBar(
                            context,
                            message: "Password changed successfully!",
                          );
                          _clearFields();
                        } else if (state is ChangePasswordFailure) {
                          showCustomSnackBar(context, message: state.message);
                        }
                      },
                      builder: (context, state) {
                        return CustomElevatedbutton(
                          isLoading: state is ChangePasswordLoading,
                          text: "Change Password",
                          size: 16,
                          onPressed:()=> _submit(context),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
              );
        }
      )
    );
  }
}


