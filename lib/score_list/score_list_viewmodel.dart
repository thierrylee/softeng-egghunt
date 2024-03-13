import 'package:equatable/equatable.dart';
import 'package:softeng_egghunt/score_list/domain/EggHuntScore.dart';

sealed class ScoreListViewModel extends Equatable {}

class ScoreListLoadingViewModel extends ScoreListViewModel {
  @override
  List<Object?> get props => [];
}

class ScoreListWithResultsViewModel extends ScoreListViewModel {
  final EggHuntScore myScore;
  final List<EggHuntScore> scoreList;

  ScoreListWithResultsViewModel({required this.myScore, required this.scoreList});

  @override
  List<Object?> get props => [myScore, scoreList];

}