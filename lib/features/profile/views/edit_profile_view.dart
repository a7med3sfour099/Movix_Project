import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:movixapp/Widgets/custom_elevated_button.dart';
import 'package:movixapp/Widgets/custom_text.dart';
import 'package:movixapp/Widgets/custom_text_field.dart';
import 'package:movixapp/core/constants/app_colors.dart';
import 'package:movixapp/features/auth/widgets/custom_auth_appbar.dart';
import 'package:movixapp/features/profile/cubit/edit_profile_cubit.dart';
import 'package:movixapp/features/profile/cubit/edit_profile_state.dart';
import 'package:movixapp/features/profile/cubit/profile_cubit.dart';

class EditProfileView extends StatelessWidget {
  const EditProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final nameController = TextEditingController(text: user?.displayName ?? '');

    return BlocProvider(
      create: (_) => EditProfileCubit(),
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: CustomAppbar(
          title: 'Edit profile',
          back: true,
          onPressed: () => Navigator.maybePop(context),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Builder(
              builder: (context) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Gap(10),
                    // Avatar with camera badge
                    Center(
                      child: BlocBuilder<EditProfileCubit, EditProfileState>(
                        builder: (context, state) {
                          return InkWell(
                            onTap: () async {
                              await context.read<EditProfileCubit>().changeImage();
                              if (context.mounted) {
                                context.read<ProfileCubit>().loadImage();
                              }
                            },
                            customBorder: const CircleBorder(),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Container(
                                  width: 124,
                                  height: 124,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppColors.primary
                                        .withValues(alpha: 0.09),
                                  ),
                                ),
                                Container(
                                  width: 114,
                                  height: 114,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppColors.primary,
                                  ),
                                ),
                                Container(
                                  width: 109,
                                  height: 109,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppColors.background,
                                  ),
                                ),
                                Container(
                                  width: 106,
                                  height: 106,
                                  padding: const EdgeInsets.all(3),
                                  decoration: const BoxDecoration(
                                      shape: BoxShape.circle),
                                  child: ClipOval(
                                    child: state.imagePath.isEmpty
                                        ? const Icon(
                                            Icons.person,
                                            color: AppColors.primary,
                                            size: 70,
                                          )
                                        : Image.file(
                                            File(state.imagePath),
                                            fit: BoxFit.cover,
                                          ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 5,
                                  right: 5,
                                  child: Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: AppColors.StackBackground3,
                                      border: Border.all(
                                        color: AppColors.primary,
                                        width: 1,
                                      ),
                                    ),
                                    child: const Icon(
                                      Symbols.photo_camera,
                                      size: 18,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    const Gap(32),
                    // Name Field
                    CustomTextfield(
                      textFieldName: 'Name',
                      hint: 'Enter your name',
                      isPass: false,
                      controller: nameController,
                      icon: Icons.person_outline_rounded,
                    ),
                    const Gap(20),
                    // Email Address Card (Read-only with verified badge)
                    Container(
                      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
                      decoration: BoxDecoration(
                        color: AppColors.InputFiledBackground,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: AppColors.primary.withValues(alpha: 0.20),
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.mail_outline_rounded,
                            color: AppColors.secondary,
                            size: 22,
                          ),
                          const Gap(12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const CustomText(
                                  text: 'Email Address',
                                  size: 14,
                                  weight: FontWeight.w500,
                                  color: AppColors.secondary,
                                ),
                                const Gap(4),
                                CustomText(
                                  text: user?.email ?? 'No email',
                                  size: 15,
                                  weight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: const Color(0xFF0D231A),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: const Color(0xFF1E4634),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Symbols.verified,
                                  size: 14,
                                  fill: 1,
                                  color: AppColors.primary,
                                ),
                                const Gap(4),
                                const CustomText(
                                  text: 'Verified',
                                  size: 11,
                                  weight: FontWeight.w600,
                                  color: AppColors.primary,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Gap(40),
                    // Save Changes Button
                    BlocBuilder<EditProfileCubit, EditProfileState>(
                      builder: (context, state) {
                        return CustomElevatedbutton(
                          text: 'Save Changes',
                          backgroundColor: AppColors.primary,
                          onPressed: state.isLoading
                              ? null
                              : () {
                                  context.read<EditProfileCubit>().saveProfile(
                                        nameController.text,
                                        onSuccess: () {
                                          context
                                              .read<ProfileCubit>()
                                              .loadImage();
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                  'Profile updated successfully'),
                                            ),
                                          );
                                          Navigator.maybePop(context);
                                        },
                                        onError: (err) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(content: Text(err)),
                                          );
                                        },
                                      );
                                },
                          child: state.isLoading
                              ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    color: AppColors.background,
                                    strokeWidth: 2,
                                  ),
                                )
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.check_rounded,
                                      size: 20,
                                      color: AppColors.background,
                                    ),
                                    const Gap(8),
                                    const CustomText(
                                      text: 'Save Changes',
                                      size: 16,
                                      weight: FontWeight.w700,
                                      color: AppColors.background,
                                    ),
                                  ],
                                ),
                        );
                      },
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
