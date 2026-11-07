import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movixapp/core/constants/app_colors.dart';
import 'package:movixapp/core/services/app_navigation_service.dart';
import 'package:movixapp/core/utils/auth_validators.dart';
import 'package:movixapp/features/auth/cubit/forget_password_cubit.dart';
import 'package:movixapp/features/auth/cubit/forget_password_state.dart';
import 'package:movixapp/features/auth/cubit/reset_password_cubit.dart';
import 'package:movixapp/features/auth/widgets/custom_auth_appbar.dart';
import 'package:movixapp/Widgets/custom_text_field.dart';
import 'package:gap/gap.dart';
import 'package:movixapp/features/auth/widgets/password_check_list.dart';
import 'package:movixapp/features/auth/widgets/password_req.dart';
import 'package:movixapp/Widgets/custom_elevated_button.dart';
import 'package:movixapp/features/auth/widgets/custom_snackbar.dart';

class ResetPassword extends StatelessWidget {
  const ResetPassword({super.key, required this.oobCode});
  final String oobCode;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ResetPasswordCubit(oobCode: oobCode),
      child: const _ResetPasswordBody(),
    );
  }
}

class _ResetPasswordBody extends StatelessWidget {
  const _ResetPasswordBody();

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ResetPasswordCubit>();
          return Scaffold(
            resizeToAvoidBottomInset: true,
            backgroundColor: AppColors.background,
            appBar: CustomAppbar(
              title: "Reset Password",
              back: true,
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/login',
                  (route) => false,
                );
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
                        const Gap(15),

                        /// Password Requirements
                   BlocBuilder<ResetPasswordCubit, ForgetPasswordState>(
                    builder: (context, state) {
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

                        BlocBuilder<ResetPasswordCubit, ForgetPasswordState>(
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

                        /// Reset button
                        BlocConsumer<ResetPasswordCubit, ForgetPasswordState>(
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
                              cubit.clearControllers();
                            } else if (state is ResetPasswordFailure) {
                              showCustomSnackBar(
                                context,
                                message: state.message,
                                isError: true,
                              );
                            }
                          },
                          builder: (context, state) {
                            return CustomElevatedbutton(
                              isLoading: state is ResetPasswordLoading,
                              text: "Reset Password",
                              size: 16,
                              onPressed: () {
                          if (cubit.formKey.currentState!.validate()) {
                            cubit.resetPassword(
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
