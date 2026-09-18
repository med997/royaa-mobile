import 'package:camera/camera.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import 'glasses_overlay_painter.dart';

class ArTryOnScreen extends StatefulWidget {
  const ArTryOnScreen({super.key});

  @override
  State<ArTryOnScreen> createState() => _ArTryOnScreenState();
}

class _ArTryOnScreenState extends State<ArTryOnScreen> {
  CameraController? _controller;
  String? _error;

  @override
  void initState() {
    super.initState();
    _setup();
  }

  Future<void> _setup() async {
    final status = await Permission.camera.request();
    if (!status.isGranted) {
      setState(() => _error = 'camera_permission_denied'.tr());
      return;
    }

    final cameras = await availableCameras();
    final front = cameras.firstWhere(
      (c) => c.lensDirection == CameraLensDirection.front,
      orElse: () => cameras.first,
    );
    final controller = CameraController(front, ResolutionPreset.medium, enableAudio: false);
    await controller.initialize();
    if (!mounted) return;
    setState(() => _controller = controller);
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(title: Text('ar_tryon'.tr()), backgroundColor: Colors.transparent, elevation: 0),
      extendBodyBehindAppBar: true,
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_error != null) {
      return Center(child: Text(_error!, style: const TextStyle(color: Colors.white)));
    }
    final controller = _controller;
    if (controller == null) {
      return const Center(child: CircularProgressIndicator(color: Colors.white));
    }
    return Stack(
      fit: StackFit.expand,
      children: [
        CameraPreview(controller),
        const CustomPaint(painter: GlassesOverlayPainter()),
        Positioned(
          bottom: 32,
          left: 0,
          right: 0,
          child: Text(
            'ar_tryon_hint'.tr(),
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}
