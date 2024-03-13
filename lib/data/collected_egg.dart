import 'package:equatable/equatable.dart';

class CollectedEgg extends Equatable {
  final String eggName;
  final String userName;

  const CollectedEgg({required this.eggName, required this.userName});

  @override
  List<Object?> get props => [eggName, userName];
}