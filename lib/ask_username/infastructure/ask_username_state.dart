part of 'ask_username_bloc.dart';

sealed class AskUsernameState extends Equatable {}

class AskUsernameInitial extends AskUsernameState {
  @override
  List<Object?> get props => [];
}

class AskUsernameSubmitSuccess extends AskUsernameState {
  @override
  List<Object?> get props => [];
}
