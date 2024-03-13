part of 'ask_username_bloc.dart';

sealed class AskUsernameEvent extends Equatable {}

class AskUsernameSubmitEvent extends AskUsernameEvent {
  final String username;

  AskUsernameSubmitEvent({required this.username});

  @override
  List<Object?> get props => [username];
}
