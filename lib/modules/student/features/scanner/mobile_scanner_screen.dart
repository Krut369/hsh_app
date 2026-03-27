import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'dart:math' as math;
import 'package:uitoolkit/uitoolkit.dart' as ui;
import 'controllers/mobile_scanner_controller.dart';

class AppScannerScreen extends StatelessWidget {
  const AppScannerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final double scanAreaSize = MediaQuery.of(context).size.width * 0.7;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF121212) : const Color(0xFFEBF3F5);
    final headerColor = const Color(0xFF1D3557);

    return GetBuilder<AppScannerController>(
      init: AppScannerController(),
      dispose: (_) => Get.delete<AppScannerController>(),
      builder: (controller) {
        return ui.ModernScaffold(
          backgroundColor: bgColor,
          body: Stack(
            children: [
              // 1. Mobile Scanner (Background)
              MobileScanner(
                controller: controller.nativeScannerController,
                onDetect: (BarcodeCapture capture) => controller.onDetect(capture, context),
                scanWindow: Rect.fromCenter(
                  center: Offset(
                    MediaQuery.of(context).size.width / 2,
                    MediaQuery.of(context).size.height / 2,
                  ),
                  width: scanAreaSize,
                  height: scanAreaSize,
                ),
              ),

              // 2. Overlay with cut-out
              CustomPaint(
                size: Size.infinite,
                painter: ScannerOverlayPainter(
                  scanAreaSize: scanAreaSize,
                  overlayColor: bgColor, // Use opaque background color
                ),
              ),

              // 3. Central Scanning Frame
              Align(
                alignment: Alignment.center,
                child: Container(
                  width: scanAreaSize,
                  height: scanAreaSize,
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xFF4169E1).withOpacity(0.5), width: 1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Stack(
                    children: [
                      CustomPaint(
                        size: Size(scanAreaSize, scanAreaSize),
                        painter: ScannerCornersPainter(),
                      ),
                      AnimatedBuilder(
                        animation: controller.scanLineAnimation,
                        builder: (context, child) {
                          const double lineHeight = 2.0;
                          return Positioned(
                            top: controller.scanLineAnimation.value * (scanAreaSize - lineHeight),
                            left: 0,
                            right: 0,
                            child: Container(
                              height: lineHeight,
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFF4169E1).withOpacity(0.5),
                                    blurRadius: 4,
                                    spreadRadius: 1,
                                  ),
                                ],
                                color: const Color(0xFF4169E1),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),

              // 4. Custom Header
              Container(
                height: 120, // Adjusted height
                decoration: BoxDecoration(
                  color: headerColor,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(24),
                    bottomRight: Radius.circular(24),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top, left: 16, right: 16),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white, size: 28),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    const SizedBox(width: 8),
                    const ui.ModernText(
                      "Scan any QR",
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.help_outline, color: Colors.white, size: 28),
                      onPressed: () {
                        // Help dialog
                      },
                    ),
                  ],
                ),
              ),

              // 5. Bottom Controls
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 80.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      GestureDetector(
                        onTap: controller.toggleTorch,
                        child: Column(
                          children: [
                            ValueListenableBuilder<TorchState>(
                              valueListenable: controller.nativeScannerController.torchState,
                              builder: (context, state, child) {
                                final isOn = state == TorchState.on;
                                return Container(
                                  width: 60,
                                  height: 60,
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black12,
                                        blurRadius: 8,
                                        spreadRadius: 1,
                                      ),
                                    ],
                                  ),
                                  child: Icon(
                                    isOn ? Icons.flashlight_on : Icons.flashlight_off,
                                    color: const Color(0xFF1D3557),
                                    size: 24,
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 8),
                            const ui.ModernText(
                              "Torch",
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF1D3557),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),
                      const ui.ModernText(
                        "HSH Hostel Scanner",
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1D3557),
                        letterSpacing: 0.2,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class ScannerOverlayPainter extends CustomPainter {
  final double scanAreaSize;
  final Color overlayColor;
  ScannerOverlayPainter({
    required this.scanAreaSize,
    this.overlayColor = const Color(0x99000000),
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint overlayPaint = Paint()..color = overlayColor;
    final Path fullPath = Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height));

    final double holeLeft = (size.width - scanAreaSize) / 2;
    final double holeTop = (size.height - scanAreaSize) / 2;
    final Rect holeRect = Rect.fromLTWH(holeLeft, holeTop, scanAreaSize, scanAreaSize);
    final RRect holeRRect = RRect.fromRectAndRadius(holeRect, const Radius.circular(12));

    final Path cutOutPath = Path.combine(
      PathOperation.difference,
      fullPath,
      Path()..addRRect(holeRRect),
    );

    canvas.drawPath(cutOutPath, overlayPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class ScannerCornersPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = const Color(0xFF4169E1)
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    const double cornerLength = 20.0;
    const double radius = 12.0;

    // Top Left
    canvas.drawArc(
      Rect.fromLTWH(0, 0, radius * 2, radius * 2),
      math.pi,
      math.pi / 2,
      false,
      paint,
    );
    canvas.drawLine(const Offset(radius, 0), const Offset(radius + cornerLength, 0), paint);
    canvas.drawLine(const Offset(0, radius), const Offset(0, radius + cornerLength), paint);

    // Top Right
    canvas.drawArc(
      Rect.fromLTWH(size.width - radius * 2, 0, radius * 2, radius * 2),
      -math.pi / 2,
      math.pi / 2,
      false,
      paint,
    );
    canvas.drawLine(Offset(size.width - radius, 0), Offset(size.width - radius - cornerLength, 0), paint);
    canvas.drawLine(Offset(size.width, radius), Offset(size.width, radius + cornerLength), paint);

    // Bottom Left
    canvas.drawArc(
      Rect.fromLTWH(0, size.height - radius * 2, radius * 2, radius * 2),
      math.pi / 2,
      math.pi / 2,
      false,
      paint,
    );
    canvas.drawLine(Offset(radius, size.height), Offset(radius + cornerLength, size.height), paint);
    canvas.drawLine(Offset(0, size.height - radius), Offset(0, size.height - radius - cornerLength), paint);

    // Bottom Right
    canvas.drawArc(
      Rect.fromLTWH(size.width - radius * 2, size.height - radius * 2, radius * 2, radius * 2),
      0,
      math.pi / 2,
      false,
      paint,
    );
    canvas.drawLine(Offset(size.width - radius, size.height), Offset(size.width - radius - cornerLength, size.height), paint);
    canvas.drawLine(Offset(size.width, size.height - radius), Offset(size.width, size.height - radius - cornerLength), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
