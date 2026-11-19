import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movixapp/features/home/widgets/home_header.dart';
import 'package:movixapp/features/home/widgets/media_card.dart';
import 'package:movixapp/features/movies/cubit/media_grid_cubit.dart';

/// Two-column grid of media cards. Needs a [MediaGridCubit] above it.
class MediaGridView extends StatelessWidget {
  final String emptyMessage;

  const MediaGridView({super.key, this.emptyMessage = 'Nothing here yet'});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MediaGridCubit, MediaGridState>(
      builder: (context, state) {
        if (state.loading) {
          return const Center(
            child: CircularProgressIndicator(color: HomeHeader.greenColor),
          );
        }
        if (state.error != null) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(state.error!, style: const TextStyle(color: Colors.white)),
                TextButton(
                  onPressed: () => context.read<MediaGridCubit>().load(),
                  child: const Text('Try again'),
                ),
              ],
            ),
          );
        }
        if (state.items.isEmpty) {
          return Center(
            child: Text(
              emptyMessage,
              style: const TextStyle(color: Color(0xFF7C8B85)),
            ),
          );
        }

        return LayoutBuilder(
          builder: (context, constraints) {
            const horizontalPadding = 16.0;
            const spacing = 12.0;
            final cellWidth =
                (constraints.maxWidth - horizontalPadding * 2 - spacing) / 2;

            return Stack(
              children: [
                NotificationListener<ScrollNotification>(
                  onNotification: (n) {
                    if (n.metrics.extentAfter < 500) {
                      context.read<MediaGridCubit>().loadMore();
                    }
                    return false;
                  },
                  child: GridView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: spacing,
                      mainAxisSpacing: 16,
                      // poster (2:3) + text lines under it
                      mainAxisExtent: cellWidth * 1.5 + 56,
                    ),
                    itemCount: state.items.length,
                    itemBuilder: (context, index) => MediaCard(
                      item: state.items[index],
                      width: double.infinity,
                    ),
                  ),
                ),
                if (state.loadingMore)
                  const Positioned(
                    left: 0,
                    right: 0,
                    bottom: 8,
                    child: Center(
                      child: SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: HomeHeader.greenColor,
                        ),
                      ),
                    ),
                  ),
              ],
            );
          },
        );
      },
    );
  }
}
