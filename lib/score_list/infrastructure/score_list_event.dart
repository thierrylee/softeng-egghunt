part of 'score_list_bloc.dart';

sealed class ScoreListEvent extends Equatable {}

class ScoreListInitEvent extends ScoreListEvent {
  ScoreListInitEvent();

  @override
  List<Object?> get props => [];
}

class ScoreListUpdateEvent extends ScoreListEvent {
  final Iterable<CollectedEgg> collectedEggs;

  ScoreListUpdateEvent({required this.collectedEggs});

  @override
  List<Object?> get props => [collectedEggs];
}