import 'package:softeng_egghunt/score_list/infrastructure/score_list_bloc.dart';
import 'package:softeng_egghunt/score_list/score_list_viewmodel.dart';

abstract class ScoreListPresenter {
  static ScoreListViewModel present(ScoreListState state) {
    return switch (state) {
      ScoreListFetchedState scoreList => ScoreListWithResultsViewModel(
          myScore: scoreList.myScore,
          scoreList: scoreList.scoreList,
        ),
      ScoreListInitialState _ => ScoreListLoadingViewModel(),
      ScoreListState() => ScoreListLoadingViewModel(),
    };
  }
}
