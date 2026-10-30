import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movixapp/features/home/widgets/home_header.dart';
import 'package:movixapp/features/home/widgets/media_card.dart';
import 'package:movixapp/features/movies/cubit/section_cubit.dart';
import 'package:movixapp/features/movies/data/media_item.dart';

class SectionContainer extends StatelessWidget {
  final String title;
  final Future<List<MediaItem>> Function() fetch;
  final bool upcoming;

  const SectionContainer({
    super.key,
    required this.title,
    required this.fetch,
    this.upcoming = false,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SectionCubit(fetch)..loadItems(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          titleRow(),
          const SizedBox(height: 12),
          BlocBuilder<SectionCubit, SectionState>(
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
                        onPressed: () => context.read<SectionCubit>().loadItems(),
                        child: const Text('Try again'),
                      ),
                    ],
                  ),
                );
              }
              if (state.items.isEmpty) {
                return messageBox(
                  const Text('Nothing here yet', style: TextStyle(color: Colors.white)),
                );
              }
              return itemsList(state.items);
            },
          ),
        ],
      ),
    );
  }

  Widget titleRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),
        InkWell(
          onTap: () {},
          child: const Text(
            'See More',
            style: TextStyle(
              color: HomeHeader.greenColor,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget messageBox(Widget message) {
    return SizedBox(height: 300, child: Center(child: message));
  }

  Widget itemsList(List<MediaItem> items) {
    return SizedBox(
      height: 300,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        separatorBuilder: (context, index) => const SizedBox(width: 12),
        itemBuilder: (context, index) =>
            MediaCard(item: items[index], upcoming: upcoming),
      ),
    );
  }
}
