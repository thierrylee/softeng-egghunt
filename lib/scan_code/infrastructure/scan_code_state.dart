part of 'scan_code_bloc.dart';

sealed class ScanCodeState extends Equatable {
  const ScanCodeState();
}

class ScanCodeInitialState extends ScanCodeState {
  @override
  List<Object> get props => [];
}

class ScanCodeCodeSuccess extends ScanCodeState {
  final String title;
  final String message;

  const ScanCodeCodeSuccess({required this.title, required this.message});

  @override
  List<Object?> get props => [title, message];
}

class ScanCodeCodeFailure extends ScanCodeState {
  final String errorTitle;
  final String errorMessage;

  const ScanCodeCodeFailure({required this.errorTitle, required this.errorMessage});

  @override
  List<Object?> get props => [errorTitle, errorMessage];
}
