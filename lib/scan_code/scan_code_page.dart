import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_code_dart_scan/qr_code_dart_scan.dart';
import 'package:softeng_egghunt/repository/egghunt_repository_provider.dart';
import 'package:softeng_egghunt/scan_code/infrastructure/scan_code_bloc.dart';
import 'package:softeng_egghunt/scan_code/softeng_egghunt_qrcode_scan_view.dart';

class ScanCodePageResult extends Equatable {
  final String title;
  final String message;

  const ScanCodePageResult({required this.title, required this.message});

  @override
  List<Object?> get props => [title, message];
}

class ScanCodePage extends StatelessWidget {
  static const String routeName = "/scanCode";

  const ScanCodePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Scanner un code"),
      ),
      body: BlocProvider(
        create: (_) => ScanCodeBloc(
          usernameRepository: EggHuntRepositoryProvider.getUsernameRepository(),
          eggsRepository: EggHuntRepositoryProvider.getEggsRepository(),
          collectedEggsRepository: EggHuntRepositoryProvider.getCollectedEggsRepository(),
        ),
        child: _ScanCodeScreen(),
      ),
    );
  }
}

class _ScanCodeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocListener<ScanCodeBloc, ScanCodeState>(
      listener: (context, state) {
        switch (state) {
          case ScanCodeInitialState():
            break;
          case ScanCodeCodeSuccess():
            Navigator.pop(context, ScanCodePageResult(title: state.title, message: state.message));
            break;
          case ScanCodeCodeFailure():
            Navigator.pop(context, ScanCodePageResult(title: state.errorTitle, message: state.errorMessage));
            break;
        }
      },
      child: SoftEngEggHuntQrCodeScanView(
        typeScan: TypeScan.takePicture,
        formats: const [BarcodeFormat.qrCode],
        onCapture: (result) async {
          context.read<ScanCodeBloc>().add(ScanCodeReceivedEvent(codeValue: result.text));
        },
      ),
    );
  }
}
