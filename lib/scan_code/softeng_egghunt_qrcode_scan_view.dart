// ignore_for_file: depend_on_referenced_packages
// ignore_for_file: implementation_imports
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_dart_scan/qr_code_dart_scan.dart';
import 'package:qr_code_dart_scan/src/util/extensions.dart';
import 'package:softeng_egghunt/scan_code/softeng_egghunt_qr_code_scan_decoder.dart';

enum TypeCamera { back, front }

typedef TakePictureButtonBuilder = Widget Function(
  BuildContext context,
  QRCodeDartScanController controller,
  bool loading,
);

// Forked from https://github.com/RafaelBarbosatec/qr_code_dart_scan
class SoftEngEggHuntQrCodeScanView extends StatefulWidget {
  final TypeCamera typeCamera;
  final TypeScan typeScan;
  final ValueChanged<Result>? onCapture;
  final bool scanInvertedQRCode;

  /// Use to limit a specific format
  /// If null use all accepted formats
  final List<BarcodeFormat> formats;
  final QRCodeDartScanController? controller;
  final QRCodeDartScanResolutionPreset resolutionPreset;
  final Widget? child;
  final double? widthPreview;
  final double? heightPreview;
  final TakePictureButtonBuilder? takePictureButtonBuilder;

  const SoftEngEggHuntQrCodeScanView({
    Key? key,
    this.typeCamera = TypeCamera.back,
    this.typeScan = TypeScan.live,
    this.onCapture,
    this.scanInvertedQRCode = false,
    this.resolutionPreset = QRCodeDartScanResolutionPreset.medium,
    this.controller,
    this.formats = SoftEngQrCodeScanDecoder.acceptedFormats,
    this.child,
    this.takePictureButtonBuilder,
    this.widthPreview = double.maxFinite,
    this.heightPreview = double.maxFinite,
  }) : super(key: key);

  @override
  SoftEngEggHuntQrCodeScanViewState createState() => SoftEngEggHuntQrCodeScanViewState();
}

class SoftEngEggHuntQrCodeScanViewState extends State<SoftEngEggHuntQrCodeScanView> implements DartScanInterface {
  CameraController? controller;
  late QRCodeDartScanController qrCodeDartScanController;
  late SoftEngQrCodeScanDecoder dartScanDecoder;
  bool initialized = false;
  bool processingImg = false;
  String? _lastText;

  // @override
  // TypeScan typeScan = TypeScan.live;

  TypeScan _typeScan = TypeScan.live;

  @override
  TypeScan get typeScan {
    return _typeScan;
  }

  @override
  set typeScan(TypeScan typeScan) {
    _typeScan = typeScan;
  }

  @override
  void initState() {
    typeScan = widget.typeScan;
    dartScanDecoder = SoftEngQrCodeScanDecoder(formats: widget.formats);
    _initController();
    super.initState();
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: initialized ? _getCameraWidget(context) : widget.child,
    );
  }

  void _initController() async {
    final CameraLensDirection lensDirection;
    switch (widget.typeCamera) {
      case TypeCamera.back:
        lensDirection = CameraLensDirection.back;
        break;
      case TypeCamera.front:
        lensDirection = CameraLensDirection.front;
        break;
    }

    final cameras = await availableCameras();
    final camera = cameras.firstWhere((camera) => camera.lensDirection == lensDirection, orElse: () => cameras.first);
    controller = CameraController(
      camera,
      widget.resolutionPreset.toResolutionPreset(),
      enableAudio: false,
      imageFormatGroup: ImageFormatGroup.yuv420,
    );
    qrCodeDartScanController = widget.controller ?? QRCodeDartScanController();
    await controller!.initialize();
    qrCodeDartScanController.configure(controller!, this);
    if (typeScan == TypeScan.live) {
      _startImageStream();
    }
    postFrame(() {
      setState(() {
        initialized = true;
      });
    });
  }

  void _startImageStream() {
    controller?.startImageStream(_imageStream);
  }

  void _imageStream(CameraImage image) async {
    if (!qrCodeDartScanController.scanEnabled) return;
    if (processingImg) return;
    processingImg = true;
    _processImage(image);
  }

  void _processImage(CameraImage image) async {
    final decoded = await dartScanDecoder.decodeCameraImage(
      image,
      scanInverted: widget.scanInvertedQRCode,
    );

    if (decoded != null && mounted) {
      if (_lastText != decoded.text) {
        _lastText = decoded.text;
        widget.onCapture?.call(decoded);
      }
    }

    processingImg = false;
  }

  @override
  Future<void> takePictureAndDecode() async {
    if (processingImg) return;
    setState(() {
      processingImg = true;
    });
    final xFile = await controller?.takePicture();

    if (xFile != null) {
      final decoded = await dartScanDecoder.decodeFile(
        xFile,
        scanInverted: widget.scanInvertedQRCode,
      );

      if (decoded != null && mounted) {
        widget.onCapture?.call(decoded);
      }
    }

    setState(() {
      processingImg = false;
    });
  }

  Widget _buildButton() {
    return widget.takePictureButtonBuilder?.call(
          context,
          qrCodeDartScanController,
          processingImg,
        ) ??
        _ButtonTakePicture(
          onTakePicture: takePictureAndDecode,
          isLoading: processingImg,
        );
  }

  @override
  Future<void> changeTypeScan(TypeScan type) async {
    if (typeScan == type) {
      return;
    }
    if (typeScan == TypeScan.takePicture) {
      _startImageStream();
    } else {
      await controller?.stopImageStream();
      processingImg = false;
    }
    setState(() {
      typeScan = type;
    });
  }

  Widget _getCameraWidget(BuildContext context) {
    var camera = controller!.value;
    // fetch screen size
    final size = MediaQuery.of(context).size;

    // calculate scale depending on screen and camera ratios
    // this is actually size.aspectRatio / (1 / camera.aspectRatio)
    // because camera preview size is received as landscape
    // but we're calculating for portrait orientation
    Size sizePreview = size;
    if (widget.widthPreview != null && widget.heightPreview != null) {
      sizePreview = Size(widget.widthPreview!, widget.heightPreview!);
    }
    var scale = sizePreview.aspectRatio * camera.aspectRatio;

    // to prevent scaling down, invert the value
    if (scale < 1) scale = 1 / scale;

    return SizedBox(
      width: widget.widthPreview,
      height: widget.heightPreview,
      child: Stack(
        children: [
          Transform.scale(
            scale: scale,
            child: Center(
              child: CameraPreview(
                controller!,
              ),
            ),
          ),
          if (typeScan == TypeScan.takePicture) _buildButton(),
          widget.child ?? const SizedBox.shrink(),
        ],
      ),
    );
  }
}

class _ButtonTakePicture extends StatelessWidget {
  final VoidCallback onTakePicture;
  final bool isLoading;

  const _ButtonTakePicture({
    Key? key,
    required this.onTakePicture,
    this.isLoading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: 150,
        color: Colors.black,
        child: Center(
          child: InkWell(
            onTap: onTakePicture,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(40),
              ),
              child: Container(
                margin: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(40),
                ),
                child: isLoading
                    ? const Center(
                        child: SizedBox(
                          width: 40,
                          height: 40,
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        ),
                      )
                    : const SizedBox.shrink(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}