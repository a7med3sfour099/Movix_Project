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

class changePassword extends StatefulWidget {
  const changePassword({super.key});

  @override
  State<changePassword> createState() => _changePasswordState();
}

class _changePasswordState extends State<changePassword> {
  
  final _formKey = GlobalKey<FormState>();
  final currentPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  bool isLoading = false;
  
  @override
  void dispose() {
    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppbar(
        title: "Change Password",
        back: true,
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      body: Padding(padding: EdgeInsets.all(15),
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
                  validator : validateStrongPassword,
                  onChanged: (value){
                    setState(() {});
                  },
              ),
              Gap(15),
              Row(
                children: [
                  Spacer(),
                  InkWell(
                    onTap: () {},
                    child: CustomText(
                      text: 'Forgot Password?',
                      size: 12,
                      color: AppColors.primary,
                      weight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Gap(15),
              CustomTextfield(
                hint: "Create your Password",
                isPass: true,
                controller: newPasswordController,
                icon: Icons.lock_outlined,
                textFieldName: "New Password",
                validator : validateStrongPassword,
                onChanged: (value){
                  setState(() {});
                },
              ),
              Gap(15),
              PasswordRequirement(
                text: "At least 8 characters",
                isChecked: newPasswordController.text.length >= 8,
              ),
              PasswordRequirement(
                text: "At least one uppercase letter",
                isChecked: RegExp(r'[A-Z]').hasMatch(newPasswordController.text),
              ),
              PasswordRequirement(
                text: "At least one lowercase letter",
                isChecked: RegExp(r'[a-z]').hasMatch(newPasswordController.text),
              ),
              PasswordRequirement(
                text: "At least one number and one special character",
                isChecked:
                RegExp(r'[0-9]').hasMatch(newPasswordController.text) &&
                    RegExp(r'[^a-zA-Z0-9]').hasMatch(newPasswordController.text),
              ),
              Gap(15),
              CustomTextfield(
                hint: "Password Confirmation",
                isPass: true,
                controller: confirmPasswordController,
                icon: Icons.lock_outlined,
                textFieldName: 'Confirm your Password',
                onChanged: (value) {
                  setState(() {});
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
              PasswordRequirement(
                text: "Password must match",
                isChecked:
                confirmPasswordController.text.isNotEmpty &&
                    confirmPasswordController.text == newPasswordController.text,
              ),
              Gap(20),
              CustomElevatedbutton(
                isLoading: isLoading,
                text: "Change Password",
                size: 16,
                onPressed: () async {
                  if (_formKey.currentState!.validate() &&
                      confirmPasswordController.text.isNotEmpty &&
                      confirmPasswordController.text == newPasswordController.text
                  ) {
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
                      message: "Password changed successfully!",
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
