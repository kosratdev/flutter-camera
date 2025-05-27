import 'package:flutter/material.dart';

/// A button that allows the user to capture an image using the camera.
class CaptureButton extends StatelessWidget {
  const CaptureButton({this.onCapture, super.key});

  final VoidCallback? onCapture;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 70,
      height: 70,
      child: FilledButton(
        onPressed: onCapture,
        style: FilledButton.styleFrom(
          backgroundColor: Colors.white,
          shape: CircleBorder(side: BorderSide(color: Colors.grey, width: 3)),
          padding: EdgeInsets.zero,
        ),
        child: null,
      ),
    );
  }
}
