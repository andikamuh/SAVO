import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum CameraOverlayType { ktm, face, none }

class CustomCameraScreen extends StatefulWidget {
  final bool isFrontCamera;
  final CameraOverlayType overlayType;

  const CustomCameraScreen({
    Key? key,
    required this.isFrontCamera,
    required this.overlayType,
  }) : super(key: key);

  @override
  _CustomCameraScreenState createState() => _CustomCameraScreenState();
}

class _CustomCameraScreenState extends State<CustomCameraScreen> with WidgetsBindingObserver {
  List<CameraDescription> _cameras = [];
  CameraController? _controller;
  bool _isReady = false;
  bool _isCaptureInProcess = false;
  late bool _isFront;
  FlashMode _flashMode = FlashMode.off;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _isFront = widget.isFrontCamera;
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    try {
      _cameras = await availableCameras();
      if (_cameras.isEmpty) {
        Get.snackbar(
          'Error',
          'Kamera tidak ditemukan pada perangkat ini.',
          backgroundColor: Colors.red.shade50,
          colorText: Colors.red.shade900,
        );
        return;
      }

      // Find preferred camera
      CameraDescription selectedCamera = _cameras.first;
      for (var camera in _cameras) {
        if (_isFront && camera.lensDirection == CameraLensDirection.front) {
          selectedCamera = camera;
          break;
        } else if (!_isFront && camera.lensDirection == CameraLensDirection.back) {
          selectedCamera = camera;
          break;
        }
      }

      final controller = CameraController(
        selectedCamera,
        ResolutionPreset.high,
        enableAudio: false,
      );

      _controller = controller;

      await controller.initialize();
      await controller.setFlashMode(_flashMode);

      if (mounted) {
        setState(() {
          _isReady = true;
        });
      }
    } catch (e) {
      debugPrint("Gagal menginisialisasi kamera: $e");
      Get.snackbar(
        'Gagal Kamera',
        'Gagal membuka kamera: $e',
        backgroundColor: Colors.red.shade50,
        colorText: Colors.red.shade900,
      );
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller?.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final CameraController? cameraController = _controller;

    if (cameraController == null || !cameraController.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      cameraController.dispose();
    } else if (state == AppLifecycleState.resumed) {
      _initializeCamera();
    }
  }

  Future<void> _toggleCamera() async {
    setState(() {
      _isReady = false;
      _isFront = !_isFront;
    });
    await _controller?.dispose();
    _initializeCamera();
  }

  Future<void> _toggleFlash() async {
    if (_controller == null || !_controller!.value.isInitialized) return;
    
    FlashMode nextMode;
    switch (_flashMode) {
      case FlashMode.off:
        nextMode = FlashMode.torch; // Continuous light for photo guiding
        break;
      case FlashMode.torch:
        nextMode = FlashMode.auto;
        break;
      case FlashMode.auto:
      default:
        nextMode = FlashMode.off;
        break;
    }

    try {
      await _controller!.setFlashMode(nextMode);
      setState(() {
        _flashMode = nextMode;
      });
    } catch (e) {
      debugPrint("Gagal mengubah flash mode: $e");
    }
  }

  Future<void> _takePicture() async {
    if (_controller == null || !_controller!.value.isInitialized || _isCaptureInProcess) return;

    setState(() {
      _isCaptureInProcess = true;
    });

    try {
      final XFile file = await _controller!.takePicture();
      Get.back(result: File(file.path));
    } catch (e) {
      debugPrint("Gagal mengambil foto: $e");
      Get.snackbar(
        'Gagal Mengambil Foto',
        'Gagal mengambil foto dari kamera: $e',
        backgroundColor: Colors.red.shade50,
        colorText: Colors.red.shade900,
      );
    } finally {
      if (mounted) {
        setState(() {
          _isCaptureInProcess = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isReady || _controller == null || !_controller!.value.isInitialized) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF1EC8C8)),
              ),
              SizedBox(height: 16),
              Text(
                'Menyiapkan Kamera...',
                style: TextStyle(color: Colors.white70, fontSize: 14),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Camera Preview
          CameraPreview(_controller!),

          // Custom Overlay
          CustomPaint(
            painter: CameraOverlayPainter(type: widget.overlayType),
          ),

          // Top controls (Close, Flash)
          Positioned(
            top: MediaQuery.of(context).padding.top + 12,
            left: 16,
            right: 16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Close button
                GestureDetector(
                  onTap: () => Get.back(),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.close_rounded,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ),
                
                // Flash mode button (only for back camera)
                if (!_isFront)
                  GestureDetector(
                    onTap: _toggleFlash,
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.5),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        _flashMode == FlashMode.torch
                            ? Icons.flash_on_rounded
                            : _flashMode == FlashMode.auto
                                ? Icons.flash_auto_rounded
                                : Icons.flash_off_rounded,
                        color: _flashMode == FlashMode.torch ? const Color(0xFF1EC8C8) : Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // Guideline instruction text
          if (widget.overlayType != CameraOverlayType.none)
            Positioned(
              top: MediaQuery.of(context).size.height * 0.18,
              left: 24,
              right: 24,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    widget.overlayType == CameraOverlayType.face
                        ? 'Posisikan Wajah Anda di dalam Oval'
                        : 'Posisikan Kartu KTM Anda di dalam Kotak',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),

          // Bottom capture button and controls
          Positioned(
            bottom: MediaQuery.of(context).padding.bottom + 32,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Placeholder/Space
                const SizedBox(width: 56),

                // Capture Button
                GestureDetector(
                  onTap: _takePicture,
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 4),
                    ),
                    padding: const EdgeInsets.all(6),
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: _isCaptureInProcess
                          ? const Padding(
                              padding: EdgeInsets.all(12.0),
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF1EC8C8)),
                                strokeWidth: 3,
                              ),
                            )
                          : null,
                    ),
                  ),
                ),

                // Switch Camera Button
                GestureDetector(
                  onTap: _toggleCamera,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.flip_camera_android_rounded,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CameraOverlayPainter extends CustomPainter {
  final CameraOverlayType type;

  CameraOverlayPainter({required this.type});

  @override
  void paint(Canvas canvas, Size size) {
    if (type == CameraOverlayType.none) {
      return;
    }
    final paint = Paint()
      ..color = Colors.black.withOpacity(0.7)
      ..style = PaintingStyle.fill;

    // Background rect
    final backgroundPath = Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height));

    final cutoutPath = Path();

    if (type == CameraOverlayType.face) {
      // Oval cutout in the center
      final width = size.width * 0.65;
      final height = size.width * 0.90;
      final rect = Rect.fromCenter(
        center: Offset(size.width / 2, size.height / 2.2),
        width: width,
        height: height,
      );
      cutoutPath.addOval(rect);
    } else {
      // Card rectangle cutout in the center
      final width = size.width * 0.85;
      final height = width * 0.63; // ~1.35 aspect ratio for ID cards
      final rect = Rect.fromCenter(
        center: Offset(size.width / 2, size.height / 2.2),
        width: width,
        height: height,
      );
      cutoutPath.addRRect(RRect.fromRectAndRadius(rect, const Radius.circular(16)));
    }

    // Cutout overlay
    final finalPath = Path.combine(
      PathOperation.difference,
      backgroundPath,
      cutoutPath,
    );

    canvas.drawPath(finalPath, paint);

    // Glowing border around cutout
    final borderPaint = Paint()
      ..color = const Color(0xFF1EC8C8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    if (type == CameraOverlayType.face) {
      final width = size.width * 0.65;
      final height = size.width * 0.90;
      final rect = Rect.fromCenter(
        center: Offset(size.width / 2, size.height / 2.2),
        width: width,
        height: height,
      );
      canvas.drawOval(rect, borderPaint);
    } else {
      final width = size.width * 0.85;
      final height = width * 0.63;
      final rect = Rect.fromCenter(
        center: Offset(size.width / 2, size.height / 2.2),
        width: width,
        height: height,
      );
      canvas.drawRRect(RRect.fromRectAndRadius(rect, const Radius.circular(16)), borderPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
