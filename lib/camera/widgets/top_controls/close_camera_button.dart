import 'package:flutter/material.dart';

/// A button that allows the user to close the camera view.
class CloseCameraButton extends StatelessWidget {
  const CloseCameraButton({this.onPressed, super.key});

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton.filled(
      style: IconButton.styleFrom(
        backgroundColor: Colors.black.withValues(alpha: 0.3),
      ),
      icon: const Icon(Icons.close_rounded, color: Colors.white, size: 30),
      onPressed:
          onPressed ??
          () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            }
          },
    );
  }
}
