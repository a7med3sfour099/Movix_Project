import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movixapp/Widgets/details_scaffold.dart';
import 'package:movixapp/Widgets/underline_tabs.dart';
import 'package:movixapp/core/utils/date_utils.dart';
import 'package:movixapp/features/actors/cubit/person_cubit.dart';
import 'package:movixapp/features/actors/data/person_details.dart';
import 'package:movixapp/features/actors/widgets/actor_about_tab.dart';
import 'package:movixapp/features/actors/widgets/actor_hero.dart';
import 'package:movixapp/features/actors/widgets/stat_boxes.dart';
import 'package:movixapp/features/movies/widgets/media_card_grid.dart';

class ActorProfileScreen extends StatelessWidget {
  final int id;

  const ActorProfileScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PersonCubit(id)..load(),
      child: BlocBuilder<PersonCubit, PersonState>(
        builder: (context, state) {
          final person = state.person;
          return DetailsScaffold(
            title: 'Actor Profile',
            loading: state.loading,
            error: state.error,
            onRetry: () => context.read<PersonCubit>().load(),
            body: person == null ? null : _ProfileBody(person: person),
          );
        },
      ),
    );
  }
}

class _ProfileBody extends StatefulWidget {
  final PersonDetails person;
  const _ProfileBody({required this.person});

  @override
  State<_ProfileBody> createState() => _ProfileBodyState();
}

class _ProfileBodyState extends State<_ProfileBody> {
  int _tab = 0; // 0 About, 1 Movies, 2 TV Shows

  @override
  Widget build(BuildContext context) {
    final p = widget.person;
    final age = ageFrom(p.birthday, deathday: p.deathday);

    return ListView(
      padding: const EdgeInsets.only(bottom: 24),
      children: [
        ActorHero(person: p),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          child: StatBoxes(
            stats: [
              (p.deathday == null ? 'Age' : 'Age at death', age == null ? '' : '$age Years'),
              ('Born', formatDate(p.birthday)),
              ('Birthplace', p.birthplace),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: UnderlineTabs(
            tabs: const ['About', 'Movies', 'TV Shows'],
            counts: [null, p.movies.length, p.tvShows.length],
            selectedIndex: _tab,
            onTap: (i) => setState(() => _tab = i),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
          child: switch (_tab) {
            1 => MediaCardGrid(
                items: p.movies,
                emptyMessage: 'No movies found',
              ),
            2 => MediaCardGrid(
                items: p.tvShows,
                emptyMessage: 'No TV shows found',
              ),
            _ => ActorAboutTab(person: p),
          },
        ),
      ],
    );
  }
}
