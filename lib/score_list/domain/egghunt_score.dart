import 'package:equatable/equatable.dart';

class EggHuntScore extends Equatable {
  final String username;
  final int score;

  const EggHuntScore({required this.username, required this.score});

  @override
  List<Object?> get props => [username, score];
}
