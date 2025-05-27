import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

/// A widget that displays the camera preview and allows zooming in and outs
class AppCameraPreview extends StatefulWidget {
  const AppCameraPreview({
    required this.camera,
    required this.controller,
    this.onZoomChanged,
    super.key,
  });

  final CameraDescription camera;
  final CameraController? controller;
  final Function(double)? onZoomChanged;

  @override
  State<AppCameraPreview> createState() => _AppCameraPreviewState();
}

class _AppCameraPreviewState extends State<AppCameraPreview> {
  double _currentScale = 1.0;
  double _baseScale = 1.0;
  int _fingers = 0;

  /// Handles the start of a scale gesture.
  void _handleScaleStart(ScaleStartDetails details) {
    _baseScale = _currentScale;
  }

  /// Handles the update of a scale gesture.
  Future<void> _handleScaleUpdate(ScaleUpdateDetails details) async {
    if (widget.controller == null || _fingers != 2) {
      return;
    }

    _currentScale = (_baseScale * details.scale);
    widget.onZoomChanged?.call(_currentScale);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.controller == null || !widget.controller!.value.isInitialized) {
      return Center(child: const Text('Camera is not initialized yet.'));
    } else {
      return Listener(
        onPointerDown: (_) => _fingers++,
        onPointerUp: (_) => _fingers--,
        child: Center(
          child: CameraPreview(
            widget.controller!,
            child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                return GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onScaleStart: _handleScaleStart,
                  onScaleUpdate: _handleScaleUpdate,
                );
              },
            ),
          ),
        ),
      );
    }
  }
}
