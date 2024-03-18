import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:softeng_egghunt/data/egg.dart';
import 'package:softeng_egghunt/data/collected_egg.dart';
import 'package:softeng_egghunt/repository/collected_eggs_repository.dart';
import 'package:softeng_egghunt/repository/eggs_repository.dart';
import 'package:softeng_egghunt/repository/username_repository.dart';

part 'scan_code_event.dart';

part 'scan_code_state.dart';

class ScanCodeBloc extends Bloc<ScanCodeEvent, ScanCodeState> {
  late UsernameRepository _usernameRepository;
  late EggsRepository _eggsRepository;
  late CollectedEggsRepository _collectedEggsRepository;

  ScanCodeBloc({
    required UsernameRepository usernameRepository,
    required EggsRepository eggsRepository,
    required CollectedEggsRepository collectedEggsRepository,
  }) : super(ScanCodeInitialState()) {
    _usernameRepository = usernameRepository;
    _eggsRepository = eggsRepository;
    _collectedEggsRepository = collectedEggsRepository;
    on<ScanCodeReceivedEvent>(_onCodeReceivedEvent);
  }

  Future<void> _onCodeReceivedEvent(
    ScanCodeReceivedEvent event,
    Emitter<ScanCodeState> emit,
  ) async {
    debugPrint("Received code : ${event.codeValue}");

    final currentUsername = await _usernameRepository.getUsername();
    if (currentUsername == null) {
      emit(const ScanCodeCodeFailure(
        errorTitle: "Étrange...",
        errorMessage: "Il semblerait que ton polygramme n'est pas renseigné !\n... Comment est-tu arrivé ici ?! 🤔",
      ));
      return;
    }

    Egg? eggFound;
    try {
      eggFound = (await _eggsRepository.getEggs()).firstWhere((egg) => egg.eggName == event.codeValue);
    } catch (e) {
      eggFound = null;
    }

    if (eggFound == null) {
      emit(const ScanCodeCodeFailure(
        errorTitle: "Petit tricheur !",
        errorMessage: "Ce code ne fait pas parti des oeufs à trouver ! 👀",
      ));
      return;
    }

    if ((await _collectedEggsRepository.getCollectedEggs())
        .any((collectedEgg) => collectedEgg.userName == currentUsername && collectedEgg.eggName == event.codeValue)) {
      emit(const ScanCodeCodeFailure(
        errorTitle: "Petit tricheur !",
        errorMessage: "Petit tricheur, cet oeuf a déjà été enregistré ! 👿",
      ));
      return;
    }

    await _collectedEggsRepository.addCollectedEgg(
      CollectedEgg(
        eggName: event.codeValue,
        userName: currentUsername,
      ),
    );

    emit(ScanCodeCodeSuccess(
      title: "Bravo !",
      message: "Cet oeuf te rapporte ${eggFound.eggValue} point(s) ! 🥚🎉",
    ));
  }
}
