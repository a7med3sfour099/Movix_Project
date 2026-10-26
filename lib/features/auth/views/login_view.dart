import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:movixapp/Widgets/custom_elevated_button.dart';
import 'package:movixapp/Widgets/custom_outlined_button.dart';
import 'package:movixapp/Widgets/custom_text.dart';
import 'package:movixapp/Widgets/custom_text_field.dart';
import 'package:movixapp/core/constants/app_colors.dart';
import 'package:movixapp/core/utils/email_validator.dart';
import 'package:movixapp/features/auth/views/forget_password.dart';
import 'package:movixapp/features/auth/views/signup_view.dart';
import 'package:movixapp/features/auth/widgets/custom_auth_appbar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movixapp/features/auth/cubit/signup/auth_cubit.dart';
import 'package:movixapp/features/auth/cubit/login_form_cubit.dart';
import 'package:movixapp/features/auth/cubit/signup/auth_state.dart';
import 'package:movixapp/features/auth/widgets/custom_snackbar.dart';
import 'package:movixapp/features/home/views/home_screen.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>(create: (_) => AuthCubit()),
        BlocProvider<LoginFormCubit>(create: (_) => LoginFormCubit()),
      ],
      child: Builder(
        builder: (context) {
          final formCubit = context.read<LoginFormCubit>();

          return GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Scaffold(
              resizeToAvoidBottomInset: false,
              backgroundColor: AppColors.background,
              appBar: CustomAppbar(title: 'Login'),
              body: SafeArea(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Form(
                      key: formCubit.formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Image.asset(
                              'assets/auth_assets/login_icon.png',
                              height: 161,
                              width: 161,
                            ),
                          ),
                          CustomTextfield(
                            textFieldName: 'Email',
                            hint: 'Enter your email',
                            isPass: false,
                            controller: formCubit.emailController,
                            keyboard: TextInputType.emailAddress,
                            validator: validateEmail,
                            icon: Icons.email_outlined,
                          ),
                          Gap(15),
                          CustomTextfield(
                            textFieldName: 'Password',
                            hint: 'Password',
                            isPass: true,
                            controller: formCubit.passController,
                            textInputAction: TextInputAction.done,
                            icon: Icons.lock_outlined,
                          ),
                          Gap(15),
                          Row(
                            children: [
                              Spacer(),
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const ForgetPassword(),
                                    ),
                                  );
                                },
                                child: CustomText(
                                  text: 'Forgot Password?',
                                  size: 16,
                                  color: AppColors.primary,
                                ),
                              ),
                            ],
                          ),
                          Gap(15),
                          BlocConsumer<AuthCubit, AuthState>(
                            listener: (context, state) {
                              if (state is AuthSuccess) {
                                showCustomSnackBar(
                                  context,
                                  message: "Login Successful!",
                                );
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const HomeScreen(),
                                  ),
                                  (route) => false,
                                );
                              }

                              if (state is AuthFailure) {
                                showCustomSnackBar(
                                  context,
                                  message: state.message,
                                );
                              }
                            },
                            builder: (context, state) {
                              return CustomElevatedbutton(
                                text: 'Login',
                                isLoading: state is AuthLoading,
                                onPressed: () {
                                  if (formCubit.formKey.currentState!
                                      .validate()) {
                                    context.read<AuthCubit>().login(
                                      email: formCubit.emailController.text
                                          .trim(),
                                      password: formCubit.passController.text,
                                    );
                                  }
                                },
                              );
                            },
                          ),
                          Gap(15),
                          CustomOutlinedButton(
                            imageUrl:
                                'assets/auth_assets/google-icon-logo-svg.svg',
                            text: 'Continue with Google',
                            onPressed: () {

    context.read<AuthCubit>().loginWithGoogle();
                            },
                          ),
                          Gap(15),
                          CustomOutlinedButton(
                            imageUrl: 'assets/auth_assets/facebook-svg.svg',
                            text: 'Continue with Facebook',
                            onPressed: () {
                              context.read<AuthCubit>().loginWithFacebook();
                            },
                          ),
                          Gap(15),
                          CustomOutlinedButton(
                            imageUrl: 'assets/auth_assets/twitter-x-svg.svg',
                            text: 'Continue with X',
                            onPressed: () {},
                          ),
                          Gap(15),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CustomText(
                                text: 'Don\'t have an account?',
                                size: 16,
                                color: AppColors.secondary,
                              ),
                              Gap(5),
                              InkWell(
                                onTap: () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const SignupView(),
                                    ),
                                  );
                                },
                                child: CustomText(
                                  text: 'Sign Up',
                                  size: 16,
                                  color: AppColors.primary,
                                ),
                              ),
                            ],
                          ),
                        ],
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
