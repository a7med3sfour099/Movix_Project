import 'package:flutter/material.dart';
import 'package:movixapp/Widgets/custom_text.dart';
import 'package:movixapp/features/actors/data/actor.dart';
import 'package:movixapp/features/actors/data/actors_api.dart';
import 'package:movixapp/features/actors/widgets/actor_card.dart';
import 'package:movixapp/features/home/widgets/home_header.dart';

class ActorSection extends StatefulWidget {
  final String title;
  final String path;
  final VoidCallback? onSeeMore;

  const ActorSection({
    super.key,
    required this.title,
    required this.path,
    this.onSeeMore,
  });

  @override
  State<ActorSection> createState() => _ActorSectionState();
}

class _ActorSectionState extends State<ActorSection> {
  late Future<List<Actor>> _future = _load();

  Future<List<Actor>> _load() async =>
      (await ActorsApi().getPage(widget.path)).items;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomText(
              text: widget.title,
              size: 18,
              weight: FontWeight.w800,
            ),
            InkWell(
              onTap: widget.onSeeMore,
              child: const CustomText(
                text: 'See More',
                color: HomeHeader.greenColor,
                size: 13,
                weight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        FutureBuilder<List<Actor>>(
          future: _future,
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return _box(
                const CircularProgressIndicator(color: HomeHeader.greenColor),
              );
            }
            if (snapshot.hasError) {
              return _box(
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const CustomText(text: 'Something went wrong, try again'),
                    TextButton(
                      onPressed: () => setState(() => _future = _load()),
                      child: const Text('Try again'),
                    ),
                  ],
                ),
              );
            }
            final actors = snapshot.data ?? const <Actor>[];
            if (actors.isEmpty) {
              return _box(
                const CustomText(text: 'Nothing here yet'),
              );
            }
            return SizedBox(
              height: 290,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: actors.length,
                separatorBuilder: (context, index) => const SizedBox(width: 12),
                itemBuilder: (context, index) =>
                    ActorCard(actor: actors[index]),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _box(Widget child) =>
      SizedBox(height: 290, child: Center(child: child));
}
