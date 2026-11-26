import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:movixapp/features/home/cubit/count_cubit.dart';
import 'package:movixapp/features/home/cubit/count_state.dart';
import 'package:movixapp/features/home/screens/catalog_view.dart';
import 'package:movixapp/features/home/widgets/home_header.dart';
import 'package:movixapp/features/actors/screens/actors_catalog_screen.dart';

class ExploreVaults extends StatelessWidget {
  const ExploreVaults({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CountsCubit, CountsState>(
      builder: (context, state) {
        return switch (state) {
          CountsInitial() ||
          CountsLoading() => _buildVaults(context, '...', '...', '...'),
          CountsLoaded(:final movies, :final tvShows, :final actors) =>
            _buildVaults(
              context,
              '${_formatCount(movies)} items',
              '${_formatCount(tvShows)} items',
              '${_formatCount(actors)} Actors',
            ),
          CountsFailure() => _buildVaults(context, 'Error', 'Error', 'Error'),
        };
      },
    );
  }
  String _formatCount(int count) {
    if (count >= 1000) {
      final k = count / 1000;
      final suffix = count >= 20000 ? '+' : '';
      return '${k.toStringAsFixed(k.truncateToDouble() == k ? 0 : 1)}K$suffix';
    }
    return '$count';
  }

  Widget _buildVaults(
    BuildContext context,
    String moviesText,
    String tvText,
    String actorsText,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Explore Vaults',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
            InkWell(
              onTap: () {},
              child: const Text(
                'View All',
                style: TextStyle(
                  color: HomeHeader.greenColor,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              vaultCard(
                Symbols.movie,
                'Movies',
                moviesText,
                onTap: () => open(context, 'Movies', 'movie'),
              ),
              const SizedBox(width: 12),
              vaultCard(
                Symbols.tv,
                'Tv Shows',
                tvText,
                onTap: () => open(context, 'Tv Shows', 'tv'),
              ),
              vaultCard(
                Symbols.person,
                'Actors',
                actorsText,
                onTap: () => openActors(context),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void open(BuildContext context, String title, String type) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CatalogView(title: title, type: type),
      ),
    );
  }

  void openActors(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ActorsCatalogScreen()),
    );
  }

  Widget vaultCard(
    IconData icon,
    String name,
    String items, {
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 160,
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: HomeHeader.darkColor,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFF26322D)),
        ),
        child: Column(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: const Color(0xFF1B2823),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: HomeHeader.greenColor, size: 26),
            ),
            const SizedBox(height: 12),
            Text(
              name,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              items,
              style: const TextStyle(color: Color(0xFF7C8B85), fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
