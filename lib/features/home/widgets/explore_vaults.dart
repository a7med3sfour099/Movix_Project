import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:movixapp/features/home/widgets/home_header.dart';
import 'package:movixapp/features/movies/cubit/counts_cubit.dart';

class ExploreVaults extends StatelessWidget {
  const ExploreVaults({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CountsCubit, CountsState>(
      builder: (context, state) {
        var moviesText = '${state.movies} items';
        var tvText = '${state.tvShows} items';
        var actorsText = '${state.actors} items';

        if (state.loading) {
          moviesText = '...';
          tvText = '...';
          actorsText = '...';
        }
        if (state.error != null) {
          moviesText = 'Error';
          tvText = 'Error';
          actorsText = 'Error';
        }

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
                  vaultCard(Symbols.movie, 'Movies', moviesText),
                  const SizedBox(width: 12),
                  vaultCard(Symbols.tv, 'Tv Shows', tvText),
                  const SizedBox(width: 12),
                  vaultCard(Symbols.person, 'Actors', actorsText),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget vaultCard(IconData icon, String name, String items) {
    return Container(
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
    );
  }
}
