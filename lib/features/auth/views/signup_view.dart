import 'package:flutter/material.dart';
import 'package:movixapp/core/constants/app_colors.dart';
import 'package:movixapp/core/utils/email_validator.dart';
import 'package:movixapp/features/auth/widgets/custom_auth_appbar.dart';
import 'package:movixapp/Widgets/custom_text.dart';
import 'package:movixapp/Widgets/custom_text_field.dart';
import 'package:gap/gap.dart';
import 'package:movixapp/features/auth/widgets/password_req.dart';
import 'package:movixapp/Widgets/custom_elevated_button.dart';
import 'package:movixapp/Widgets/custom_text_button.dart';
import 'package:movixapp/features/auth/widgets/custom_snackbar.dart';
import 'package:movixapp/features/auth/views/login_view.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movixapp/features/auth/cubit/signup/auth_cubit.dart';
import 'package:movixapp/features/auth/cubit/signup/auth_state.dart';
import 'package:movixapp/features/auth/cubit/signup/signup_password_cubit.dart';
import 'package:movixapp/features/auth/cubit/signup/signup_form_cubit.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class SignupView extends StatelessWidget {
  const SignupView({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>(create: (context) => AuthCubit()),
        BlocProvider<SignupPasswordCubit>(
          create: (context) => SignupPasswordCubit(),
        ),
        BlocProvider<SignupFormCubit>(create: (context) => SignupFormCubit()),
      ],
      child: Builder(
        builder: (context) {
          final formCubit = context.read<SignupFormCubit>();
          return Scaffold(
            resizeToAvoidBottomInset: true,
            backgroundColor: AppColors.background,
            appBar: CustomAppbar(
              title: "Create Account",
              back: true,
              onPressed: () {
                Navigator.pop(context);
              },
            ),
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
                      scrollDirection: Axis.vertical,
                      child: Form(
                        key: formCubit.formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomTextfield(
                              hint: "Enter your name",
                              isPass: false,
                              controller: formCubit.nameController,
                              icon: Icons.person_2_outlined,
                              textFieldName: 'Name',
                              validator: (value) {
                                if (value == null || value.trim().isEmpty)
                                  return "Name is required";
                                if (value.trim().length < 3)
                                  return 'Name too short';
                                if (RegExp(r'^[0-9]').hasMatch(value.trim()))
                                  return 'Name cannot start with number';
                                return null;
                              },
                            ),
                            Gap((2.h).clamp(12.0, 20.0)),
                            CustomTextfield(
                              hint: "example@example",
                              isPass: false,
                              controller: formCubit.emailController,
                              icon: Icons.email_outlined,
                              textFieldName: 'Email',
                              validator: validateEmail,
                            ),
                            Gap((2.h).clamp(12.0, 20.0)),
                            CustomTextfield(
                              hint: "Enter your Password",
                              isPass: true,
                              controller: formCubit.passwordController,
                              icon: Icons.lock_outlined,
                              textFieldName: 'Password',
                              validator: validateStrongPassword,
                              onChanged: (value) {
                                context
                                    .read<SignupPasswordCubit>()
                                    .passwordChanged(
                                      password: value,
                                      confirmPassword: formCubit
                                          .confirmPasswordController
                                          .text,
                                    );
                              },
                            ),

                            BlocBuilder<SignupPasswordCubit, int>(
                              builder: (context, state) {
                                final cubit = context
                                    .read<SignupPasswordCubit>();
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    PasswordRequirement(
                                      text: "At least 8 characters",
                                      isChecked: cubit.password.length >= 8,
                                    ),

                                    PasswordRequirement(
                                      text: "At least one uppercase letter",
                                      isChecked: RegExp(r'[A-Z]')
                                          .hasMatch(cubit.password),
                                    ),

                                    PasswordRequirement(
                                      text: "At least one lowercase letter",
                                      isChecked: RegExp(r'[a-z]')
                                          .hasMatch(cubit.password),
                                    ),

                                    PasswordRequirement(
                                      text: "At least one number and one special character",
                                      isChecked:
                                          RegExp(r'[0-9]')
                                              .hasMatch(cubit.password) &&
                                          RegExp(r'[^a-zA-Z0-9]')
                                              .hasMatch(cubit.password),
                                    ),
                                  ],
                                );
                              },
                            ),
                            Gap((2.h).clamp(12.0, 20.0)),
                            CustomTextfield(
                              hint: "Password Confirmation",
                              isPass: true,
                              controller: formCubit.confirmPasswordController,
                              icon: Icons.lock_outlined,
                              textFieldName: 'Confirm your password',
                              onChanged: (value) {
                                context
                                    .read<SignupPasswordCubit>()
                                    .passwordChanged(
                                      password:
                                          formCubit.passwordController.text,
                                      confirmPassword: value,
                                    );
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Please confirm your password";
                                }

                                if (value !=
                                    formCubit.passwordController.text) {
                                  return "Passwords do not match";
                                }

                                return null;
                              },
                            ),
                            BlocBuilder<SignupPasswordCubit, int>(
                              builder: (context, state) {
                                final cubit = context
                                    .read<SignupPasswordCubit>();
                                return PasswordRequirement(
                                  text: "Password must match",
                                  isChecked:
                                      cubit.confirmPassword.isNotEmpty &&
                                      cubit.password == cubit.confirmPassword,
                                );
                              },
                            ),
                            Gap((2.5.h).clamp(12.0, 20.0)),
                            BlocConsumer<AuthCubit, AuthState>(
                              listener: (context, state) {
                                if (state is AuthSuccess) {
                                  showCustomSnackBar(
                                    context,
                                    message: "Account created successfully!",
                                  );
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const LoginView(),
                                    ),
                                  );
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
                                    if (formCubit.formKey.currentState!
                                        .validate()) {
                                      context.read<AuthCubit>().signUp(
                                        userName: formCubit.nameController.text,
                                        email: formCubit.emailController.text,
                                        password:
                                            formCubit.passwordController.text,
                                      );
                                    }
                                  },
                                );
                              },
                            ),
                            Gap((2.h).clamp(12.0, 20.0)),
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
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const LoginView(),
                                        ),
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
        },
      ),
    );
  }
}
