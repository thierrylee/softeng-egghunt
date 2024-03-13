part of 'score_list_bloc.dart';

abstract class ScoreListState extends Equatable {
  const ScoreListState();
}

class ScoreListInitialState extends ScoreListState {
  @override
  List<Object> get props => [];
}

class ScoreListFetchedState extends ScoreListState {
  final EggHuntScore myScore;
  final List<EggHuntScore> scoreList;

  const ScoreListFetchedState({required this.myScore, required this.scoreList});

  @override
  List<Object?> get props => [myScore, scoreList];
}
