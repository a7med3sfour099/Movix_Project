import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:movixapp/Widgets/custom_text.dart';
import 'package:movixapp/core/bottom_bar.dart';
import 'package:movixapp/core/constants/app_colors.dart';
import 'package:movixapp/core/services/auth_service.dart';
import 'package:movixapp/features/auth/widgets/custom_auth_appbar.dart';
import 'package:movixapp/features/library/cubit/library_cubit.dart';
import 'package:movixapp/features/library/data/library_filter.dart';
import 'package:movixapp/features/profile/Widgets/profile_Stats_card.dart';
import 'package:movixapp/features/profile/Widgets/profile_section.dart';
import '../cubit/profile_cubit.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUser = authService.value.currentUser;
    final libraryState = context.watch<LibraryCubit>().state;
    final watchlistMovies = libraryState.watchlist
        .where((i) => i.type != 'tv')
        .length
        .toString();
    final watchlistTv = libraryState.watchlist
        .where((i) => i.type == 'tv')
        .length
        .toString();
    final favoriteMovies = libraryState.favorites
        .where((i) => i.type != 'tv')
        .length
        .toString();
    final favoriteTv = libraryState.favorites
        .where((i) => i.type == 'tv')
        .length
        .toString();
    final watchedMovies = libraryState.history
        .where((i) => i.type != 'tv')
        .length
        .toString();
    final watchedTv = libraryState.history
        .where((i) => i.type == 'tv')
        .length
        .toString();

    // Opens Library on the right tab with the Movies / TV filter applied.
    void openLibrary(LibraryTab tab, MediaFilter filter) => BottomBar.open(
          context,
          2,
          libraryTab: tab,
          libraryFilter: filter,
        );

    return Scaffold(
      bottomNavigationBar: const BottomBar(),
      appBar: CustomAppbar(title: 'Profile', back: false),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Center(
              child: BlocBuilder<ProfileCubit, String>(
                builder: (context, imagePath) {
                  return InkWell(
                    onTap: () {
                      context.read<ProfileCubit>().changeImage();
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
                            color: AppColors.primary.withValues(alpha: 0.09),
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
                            shape: BoxShape.circle,
                          ),
                          child: ClipOval(
                            child: imagePath == ''
                                ? const Icon(
                                    Icons.person,
                                    color: AppColors.primary,
                                    size: 70,
                                  )
                                : Image.file(
                                    File(imagePath),
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
            Gap(12),
            CustomText(
              text: currentUser?.displayName ?? 'User',
              weight: FontWeight.bold,
            ),
            Gap(15),
            Align(
              alignment: Alignment.centerLeft,
              child: Column(
                children: [
                  ProfileSection(
                    title: 'Watched History',
                    cards: [
                      ProfileStatCard(
                        title: 'Total Watched Movies',
                        icon: Icons.movie_outlined,
                        count: watchedMovies,
                        subtitle: 'Movies',
                        onTap: () =>
                            openLibrary(LibraryTab.history, MediaFilter.movies),
                      ),
                      Gap(12),
                      ProfileStatCard(
                        title: 'Total Watched TV Shows',
                        icon: Icons.tv_outlined,
                        count: watchedTv,
                        subtitle: 'Series',
                        onTap: () =>
                            openLibrary(LibraryTab.history, MediaFilter.tv),
                      ),
                    ],
                  ),
                  Gap(12),
                  ProfileSection(
                    title: 'Watchlist',
                    cards: [
                      ProfileStatCard(
                        title: 'Movies in Watchlist',
                        icon: Icons.bookmark_border,
                        count: watchlistMovies,
                        subtitle: 'Saved',
                        onTap: () => openLibrary(
                            LibraryTab.watchlist, MediaFilter.movies),
                      ),
                      Gap(12),
                      ProfileStatCard(
                        title: 'Tv Shows in Watchlist',
                        icon: Icons.bookmark_border,
                        count: watchlistTv,
                        subtitle: 'saved',
                        onTap: () =>
                            openLibrary(LibraryTab.watchlist, MediaFilter.tv),
                      ),
                    ],
                  ),
                  Gap(12),
                  ProfileSection(
                    title: 'All-Time Favorites',
                    cards: [
                      ProfileStatCard(
                        title: 'Favorite \nMovies',
                        icon: Icons.favorite,
                        count: favoriteMovies,
                        subtitle: 'curated',
                        onTap: () => openLibrary(
                            LibraryTab.favorites, MediaFilter.movies),
                      ),
                      Gap(12),
                      ProfileStatCard(
                        title: 'Favorite TV Shows',
                        icon: Icons.favorite,
                        count: favoriteTv,
                        subtitle: 'curated',
                        onTap: () =>
                            openLibrary(LibraryTab.favorites, MediaFilter.tv),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
