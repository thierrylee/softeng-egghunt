import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:softeng_egghunt/repository/username_repository.dart';

part 'landing_page_event.dart';

part 'landing_page_state.dart';

class LandingPageBloc extends Bloc<LandingPageEvent, LandingPageState> {
  late UsernameRepository _usernameRepository;

  LandingPageBloc({required UsernameRepository usernameRepository}) : super(LandingPageInitialState()) {
    _usernameRepository = usernameRepository;
    on<LandingPageInitEvent>(_onInitEvent);
  }

  Future<void> _onInitEvent(
    LandingPageInitEvent event,
    Emitter<LandingPageState> emit,
  ) async {
    if (await _usernameRepository.getUsername() == null) {
      emit(LandingPageAskUsernameState());
    } else {
      emit(LandingPageUsernameAvailableState());
    }
  }
}
