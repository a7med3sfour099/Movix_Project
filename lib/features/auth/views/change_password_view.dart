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
  final CurrentPasswordController = TextEditingController();
  final NewPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  bool isLoading = false;
  
  @override
  void dispose() {
    CurrentPasswordController.dispose();
    NewPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppbar(
        title: "Change Password",
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
                  hint: "Enter your password",
                  isPass: true,
                  controller: CurrentPasswordController,
                  icon: Icons.lock_outlined,
                  textFieldName: "Current password",
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
                      size: 16,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
              Gap(15),
              CustomTextfield(
                hint: "Create your password",
                isPass: true,
                controller: NewPasswordController,
                icon: Icons.lock_outlined,
                textFieldName: "New password",
                validator : validateStrongPassword,
                onChanged: (value){
                  setState(() {});
                },
              ),
              Gap(15),
              PasswordRequirement(
                text: "At least 8 characters",
                isChecked: NewPasswordController.text.length >= 8,
              ),
              PasswordRequirement(
                text: "At least one uppercase letter",
                isChecked: RegExp(r'[A-Z]').hasMatch(NewPasswordController.text),
              ),
              PasswordRequirement(
                text: "At least one lowercase letter",
                isChecked: RegExp(r'[a-z]').hasMatch(NewPasswordController.text),
              ),
              PasswordRequirement(
                text: "At least one number and one special character",
                isChecked:
                RegExp(r'[0-9]').hasMatch(NewPasswordController.text) &&
                    RegExp(r'[^a-zA-Z0-9]').hasMatch(NewPasswordController.text),
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
                validator: validateStrongPassword,
              ),
              PasswordRequirement(
                text: "Password must match",
                isChecked:
                confirmPasswordController.text.isNotEmpty &&
                    confirmPasswordController.text == NewPasswordController.text,
              ),
              Gap(20),
              CustomElevatedbutton(
                isLoading: isLoading,
                text: "Change Password",
                onPressed: () async {
                  if (_formKey.currentState!.validate() &&
                      confirmPasswordController.text.isNotEmpty &&
                      confirmPasswordController.text == NewPasswordController.text
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
