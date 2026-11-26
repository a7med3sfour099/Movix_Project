import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movixapp/core/constants/app_colors.dart';
import 'package:movixapp/core/data/media_repository.dart';
import 'package:movixapp/features/auth/widgets/custom_auth_appbar.dart';
import 'package:movixapp/features/history/cubit/history_cubit.dart';
import 'package:movixapp/features/history/cubit/history_state.dart';
import 'package:movixapp/features/history/widgets/history_card_widget.dart';
import 'package:movixapp/core/data/media_repository.dart';

class HistoryView extends StatelessWidget {
  final String? initialFilter;

  const HistoryView({super.key, this.initialFilter});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
      HistoryCubit(filter: initialFilter)..fetchHistory(),
      child: Scaffold(
        appBar: CustomAppbar(title: "History", back: true),
        body: BlocBuilder<HistoryCubit, HistoryState>(
          builder: (context, state) {
            if (state is HistoryLoading) {
              return const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              );
            }

            if (state is HistoryError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    state.exception.userMessage,
                    style: const TextStyle(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            }

            if (state is HistoryLoaded) {
              if (state.items.isEmpty) {
                return const Center(
                  child: Text(
                    "No History Yet",
                    style: TextStyle(color: Colors.white54),
                  ),
                );
              }

              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    int crossAxisCount;
                    double childAspectRatio;

                    if (constraints.maxWidth < 400) {
                      crossAxisCount = 2;
                      childAspectRatio = 0.46;
                    } else if (constraints.maxWidth < 600) {
                      crossAxisCount = 2;
                      childAspectRatio = 0.51;
                    } else if (constraints.maxWidth < 900) {
                      crossAxisCount = 3;
                      childAspectRatio = 0.55;
                    } else {
                      crossAxisCount = 4;
                      childAspectRatio = 0.6;
                    }
                    return GridView.builder(
                      itemCount: state.items.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        childAspectRatio: childAspectRatio,
                        crossAxisSpacing: 18,
                        mainAxisSpacing: 18,
                      ),
                      itemBuilder: (context, index) {
                        final item = state.items[index];
                        return HistoryCard(
                          item: item,
                          onDelete: () {
                            context.read<HistoryCubit>().removeItem(item.id);
                          },
                          onWatched: () {
                            AwesomeDialog(
                              context: context,
                              dismissOnTouchOutside: false,
                              dialogType: DialogType.success,
                              animType: AnimType.scale,
                              dialogBackgroundColor: AppColors.background,
                              title: 'Watched!',
                              titleTextStyle: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                              desc:
                                  'You have watched "${item.title}". How was it?',
                              descTextStyle: TextStyle(color: Colors.white),
                              btnOkText: 'Rate Now',
                              btnCancelText: 'Later',
                              btnOkOnPress: () {},
                              btnCancelOnPress: () {},
                            ).show();
                          },
                        );
                      },
                    );
                  },
                ),
              );
            }

            return const SizedBox();
          },
        ),
      ),
    );
  }
}
