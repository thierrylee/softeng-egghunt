part of 'scan_code_bloc.dart';

sealed class ScanCodeState extends Equatable {
  const ScanCodeState();
}

class ScanCodeInitialState extends ScanCodeState {
  @override
  List<Object> get props => [];
}

class ScanCodeCodeSuccess extends ScanCodeState {
  @override
  List<Object?> get props => [];
}

class ScanCodeCodeFailure extends ScanCodeState {
  final String errorMessage;

  const ScanCodeCodeFailure({required this.errorMessage});

  @override
  List<Object?> get props => [errorMessage];
}
