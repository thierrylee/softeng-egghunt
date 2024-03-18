import 'dart:collection';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:softeng_egghunt/data/egg.dart';
import 'package:softeng_egghunt/data/collected_egg.dart';
import 'package:softeng_egghunt/repository/collected_eggs_repository.dart';
import 'package:softeng_egghunt/repository/eggs_repository.dart';
import 'package:softeng_egghunt/repository/username_repository.dart';
import 'package:softeng_egghunt/score_list/domain/EggHuntScore.dart';

part 'score_list_event.dart';

part 'score_list_state.dart';

class ScoreListBloc extends Bloc<ScoreListEvent, ScoreListState> {
  late UsernameRepository _usernameRepository;
  late EggsRepository _eggsRepository;
  late CollectedEggsRepository _collectedEggsRepository;

  ScoreListBloc({
    required UsernameRepository usernameRepository,
    required EggsRepository eggsRepository,
    required CollectedEggsRepository collectedEggsRepository,
  }) : super(ScoreListInitialState()) {
    _usernameRepository = usernameRepository;
    _eggsRepository = eggsRepository;
    _collectedEggsRepository = collectedEggsRepository;
    on<ScoreListInitEvent>(_onInit);
    on<ScoreListUpdateEvent>(_onScoreListUpdate);
  }

  Future<void> _onInit(
    ScoreListInitEvent event,
    Emitter<ScoreListState> emit,
  ) async {
    final currentUsername = await _usernameRepository.getUsername();
    if (currentUsername == null) throw Exception("Username is null !!");

    _collectedEggsRepository.listenOnCollectedEggs(this);
  }

  Future<void> _onScoreListUpdate(
    ScoreListUpdateEvent event,
    Emitter<ScoreListState> emit,
  ) async {
    await _onReceiveCollectedEggs(emit, event.collectedEggs);
  }

  Future<void> _onReceiveCollectedEggs(
    Emitter<ScoreListState> emit,
    Iterable<CollectedEgg> collectedEggs,
  ) async {
    final currentUsername = await _usernameRepository.getUsername();
    if (currentUsername == null) throw Exception("Username is null !!");

    final scoreList = _toScoreList(
      currentUsername,
      (await _eggsRepository.getEggs()),
      collectedEggs,
    ).toList()
      ..sort((scoreA, scoreB) => scoreB.score.compareTo(scoreA.score));
    final myScore = scoreList.firstWhere((score) => score.username == currentUsername);

    emit(ScoreListFetchedState(myScore: myScore, scoreList: scoreList));
  }

  Iterable<EggHuntScore> _toScoreList(
    String currentUsername,
    Iterable<Egg> eggs,
    Iterable<CollectedEgg> collectedEggs,
  ) {
    final scoreMap = collectedEggs.fold(HashMap<String, int>()..addAll({currentUsername: 0}), (scoreMap, collectedEgg) {
      final matchingEgg = eggs.firstWhere((egg) => egg.eggName == collectedEgg.eggName,
          orElse: () => Egg(
                eggName: collectedEgg.eggName,
                eggValue: 0,
                eggDescription: "Aucun oeuf pour l'instant !",
              ));

      if (scoreMap.containsKey(collectedEgg.userName)) {
        scoreMap.update(collectedEgg.userName, (value) => value + matchingEgg.eggValue);
      } else {
        scoreMap.addAll({collectedEgg.userName: matchingEgg.eggValue});
      }
      return scoreMap;
    });

    return scoreMap.keys.map((key) => EggHuntScore(username: key, score: scoreMap[key]!));
  }
}
