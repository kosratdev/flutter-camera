import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

/// A widget that allows the user to toggle the camera flash mode.
class FlashButton extends StatelessWidget {
  const FlashButton({this.flashMode, this.toggleFlash, super.key});

  final FlashMode? flashMode;
  final VoidCallback? toggleFlash;

  /// Returns the appropriate icon based on the current flash mode.
  IconData get flashIcon {
    switch (flashMode) {
      case FlashMode.always:
      case FlashMode.torch:
        return Icons.flash_on_rounded;
      case FlashMode.off:
        return Icons.flash_off_rounded;
      case FlashMode.auto:
      default:
        return Icons.flash_auto_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return IconButton.filled(
      style: IconButton.styleFrom(
        backgroundColor: Colors.black.withValues(alpha: 0.3),
      ),
      icon: Icon(flashIcon, color: Colors.white, size: 30),
      onPressed: toggleFlash,
    );
  }
}
