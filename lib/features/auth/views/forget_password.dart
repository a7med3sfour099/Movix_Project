import 'package:flutter/material.dart';
import 'package:movixapp/core/constants/app_colors.dart';
import 'package:movixapp/core/utils/email_validator.dart';
import 'package:movixapp/features/auth/widgets/custom_auth_appbar.dart';
import 'package:movixapp/Widgets/custom_text.dart';
import 'package:movixapp/Widgets/custom_text_field.dart';
import 'package:gap/gap.dart';
import 'package:movixapp/Widgets/custom_elevated_button.dart';
import 'package:movixapp/features/auth/widgets/custom_snackbar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movixapp/features/auth/cubit/forget_password_cubit.dart';

class ForgetPassword extends StatelessWidget {
  const ForgetPassword({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ForgetPasswordCubit(),
      child: Builder(
        builder: (context) {
          final cubit = context.read<ForgetPasswordCubit>();
          return Scaffold(
            backgroundColor: AppColors.background,
            appBar: CustomAppbar(
              title: "Password Reset",
              back: true,
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            body: Padding(
              padding: EdgeInsets.all(15),
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Form(
                  key: cubit.formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomTextfield(
                        hint: "Enter your email",
                        isPass: false,
                        controller: cubit.emailController,
                        icon: Icons.email_outlined,
                        textFieldName: 'Email',
                        validator: validateEmail,
                      ),
                      Gap(12),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: CustomText(
                          text: "We will send to you email to reset your password",
                          color: AppColors.secondary,
                          size: 12,
                        ),
                      ),
                      Gap(20),
                      BlocConsumer<ForgetPasswordCubit, ForgetPasswordState>(
                        listener: (context, state) {
                          if (state is ForgetPasswordSuccess) {
                            showCustomSnackBar(
                              context,
                              message: "If an account exists with this email, you'll receive a password reset link shortly. Please check your inbox.",
                            );
                          }

                          if (state is ForgetPasswordFailure) {
                            showCustomSnackBar(
                              context,
                              message: state.message,
                              isError: true,
                            );
                          }
                        },
                        builder: (context, state) {
                          return CustomElevatedbutton(
                            text: "Reset Password",
                            size: 16,
                            isLoading: state is ForgetPasswordLoading,
                            onPressed: () {
                              if (cubit.formKey.currentState!.validate()) {
                                cubit.resetPassword();
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
          );
        },
      ),
    );
  }
}
