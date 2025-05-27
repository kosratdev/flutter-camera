import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_camera/camera/widgets/top_controls/close_camera_button.dart';
import 'package:flutter_camera/camera/widgets/top_controls/flash_button.dart';

/// A widget that contains the top camera controls,
/// including a close button and a flash toggle button.
class TopCameraControls extends StatelessWidget {
  const TopCameraControls({this.flashMode, this.toggleFlash, super.key});

  final FlashMode? flashMode;
  final VoidCallback? toggleFlash;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CloseCameraButton(),
          FlashButton(flashMode: flashMode, toggleFlash: toggleFlash),
        ],
      ),
    );
  }
}
