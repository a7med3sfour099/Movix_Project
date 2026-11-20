import 'package:flutter/material.dart';
import 'package:movixapp/core/constants/app_colors.dart';
import 'package:movixapp/features/auth/widgets/custom_auth_appbar.dart';
import 'package:movixapp/features/settings/widgets/about_card.dart';

class AboutUsView extends StatelessWidget {
  const AboutUsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppbar(
        title: "About Us",
        back: true,
        onPressed: () => Navigator.maybePop(context),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          child: Column(
            children: const [
              AboutCard(
                icon: Icons.menu_book_rounded,
                title: "APPLICATION DESCRIPTION",
                content:
                    "Discover movies and TV shows, explore cast information, and keep track of your favorites and watchlist.",
              ),
              SizedBox(height: 16),
              AboutCard(
                icon: Icons.groups_outlined,
                title: "TEAM INFORAMTION",
                content:
                    "Mazen Ashraf\nAli El-deen Maher\nAhmed Asfour\nShahd Farouk\nShahd Farghaly",
              ),
              SizedBox(height: 16),
              AboutCard(
                icon: Icons.verified_outlined,
                title: "APP VERSION",
                content: "1.0.0",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
