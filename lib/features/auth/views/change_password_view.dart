import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movixapp/core/constants/app_colors.dart';
import 'package:movixapp/core/utils/auth_validators.dart';
import 'package:movixapp/features/auth/widgets/custom_auth_appbar.dart';
import 'package:movixapp/Widgets/custom_text.dart';
import 'package:movixapp/Widgets/custom_text_field.dart';
import 'package:gap/gap.dart';
import 'package:movixapp/features/auth/widgets/password_check_list.dart';
import 'package:movixapp/features/auth/widgets/password_req.dart';
import 'package:movixapp/Widgets/custom_elevated_button.dart';
import 'package:movixapp/features/auth/widgets/custom_snackbar.dart';
import 'package:movixapp/features/auth/cubit/change_password_cubit.dart';
import 'package:movixapp/features/auth/cubit/change_password_state.dart';

class ChangePassword extends StatelessWidget {
  const ChangePassword({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ChangePasswordCubit>();
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: AppColors.background,
      appBar: CustomAppbar(
        title: "Change Password",
        back: true,
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: SingleChildScrollView(
            child: Form(
              key: cubit.formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Current Password field
                  CustomTextfield(
                    hint: "Enter your Password",
                    isPass: true,
                    controller: cubit.currentPasswordController,
                    icon: Icons.lock_outlined,
                    textFieldName: "Current Password",
                    validator: AuthValidators.validateCurrentPassword,
                  ),
                  const Gap(15),

                  /// Forget Password button
                  Row(
                    children: [
                      Spacer(),
                      InkWell(
                        onTap: () {
                          cubit.clearControllers();
                          Navigator.pushNamed(context, '/forget-password');
                        },
                        child: const CustomText(
                          text: 'Forget Password?',
                          size: 12,
                          color: AppColors.primary,
                          weight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const Gap(15),

                  /// New Password field
                  CustomTextfield(
                    hint: "Create New Password",
                    isPass: true,
                    controller: cubit.newPasswordController,
                    icon: Icons.lock_outlined,
                    textFieldName: "New Password",
                    validator: AuthValidators.validateStrongPassword,
                    onChanged: (_) => cubit.onPasswordChanged(),
                  ),
                  const Gap(10),

                  /// Password Requirements list
                  BlocBuilder<ChangePasswordCubit, ChangePasswordState>(
                    builder: (context, state) {
                      final cubit = context.read<ChangePasswordCubit>();
                      return PasswordChecklist(
                        password: cubit.newPasswordController.text,
                      );
                    },
                  ),
                  const Gap(15),

                  /// Confirm Password field
                  CustomTextfield(
                    hint: "Password Confirmation",
                    isPass: true,
                    controller: cubit.confirmPasswordController,
                    icon: Icons.lock_outlined,
                    textFieldName: 'Confirm your Password',
                    onChanged: (_) => cubit.onPasswordChanged(),
                    validator: (value) {
                      return AuthValidators.validateConfirmPassword(
                        value,
                        cubit.newPasswordController.text,
                      );
                    },
                  ),
                  BlocBuilder<ChangePasswordCubit, ChangePasswordState>(
                    builder: (context, state) {
                      return PasswordRequirement(
                        text: "Password must match",
                        isChecked:
                            cubit.confirmPasswordController.text.isNotEmpty &&
                            cubit.newPasswordController.text ==
                                cubit.confirmPasswordController.text,
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
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          '/setting',
                          (_) => false,
                        );
                      } else if (state is ChangePasswordFailure) {
                        showCustomSnackBar(
                          context,
                          message: state.message,
                          isError: true,
                        );
                      }
                    },
                    builder: (context, state) {
                      return CustomElevatedbutton(
                        isLoading: state is ChangePasswordLoading,
                        text: "Change Password",
                        size: 16,
                        onPressed: () {
                          if (cubit.formKey.currentState!.validate()) {
                            context.read<ChangePasswordCubit>().changePassword(
                              currentPassword:
                                  cubit.currentPasswordController.text,
                              newPassword: cubit.newPasswordController.text,
                            );
                          }
                        },
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
  }
}
