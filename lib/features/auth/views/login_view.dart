import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:movixapp/Widgets/custom_elevated_button.dart';
import 'package:movixapp/Widgets/custom_text.dart';
import 'package:movixapp/Widgets/custom_text_button.dart';
import 'package:movixapp/Widgets/custom_text_field.dart';

import 'package:movixapp/core/constants/app_colors.dart';
import 'package:movixapp/core/utils/email_validator.dart';
import 'package:movixapp/features/auth/widgets/custom_auth_appbar.dart';
class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    passController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      // height: 161,
                      // color: Colors.white,
                      // width: 161,
                      // child: SvgImage(
                      //   path: 'assets/auth_assets/login_icon.svg',
                      //   color: Colors.black,
                      // ),
                      child: Image.asset(
                        'assets/auth_assets/testwithpng.png',
                        height: 161,
                        width: 161,
                      ),
                      // child: SvgPicture.asset(
                      //   'assets/auth_assets/login_icon.svg',
                      //   height: 161,
                      //   width: 161,
                      // ),
                    ),
                    CustomTextfield(
                      textFieldName: 'Email',
                      hint: 'Example@example.com',
                      isPass: false,
                      controller: emailController,
                      keyboard: TextInputType.emailAddress,
                      validator: validateEmail,
                      icon: Icons.email_outlined,
                    ),
                    Gap(15),
                    CustomTextfield(
                      textFieldName: 'Password',
                      hint: 'Password',
                      isPass: true,
                      controller: passController,
                      textInputAction: TextInputAction.done,
                      validator: validateStrongPassword,
                      icon: Icons.lock_outlined,
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
                    CustomElevatedbutton(text: 'Login', onPressed: () {}),
                    Gap(15),
                    Gap(15),

                    CustomTextButton(
                      text: 'Login with Apple',
                      onPressed: () {},
                      color: AppColors.primary,
                      size: 25,
                      weight: FontWeight.bold,
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
                          onTap: () {},
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
  }
}
