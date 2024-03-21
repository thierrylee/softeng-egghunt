import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:softeng_egghunt/repository/egghunt_repository_provider.dart';
import 'package:softeng_egghunt/scan_code/scan_code_page.dart';
import 'package:softeng_egghunt/score_list/domain/egghunt_score.dart';
import 'package:softeng_egghunt/score_list/infrastructure/score_list_bloc.dart';
import 'package:softeng_egghunt/score_list/score_list_presenter.dart';
import 'package:softeng_egghunt/score_list/score_list_viewmodel.dart';

class ScoreListPage extends StatelessWidget {
  static const String routeName = "/scoreList";

  const ScoreListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Scores"),
        actions: [
          IconButton(
            icon: const Icon(Icons.qr_code_scanner_rounded),
            tooltip: "Scanner un code",
            onPressed: () {
              Navigator.of(context).pushNamed(ScanCodePage.routeName).then((returnValue) {
                final scanResults = returnValue as ScanCodePageResult?;
                if (scanResults != null) {
                  showDialog(
                    context: context,
                    builder: (dialogContext) => AlertDialog(
                      title: Text(scanResults.title),
                      content: Text(scanResults.message),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(dialogContext);
                          },
                          child: const Text("Fermer"),
                        ),
                      ],
                    ),
                  );
                }
              });
            },
          ),
        ],
      ),
      body: BlocProvider(
        create: (context) => ScoreListBloc(
          usernameRepository: EggHuntRepositoryProvider.getUsernameRepository(),
          eggsRepository: EggHuntRepositoryProvider.getEggsRepository(),
          collectedEggsRepository: EggHuntRepositoryProvider.getCollectedEggsRepository(),
        )..add(ScoreListInitEvent()),
        child: _ScoreListScreen(),
      ),
    );
  }
}

class _ScoreListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocSelector<ScoreListBloc, ScoreListState, ScoreListViewModel>(
        selector: ScoreListPresenter.present,
        builder: (context, viewModel) => switch (viewModel) {
              ScoreListLoadingViewModel _ => const Center(child: CircularProgressIndicator()),
              ScoreListWithResultsViewModel() => _ScoreListView(viewModel: viewModel),
            });
  }
}

class _ScoreListView extends StatelessWidget {
  final ScoreListWithResultsViewModel viewModel;

  const _ScoreListView({required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
          child: _ScoreWidget(
            viewModel: viewModel.myScore,
            myScore: viewModel.myScore,
          ),
        ),
        const Divider(thickness: 3),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView.separated(
              itemCount: viewModel.scoreList.length,
              itemBuilder: (context, index) {
                return _ScoreWidget(
                  myScore: viewModel.myScore,
                  viewModel: viewModel.scoreList[index],
                );
              },
              separatorBuilder: (_, index) => const Divider(),
            ),
          ),
        ),
      ],
    );
  }
}

class _ScoreWidget extends StatelessWidget {
  final EggHuntScore myScore;
  final EggHuntScore viewModel;

  const _ScoreWidget({required this.myScore, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final Color textColor;
    final String myScoreSuffix;

    if (viewModel == myScore) {
      myScoreSuffix = " (mon score)";
      textColor = theme.colorScheme.secondary;
    } else {
      myScoreSuffix = "";
      textColor = theme.colorScheme.onSurface;
    }

    return Row(
      children: [
        Expanded(
            child: Text(
          "${viewModel.username}$myScoreSuffix",
          style: theme.textTheme.bodyLarge!.copyWith(color: textColor, fontWeight: FontWeight.bold),
        )),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Row(
            children: [
              Text(
                "${viewModel.score}",
                style: theme.textTheme.bodyLarge!.copyWith(color: textColor, fontWeight: FontWeight.bold),
              ),
              Text(" point(s)", style: theme.textTheme.bodySmall!.copyWith(color: textColor)),
            ],
          ),
        ),
      ],
    );
  }
}
