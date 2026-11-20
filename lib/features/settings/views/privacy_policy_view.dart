import 'package:flutter/material.dart';
import 'package:movixapp/core/constants/app_colors.dart';
import 'package:movixapp/features/auth/widgets/custom_auth_appbar.dart';
import 'package:movixapp/features/settings/widgets/about_card.dart';

class PrivacyPolicyView extends StatelessWidget {
  const PrivacyPolicyView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppbar(
        title: "Privacy Policy",
        back: true,
        onPressed: () => Navigator.maybePop(context),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          child: Column(
            children: const [
              AboutCard(
                icon: Icons.inventory_2_outlined,
                title: "1.INFORMATION WE COLLECT",
                content:
                    "MOVIX processes strictly minimal metadata to fulfill personal cataloging workflows. We gather optional account credentials (display name, avatar selection) when you create an account. Your curated watchlists, favorites, and custom shelf classifications are stored within local device sandbox allocations and synchronized seamlessly with your private cloud vault.",
              ),
              SizedBox(height: 16),
              AboutCard(
                icon: Icons.inventory_2_outlined,
                title: "2. TMDB API INTEGRATION",
                content:
                    "Our cinematic catalog is powered by public metadata retrieved through the TMDB (The Movie Database) application programming interface. MOVIX utilizes TMDB public endpoints solely to fetch posters, casting directories, synopses, and release schedules. This product uses the TMDB API but is not certified or endorsed by TMDB. Your queries transmit no personal tracking identifiers to TMDB servers.",
              ),
              SizedBox(height: 16),
              AboutCard(
                icon: Icons.grid_view_rounded,
                title: "3. LOCAL OFFLINE STORAGE",
                content:
                    "MOVIX employs offline-first caching architectures using device-level secure key value stores and SQLite databases. All custom personal ratings, timestamped diary entries, and watch status flags remain locally accessible at full fidelity even when disconnected from the internet. When clearing app data or uninstalling without an active sync, locally held un-synced entries are erased in accordance with standard OS security policies.",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
