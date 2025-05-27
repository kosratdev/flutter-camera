import 'package:flutter/material.dart';
import 'package:flutter_camera/camera/widgets/bottom_controls/camera_switcher_button.dart';
import 'package:flutter_camera/camera/widgets/bottom_controls/capture_button.dart';
import 'package:flutter_camera/camera/widgets/bottom_controls/image_thumbnail.dart';

/// A widget that contains the bottom camera controls, including the capture button,
/// camera switcher button, and an image thumbnail of the captured image.
class BottomCameraControls extends StatelessWidget {
  const BottomCameraControls({
    this.capturedImagePath,
    this.onCapture,
    this.onSwitch,
    this.onImageTap,
    super.key,
  });

  final String? capturedImagePath;
  final VoidCallback? onCapture;
  final VoidCallback? onSwitch;
  final VoidCallback? onImageTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      color: Colors.black.withValues(alpha: 0.3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ImageThumbnail(
            capturedImagePath: capturedImagePath,
            onImageTap: onImageTap,
          ),
          CaptureButton(onCapture: onCapture),
          CameraSwitcherButton(onSwitch: onSwitch),
        ],
      ),
    );
  }
}
