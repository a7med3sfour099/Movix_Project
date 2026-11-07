import 'package:flutter/material.dart';
import 'package:movixapp/core/constants/app_colors.dart';
import 'package:movixapp/core/utils/auth_validators.dart';
import 'package:movixapp/features/auth/widgets/custom_auth_appbar.dart';
import 'package:movixapp/Widgets/custom_text.dart';
import 'package:movixapp/Widgets/custom_text_field.dart';
import 'package:gap/gap.dart';
import 'package:movixapp/features/auth/widgets/password_check_list.dart';
import 'package:movixapp/features/auth/widgets/password_req.dart';
import 'package:movixapp/Widgets/custom_elevated_button.dart';
import 'package:movixapp/Widgets/custom_text_button.dart';
import 'package:movixapp/features/auth/widgets/custom_snackbar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movixapp/features/auth/cubit/auth_cubit.dart';
import 'package:movixapp/features/auth/cubit/auth_state.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class SignupView extends StatelessWidget {
  const SignupView({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AuthCubit>();
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: AppColors.background,
      appBar: CustomAppbar(title: "Create Account", back: false),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 4.w.clamp(12.0, 24.0),
                vertical: 2.h.clamp(12.0, 24.0),
              ),
              child: SingleChildScrollView(
                child: Form(
                  key: cubit.signupFormKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// Name field
                      CustomTextfield(
                        hint: "Enter your name",
                        isPass: false,
                        controller: cubit.nameController,
                        icon: Icons.person_2_outlined,
                        textFieldName: 'Name',
                        validator: AuthValidators.validateName,
                      ),
                      Gap((2.h).clamp(12.0, 20.0)),

                      /// Email field
                      CustomTextfield(
                        hint: "example@example",
                        isPass: false,
                        controller: cubit.signupEmailController,
                        icon: Icons.email_outlined,
                        textFieldName: 'Email',
                        validator: AuthValidators.validateEmail,
                      ),
                      Gap((2.h).clamp(12.0, 20.0)),

                      /// Password field
                      CustomTextfield(
                        hint: "Enter your Password",
                        isPass: true,
                        controller: cubit.passwordController,
                        icon: Icons.lock_outlined,
                        textFieldName: 'Password',
                        validator: AuthValidators.validateStrongPassword,
                        onChanged: (value) {
                          context.read<AuthCubit>().updatePasswordFields(
                            password: value,
                            confirmPassword:
                                cubit.confirmPasswordController.text,
                          );
                        },
                      ),
                      Gap((1.h).clamp(8.0, 16.0)),

                      /// Password checklist
                      BlocBuilder<AuthCubit, AuthState>(
                        builder: (context, state) {
                          final cubit = context.read<AuthCubit>();
                          return PasswordChecklist(
                            password: cubit.passwordController.text,
                          );
                        },
                      ),
                      Gap((2.h).clamp(12.0, 20.0)),

                      /// Confirm password field
                      CustomTextfield(
                        hint: "Password Confirmation",
                        isPass: true,
                        controller: cubit.confirmPasswordController,
                        icon: Icons.lock_outlined,
                        textFieldName: 'Confirm your password',
                        onChanged: (value) {
                          context.read<AuthCubit>().updatePasswordFields(
                            password: cubit.passwordController.text,
                            confirmPassword: value,
                          );
                        },
                        validator: (value) {
                          return AuthValidators.validateConfirmPassword(
                            value,
                            cubit.confirmPasswordController.text,
                          );
                        },
                      ),

                      /// Password match checklist
                      BlocBuilder<AuthCubit, AuthState>(
                        builder: (context, state) {
                          return PasswordRequirement(
                            text: "Password must match",
                            isChecked:
                                cubit
                                    .confirmPasswordController
                                    .text
                                    .isNotEmpty &&
                                cubit.passwordController.text ==
                                    cubit.confirmPasswordController.text,
                          );
                        },
                      ),
                      Gap((2.5.h).clamp(12.0, 20.0)),

                      /// Sign up button
                      BlocConsumer<AuthCubit, AuthState>(
                        listener: (context, state) {
                          if (state is AuthSignupSuccess) {
                            showCustomSnackBar(
                              context,
                              message:
                                  "Account created! Please check your email to verify your account.",
                            );
                            final email =cubit.signupEmailController.text.trim();
                            cubit.clearControllers(clearLoginEmail: false);
                            cubit.loginEmailController.text = email;
                            Navigator.pushReplacementNamed(context, '/login');
                          }

                          if (state is AuthFailure) {
                            showCustomSnackBar(
                              context,
                              message: state.message,
                              isError: true,
                            );
                          }
                        },
                        builder: (context, state) {
                          return CustomElevatedbutton(
                            text: "Create Account",
                            isLoading: state is AuthLoading,
                            onPressed: () {
                              if (cubit.signupFormKey.currentState!
                                  .validate()) {
                                context.read<AuthCubit>().signUp(
                                  userName: cubit.nameController.text,
                                  email: cubit.signupEmailController.text,
                                  password: cubit.passwordController.text,
                                );
                              }
                            },
                          );
                        },
                      ),
                      Gap((2.h).clamp(12.0, 20.0)),

                      /// Convert to Login button
                      Center(
                        child: Wrap(
                          alignment: WrapAlignment.center,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          spacing: 4,
                          children: [
                            CustomText(text: "Already have an account?"),
                            CustomTextButton(
                              text: "Login",
                              color: AppColors.primary,
                              size: 16,
                              weight: FontWeight.normal,
                              onPressed: () {
                                Navigator.pushReplacementNamed(
                                  context,
                                  '/login',
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
