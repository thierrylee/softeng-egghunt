import 'package:equatable/equatable.dart';

class Egg extends Equatable {
  final String eggName;
  final int eggValue;
  final String eggDescription;

  const Egg({required this.eggName, required this.eggValue, required this.eggDescription});

  @override
  List<Object?> get props => [eggName, eggValue, eggDescription];
}
