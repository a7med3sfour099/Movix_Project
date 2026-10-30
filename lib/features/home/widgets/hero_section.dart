import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:movixapp/features/home/widgets/home_header.dart';
import 'package:movixapp/features/movies/cubit/hero_cubit.dart';
import 'package:movixapp/features/movies/data/movie_details.dart';

class HeroSection extends StatelessWidget {
  const HeroSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HeroCubit()..loadMovie(),
      child: BlocBuilder<HeroCubit, HeroState>(
        builder: (context, state) {
          if (state.loading) {
            return messageBox(const CircularProgressIndicator());
          }
          if (state.error != null) {
            return messageBox(
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(state.error!, style: const TextStyle(color: Colors.white)),
                  TextButton(
                    onPressed: () => context.read<HeroCubit>().loadMovie(),
                    child: const Text('Try again'),
                  ),
                ],
              ),
            );
          }
          return heroCard(state.movie!);
        },
      ),
    );
  }

  Widget messageBox(Widget message) {
    return SizedBox(height: 260, child: Center(child: message));
  }

  Widget heroCard(Movie movie) {
    final greenLine = [
      if (movie.year.isNotEmpty) 'PREMIERE ${movie.year}',
      movie.time,
    ].where((part) => part.isNotEmpty).join(' â€¢ ').toUpperCase();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: AspectRatio(
            aspectRatio: 0.95,
            child: Stack(
              fit: StackFit.expand,
              children: [
                heroImage(movie.image),
                if (movie.genre.isNotEmpty)
                  Positioned(top: 12, left: 12, child: genreLabel(movie.genre)),
                Positioned(top: 12, right: 12, child: ratingBadge(movie.rating)),
              ],
            ),
          ),
        ),
        const SizedBox(height: 14),
        Text(
          greenLine,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: HomeHeader.greenColor,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          movie.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          movie.story,
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: Color(0xFFB4C2BC),
            fontSize: 13,
          ),
        ),
        const SizedBox(height: 14),
        Row(
          children: [
            Expanded(child: trailerButton()),
            const SizedBox(width: 10),
            saveButton(),
          ],
        ),
      ],
    );
  }

  Widget heroImage(String? url) {
    const darkBackground = ColoredBox(color: Color(0xFF0F1F1A));
    if (url == null) return darkBackground;
    return Image.network(
      url,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stack) => darkBackground,
    );
  }

  Widget genreLabel(String genre) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 140),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0x990F1F1A),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        genre,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w300,
        ),
      ),
    );
  }

  Widget ratingBadge(String rating) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0x990F1F1A),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Symbols.star, size: 14, fill: 1, color: HomeHeader.greenColor),
          const SizedBox(width: 4),
          Text(
            rating,
            style: const TextStyle(
              color: HomeHeader.greenColor,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget trailerButton() {
    return ElevatedButton.icon(
      onPressed: () {},
      icon: const Icon(Symbols.play_arrow, size: 22, fill: 1),
      label: const Text(
        'Watch Trailer',
        style: TextStyle(fontWeight: FontWeight.w700),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: HomeHeader.greenColor,
        foregroundColor: const Color(0xFF0B1512),
        padding: const EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  Widget saveButton() {
    return InkWell(
      onTap: () {},
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 46,
        height: 46,
        decoration: BoxDecoration(
          color: const Color(0x990F1F1A),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: HomeHeader.greenColor, width: 1),
        ),
        child: const Icon(Symbols.bookmark, color: HomeHeader.greenColor, weight: 300),
      ),
    );
  }
}
