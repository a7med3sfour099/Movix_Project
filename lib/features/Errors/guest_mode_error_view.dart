import 'package:flutter/material.dart';
import 'package:movixapp/core/constants/app_colors.dart';
import 'package:movixapp/features/auth/widgets/custom_auth_appbar.dart';
import 'package:gap/gap.dart';
import 'package:movixapp/Widgets/custom_text.dart';
import 'package:movixapp/Widgets/custom_elevated_button.dart';
import 'package:movixapp/Widgets/custom_text_button.dart';
import 'package:movixapp/features/Errors/custom_circular_icon.dart';

class GuestModeErrorView extends StatelessWidget {
  const GuestModeErrorView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppbar(title: "", back: true),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Column(
                children: [
                  Gap(100),
                  CustomCircularIcon(
                    icon: Icons.lock,
                  ),
                  Gap(8),
                  CustomText(
                    text: "Login Required",
                    size: 28,
                    weight: FontWeight.bold,
                  ),
                  Gap(12),
                  CustomText(
                    text:
                        "Sign in to your account to explore this\ncontent and enjoy the full MOVIX\nexperience.",
                    height: 1.2,
                    maxLines: 3,
                    weight: FontWeight.w300,
                    color: AppColors.secondary,
                  ),
                  Gap(15),
                  CustomElevatedbutton(
                    text: "Login",
                    onPressed: () {
                      Navigator.pushNamed(context, '/login');
                    },
                  ),
                  Gap(15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomText(
                        text: "Don't have account ?",
                        color: AppColors.secondary,
                        weight: FontWeight.w500,
                      ),
                      Gap(2),
                      CustomTextButton(
                        text: "Signup",
                        color: AppColors.primary,
                        size: 16,
                        weight: FontWeight.bold,
                        onPressed: () {
                          Navigator.pushNamed(context, '/sign-up');
                        },
                      ),
                    ],
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