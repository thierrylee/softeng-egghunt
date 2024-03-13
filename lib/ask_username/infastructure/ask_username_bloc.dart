import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:softeng_egghunt/repository/username_repository.dart';

part 'ask_username_event.dart';

part 'ask_username_state.dart';

class AskUsernameBloc extends Bloc<AskUsernameEvent, AskUsernameState> {
  late UsernameRepository _usernameRepository;

  AskUsernameBloc({required UsernameRepository usernameRepository}) : super(AskUsernameInitial()) {
    _usernameRepository = usernameRepository;
    on<AskUsernameSubmitEvent>(_onSubmitUsername);
  }

  Future<void> _onSubmitUsername(
    AskUsernameSubmitEvent event,
    Emitter<AskUsernameState> emit,
  ) async {
    if (event.username.length >= 3 || event.username.length <= 4) {
      _usernameRepository.setUsername(event.username.toUpperCase());
      emit(AskUsernameSubmitSuccess());
    }
  }
}
