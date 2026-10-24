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

class SignupView extends StatefulWidget {
  const SignupView({super.key});
  @override
  State<SignupView> createState() => _SignupViewState();
}

class _SignupViewState extends State<SignupView> {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  bool isLoading = false;

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppbar(
        title: "Create Account",
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
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomTextfield(
                  hint: "Enter your name",
                  isPass: false,
                  controller: nameController,
                  icon: Icons.person_2_outlined,
                  textFieldName: 'Name',
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Name is required";
                    }
                    return null;
                  },
                ),
                Gap(15),
                CustomTextfield(
                  hint: "Enter your email",
                  isPass: false,
                  controller: emailController,
                  icon: Icons.email_outlined,
                  textFieldName: 'Email',
                  validator: validateEmail,
                ),
                Gap(15),
                CustomTextfield(
                  hint: "Enter your Password",
                  isPass: true,
                  controller: passwordController,
                  icon: Icons.lock_outlined,
                  textFieldName: 'Password',
                  validator: validateStrongPassword,
                  onChanged: (value) {
                    setState(() {});
                  },
                ),
                PasswordRequirement(
                  text: "At least 8 characters",
                  isChecked: passwordController.text.length >= 8,
                ),
                PasswordRequirement(
                  text: "At least one uppercase letter",
                  isChecked: RegExp(r'[A-Z]').hasMatch(passwordController.text),
                ),
                PasswordRequirement(
                  text: "At least one lowercase letter",
                  isChecked: RegExp(r'[a-z]').hasMatch(passwordController.text),
                ),
                PasswordRequirement(
                  text: "At least one number and one special character",
                  isChecked:
                      RegExp(r'[0-9]').hasMatch(passwordController.text) &&
                      RegExp(r'[^a-zA-Z0-9]').hasMatch(passwordController.text),
                ),
                Gap(15),
                CustomTextfield(
                  hint: "Password Confirmation",
                  isPass: true,
                  controller: confirmPasswordController,
                  icon: Icons.lock_outlined,
                  textFieldName: 'Confirm your password',
                  onChanged: (value) {
                    setState(() {});
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please confirm your password";
                    }

                    if (value != passwordController.text) {
                      return "Passwords do not match";
                    }

                    return null;
                  },
                ),
                PasswordRequirement(
                  text: "Password must match",
                  isChecked:
                      confirmPasswordController.text.isNotEmpty &&
                      confirmPasswordController.text == passwordController.text,
                ),
                Gap(20),
                CustomElevatedbutton(
                  isLoading: isLoading,
                  text: "Create Account",
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      setState(() {
                        isLoading = true;
                      });

                      await Future.delayed(const Duration(seconds: 2));

                      if (!mounted) return;

                      setState(() {
                        isLoading = false;
                      });
                      showCustomSnackBar(
                        context,
                        message: "Account created successfully!",
                      );
                    }
                  },
                ),
                Gap(15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomText(text: "Already have an account?"),
                    Gap(0),
                    CustomTextButton(
                      text: "Login",
                      color: AppColors.primary,
                      size: 16,
                      weight: FontWeight.normal,
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginView(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
