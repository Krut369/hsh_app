import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'dart:math' as math;

import 'package:hsh_app/core/theme/app_colors.dart';
import 'package:hsh_app/core/theme/app_theme.dart';

class MobileScannerScreen extends StatefulWidget {
  const MobileScannerScreen({super.key});

  @override
  State<MobileScannerScreen> createState() => _MobileScannerScreenState();
}

class _MobileScannerScreenState extends State<MobileScannerScreen>
    with SingleTickerProviderStateMixin {
  final MobileScannerController _scannerController = MobileScannerController();
  bool _isTorchOn = false;

  late AnimationController _scanLineAnimationController;
  late Animation<double> _scanLineAnimation;

  @override
  void initState() {
    super.initState();
    _scanLineAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _scanLineAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _scanLineAnimationController,
        curve: Curves.easeInOut,
      ),
    );

    _scanLineAnimationController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _scannerController.dispose();
    _scanLineAnimationController.dispose();
    super.dispose();
  }

  // The _showMessage function is no longer needed here as the result is popped back
  // to the previous screen.

  @override
  Widget build(BuildContext context) {
    final double scanAreaSize = MediaQuery.of(context).size.width * 0.7; // Size of the central square

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,

      appBar: AppBar(
        // backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Scan any QR",
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline, color: Colors.white),
            onPressed: () {
              // Handle help action, e.g., show a dialog
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text("Help"),
                    content: const Text("Position the QR code within the scanning frame."),
                    actions: <Widget>[
                      TextButton(
                        child: const Text("OK"),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          // 1. Mobile Scanner (Background) - This displays the camera feed
          MobileScanner(
            controller: _scannerController,
            onDetect: (BarcodeCapture capture) {
              final List<Barcode> barcodes = capture.barcodes;
              for (final barcode in barcodes) {
                final String? code = barcode.rawValue;
                if (code != null) {
                  if (mounted) {
                    // Stop the scanner to prevent continuous scanning after detection
                    _scannerController.stop();
                    // Pop the screen and return the scanned code
                    Navigator.pop(context, code);
                  }
                  break; // Only process the first detected barcode
                }
              }
            },
            // Configure the scan window to help the scanner focus on the central area
            scanWindow: Rect.fromCenter(
              center: Offset(
                MediaQuery.of(context).size.width / 2,
                MediaQuery.of(context).size.height / 2,
              ),
              width: scanAreaSize,
              height: scanAreaSize,
            ),
          ),

          // 2. Overlay with "blurred" effect (semi-transparent black) and cut-out
          CustomPaint(
            size: Size.infinite, // Cover the entire screen
            painter: ScannerOverlayPainter(scanAreaSize: scanAreaSize),
          ),

          // 3. Central Scanning Frame with Animation (on top of overlay)
          Align(
            alignment: Alignment.center,
            child: SizedBox( // Use SizedBox instead of Container if no decoration
              width: scanAreaSize,
              height: scanAreaSize,
              child: Stack(
                children: [
                  CustomPaint(
                    painter: ScannerCornersPainter(),
                  ),
                  AnimatedBuilder(
                    animation: _scanLineAnimation,
                    builder: (context, child) {
                      const double lineHeight = 3.0;
                      return Positioned(
                        top: _scanLineAnimation.value * (scanAreaSize - lineHeight),
                        left: 0,
                        right: 0,
                        child: Container(
                          height: lineHeight,
                          color: AppColors.primary,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),

          // 4. Bottom Controls and Text
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 40.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildActionButton(
                        icon: _isTorchOn ? Icons.flash_on : Icons.flash_off,
                        label: "Torch",
                        onPressed: () {
                          setState(() {
                            _isTorchOn = !_isTorchOn;
                          });
                          _scannerController.toggleTorch();
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 50),
                  Text(
                    "HSH Hostel Scanner",

                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: Icon(icon, color: AppColors.primary),
            onPressed: onPressed,
            iconSize: 30,
            padding: const EdgeInsets.all(15),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(color: AppColors.textPrimary),
        ),
      ],
    );
  }
}

/// A custom painter that draws a semi-transparent overlay with a transparent hole in the center.
class ScannerOverlayPainter extends CustomPainter {
  final double scanAreaSize;
  ScannerOverlayPainter({required this.scanAreaSize});

  @override
  void paint(Canvas canvas, Size size) {
    final double cornerRadius = 10.0; // Same as in ScannerCornersPainter

    // Paint for the overlay
    final Paint overlayPaint = Paint()
      ..color = Colors.black.withOpacity(0.6); // Adjust opacity for desired "blur" effect

    // Create a path that covers the entire canvas
    final Path fullPath = Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height));

    // Calculate the dimensions of the transparent hole
    final double holeLeft = (size.width - scanAreaSize) / 2;
    final double holeTop = (size.height - scanAreaSize) / 2;
    final Rect holeRect = Rect.fromLTWH(holeLeft, holeTop, scanAreaSize, scanAreaSize);
    final RRect holeRRect = RRect.fromRectAndRadius(holeRect, Radius.circular(cornerRadius));

    // Subtract the rounded rectangle hole from the full path
    final Path cutOutPath = Path.combine(
      PathOperation.difference,
      fullPath,
      Path()..addRRect(holeRRect),
    );

    canvas.drawPath(cutOutPath, overlayPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

/// A custom painter that draws a complete square border with rounded corners.
/// Each side segment has a different color using a SweepGradient.
class ScannerCornersPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const double cornerRadius = 10.0;
    const double strokeWidth = 5.0;

    // Define colors for each side/corner segment
    const Color topColor = Color(0xFFFF6A6A); // Reddish-orange
    const Color rightColor = Color(0xFFFFA500); // Orange
    const Color bottomColor = Color(0xFF4169E1); // Blue
    const Color leftColor = Color(0xFF32CD32); // Green

    // Define the rect for the rounded rectangle border
    final Rect rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final RRect rrect = RRect.fromRectAndRadius(rect, Radius.circular(cornerRadius));

    final double horizontalLength = size.width - 2 * cornerRadius;
    final double verticalLength = size.height - 2 * cornerRadius;
    final double totalLength = 2 * (horizontalLength + verticalLength) + 2 * math.pi * cornerRadius;

    final List<Color> colors = [
      topColor,
      rightColor,
      bottomColor,
      leftColor,
      topColor, // Loop back to top for smooth transition
    ];

    final List<double> stops = [
      0.0, // Start point (adjusted by startAngle)
      (horizontalLength + math.pi * cornerRadius / 2) / totalLength, // End of top straight + first corner arc
      (horizontalLength + verticalLength + math.pi * cornerRadius) / totalLength, // End of right straight + second corner arc
      (2 * horizontalLength + verticalLength + 3 * math.pi * cornerRadius / 2) / totalLength, // End of bottom straight + third corner arc
      1.0, // End of left straight + final corner arc (completing the circle)
    ];

    final Paint paint = Paint()
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..shader = SweepGradient(
        center: Alignment.center,
        // Adjust startAngle to make `topColor` start at the top middle.
        // A sweep gradient typically starts at 3 o'clock (0 radians).
        // Top middle is -90 degrees or -math.pi / 2 radians.
        startAngle: -math.pi / 2,
        endAngle: (3 * math.pi) / 2, // A full circle from -math.pi/2
        colors: colors,
        stops: stops,
        tileMode: TileMode.clamp,
      ).createShader(rect);

    canvas.drawRRect(rrect, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}