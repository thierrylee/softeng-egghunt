part of 'landing_page_bloc.dart';

sealed class LandingPageState extends Equatable {}

class LandingPageInitialState extends LandingPageState {
  @override
  List<Object> get props => [];
}

class LandingPageAskUsernameState extends LandingPageState {
  @override
  List<Object?> get props => [];
}

class LandingPageUsernameAvailableState extends LandingPageState {
  @override
  List<Object?> get props => [];
}