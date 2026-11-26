import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movixapp/Widgets/custom_text.dart';
import 'package:movixapp/core/constants/app_colors.dart';
import 'package:movixapp/core/network/result.dart';
import 'package:movixapp/features/home/cubit/section_state.dart';
import 'package:movixapp/features/home/widgets/media_card.dart';
import 'package:movixapp/features/home/cubit/section_cubit.dart';
import 'package:movixapp/features/home/data/media_item.dart';

class SectionContainer extends StatelessWidget {
  final String title;
  // final Future<List<MediaItem>> Function() fetch;
  final Future<Result<List<MediaItem>>> Function() fetch;
  final bool upcoming;
  final VoidCallback? onSeeMore;

  const SectionContainer({
    super.key,
    required this.title,
    required this.fetch,
    this.upcoming = false,
    this.onSeeMore,
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
              return switch (state) {
                SectionInitial() || SectionLoading() => messageBox(
                  const CircularProgressIndicator(),
                ),
                SectionLoaded(:final items) =>
                  items.isEmpty
                      ? messageBox(
                          const Text(
                            'Nothing here yet',
                            style: TextStyle(color: Colors.white),
                          ),
                        )
                      : itemsList(items),
                SectionFailure(:final message) => messageBox(
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        message,
                        style: const TextStyle(color: Colors.white),
                      ),
                      TextButton(
                        onPressed: () =>
                            context.read<SectionCubit>().loadItems(),
                        child: const Text('Try again'),
                      ),
                    ],
                  ),
                ),
              };
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
        CustomText(
          text: title,
          color: Colors.white,
          size: 18,
          weight: FontWeight.w800,
        ),
        InkWell(
          onTap: onSeeMore,
          child: const Text(
            'See More',
            style: TextStyle(
              color: AppColors.primary,
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
