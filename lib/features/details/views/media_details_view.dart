import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movixapp/Widgets/details_scaffold.dart';
import 'package:movixapp/Widgets/underline_tabs.dart';
import 'package:movixapp/features/details/cubit/media_details_cubit.dart';
import 'package:movixapp/features/details/cubit/media_details_state.dart';
import 'package:movixapp/features/details/data/media_details.dart';
import 'package:movixapp/features/details/widgets/cast_grid.dart';
import 'package:movixapp/features/details/widgets/media_about_tab.dart';
import 'package:movixapp/features/details/widgets/media_action_bar.dart';
import 'package:movixapp/features/details/widgets/media_header.dart';
import 'package:movixapp/features/details/widgets/trailer_section.dart';
import 'package:movixapp/features/details/widgets/watch_section.dart';

class MediaDetailsView extends StatelessWidget {
  final int id;
  final String type;

  const MediaDetailsView({super.key, required this.id, this.type = 'movie'});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => MediaDetailsCubit(type: type, id: id)..load(),
      child: BlocBuilder<MediaDetailsCubit, MediaDetailsState>(
        builder: (context, state) {
          final details = state.details;
          return DetailsScaffold(
            title: type == 'tv' ? 'TV Show Details' : 'Movie Details',
            loading: state.loading,
            error: state.error,
            onRetry: () => context.read<MediaDetailsCubit>().load(),
            body: details == null ? null : _DetailsBody(details: details),
          );
        },
      ),
    );
  }
}

class _DetailsBody extends StatefulWidget {
  final MediaDetails details;
  const _DetailsBody({required this.details});

  @override
  State<_DetailsBody> createState() => _DetailsBodyState();
}

class _DetailsBodyState extends State<_DetailsBody> {
  int _tab = 0; // 0 About, 1 Cast

  @override
  Widget build(BuildContext context) {
    final details = widget.details;
    return ListView(
      padding: const EdgeInsets.only(bottom: 24),
      children: [
        MediaHeader(details: details),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: MediaActionBar(details: details),
        ),
        TrailerSection(videoKey: details.trailerKey),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: UnderlineTabs(
            tabs: const ['About', 'Cast'],
            selectedIndex: _tab,
            onTap: (i) => setState(() => _tab = i),
          ),
        ),
        // Watch now sits right after About / Cast
        WatchSection(details: details),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
          child: _tab == 0
              ? MediaAboutTab(details: details)
              : CastGrid(cast: details.cast),
        ),
      ],
    );
  }
}