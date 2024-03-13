part of 'scan_code_bloc.dart';

sealed class ScanCodeEvent extends Equatable {
  const ScanCodeEvent();
}

class ScanCodeReceivedEvent extends ScanCodeEvent {
  final String codeValue;

  const ScanCodeReceivedEvent({required this.codeValue});

  @override
  List<Object?> get props => [codeValue];
}
