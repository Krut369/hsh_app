import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart' as ms;

class AppScannerController extends GetxController with GetSingleTickerProviderStateMixin {
  final ms.MobileScannerController nativeScannerController = ms.MobileScannerController();
  
  late AnimationController scanLineAnimationController;
  late Animation<double> scanLineAnimation;

  @override
  void onInit() {
    super.onInit();
    
    scanLineAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    scanLineAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: scanLineAnimationController,
        curve: Curves.easeInOut,
      ),
    );

    scanLineAnimationController.repeat(reverse: true);
  }

  void toggleTorch() {
    nativeScannerController.toggleTorch();
  }

  void onDetect(ms.BarcodeCapture capture, BuildContext context) {
    final List<ms.Barcode> barcodes = capture.barcodes;
    for (final barcode in barcodes) {
      final String? code = barcode.rawValue;
      if (code != null) {
        nativeScannerController.stop();
        Navigator.pop(context, code);
        break;
      }
    }
  }

  @override
  void onClose() {
    // Ensure torch is off before disposal
    if (nativeScannerController.torchState.value == ms.TorchState.on) {
      nativeScannerController.toggleTorch();
    }
    nativeScannerController.dispose();
    scanLineAnimationController.dispose();
    super.onClose();
  }
}
