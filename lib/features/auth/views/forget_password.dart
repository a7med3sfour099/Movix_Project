import 'package:flutter/material.dart';
import 'package:movixapp/core/constants/app_colors.dart';
import 'package:movixapp/core/utils/email_validator.dart';
import 'package:movixapp/features/auth/widgets/custom_auth_appbar.dart';
import 'package:movixapp/Widgets/custom_text.dart';
import 'package:movixapp/Widgets/custom_text_field.dart';
import 'package:gap/gap.dart';
import 'package:movixapp/Widgets/custom_elevated_button.dart';
import 'package:movixapp/features/auth/widgets/custom_snackbar.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({super.key});

  @override
  State<ForgetPassword> createState() => _forgetPasswordState();
}

class _forgetPasswordState extends State<ForgetPassword> {
  final _formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  bool isLoading = false;

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomTextfield(
                  hint: "Enter your email",
                  isPass: false,
                  controller: emailController,
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
                CustomElevatedbutton(
                  isLoading: isLoading,
                  text: "Reset Password",
                  size: 16,
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
                        message: "If an account exists with this email, you'll receive a password reset link shortly. Please check your inbox.",
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
