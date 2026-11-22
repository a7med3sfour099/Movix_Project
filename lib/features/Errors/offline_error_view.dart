import 'package:flutter/material.dart';
import 'package:movixapp/core/constants/app_colors.dart';
import 'package:movixapp/features/auth/widgets/custom_auth_appbar.dart';
import 'package:gap/gap.dart';
import 'package:movixapp/Widgets/custom_text.dart';
import 'package:movixapp/Widgets/custom_elevated_button.dart';
import 'package:movixapp/features/Errors/custom_circular_icon.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movixapp/core/network/internet_cubit.dart';
import 'package:movixapp/features/auth/widgets/custom_snackbar.dart';

class OfflineErrorView extends StatelessWidget {
  const OfflineErrorView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<InternetCubit, InternetState>(
      listenWhen: (previous, current) =>
          current.errorMessage != null &&
          previous.errorMessage != current.errorMessage,
      listener: (context, state) {
        if (state.errorMessage != null) {
          showCustomSnackBar(
            context,
            message: state.errorMessage!,
            isError: true,
          );
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: CustomAppbar(title: "", back: false),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Column(
                  children: [
                    Gap(100),
                    CustomCircularIcon(icon: Icons.cloud_off),
                    Gap(8),
                    CustomText(
                      text: "You're Offline",
                      size: 28,
                      weight: FontWeight.bold,
                    ),
                    Gap(12),
                    CustomText(
                      text:
                          "Displaying cached favorites and watchlist.\nPlease check your network to sync new data.",
                      height: 1.2,
                      maxLines: 3,
                      weight: FontWeight.w300,
                      color: AppColors.secondary,
                      size: 14,
                    ),
                    Gap(35),
                    BlocBuilder<InternetCubit, InternetState>(
                      builder: (context, state) {
                        return CustomElevatedbutton(
                          text: "",
                          isLoading: state.isLoading,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.refresh,
                                size: 22,
                                color: AppColors.background,
                              ),
                              Gap(5),
                              CustomText(
                                text: "Retry connection",
                                color: AppColors.background,
                                weight: FontWeight.bold,
                              ),
                            ],
                          ),
                          onPressed: () {
                            context.read<InternetCubit>().checkConnection();
                          },
                        );
                      },
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
