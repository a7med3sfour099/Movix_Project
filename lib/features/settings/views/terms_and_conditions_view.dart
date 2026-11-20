import 'package:flutter/material.dart';
import 'package:movixapp/core/constants/app_colors.dart';
import 'package:movixapp/features/auth/widgets/custom_auth_appbar.dart';
import 'package:movixapp/features/settings/widgets/about_card.dart';

class TermsAndConditionsView extends StatelessWidget {
  const TermsAndConditionsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppbar(
        title: "Terms & Conditions",
        back: true,
        onPressed: () => Navigator.maybePop(context),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          child: Column(
            children: const [
              AboutCard(
                leadingText: "01",
                title: "1. ACCEPTANCE OF TERMS",
                content:
                    "By launching, indexing, or synchronizing your vault via MOVIX, you explicitly agree to be bound by these legal provisions. MOVIX is designed exclusively for individual, non- commercial media cataloging, curation, and private screening record-keeping. If you do not consent to these parameters, please terminate your local session and disengage client synchronization.",
              ),
              SizedBox(height: 16),
              AboutCard(
                leadingText: "02",
                title: "2. TMDB DATA & CONTENT",
                content:
                    "All cinematic artwork, theatrical posters, 16:9 widescreen backdrops, actor biographies, and foundational filmographic metadata are integrated courtesy of the The Movie Database (TMDB) API. This product uses the TMDB API but is not officially endorsed, certified, or maintained directly by TMDB.",
              ),
              SizedBox(height: 16),
              AboutCard(
                leadingText: "03",
                title: "3. LIMITATION OF LIABILITY & DISCLAIMERS",
                content:
                    "MOVIX is provisioned on an \"AS IS\" and \"AS AVAILABLE\" basis. While we provide resilient offline metadata caching engines, we disclaim all warranties concerning uninterrupted network transit from upstream third-party databases. Under no circumstances shall MOVIX directors, contractors, or contributors be liable for indirect, incidental, or exemplary damages resulting from data desynchronization or local device alterations.",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
