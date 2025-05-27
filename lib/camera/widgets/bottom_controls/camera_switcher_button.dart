import 'package:flutter/material.dart';

/// A button that allows the user to switch between front and back cameras.
class CameraSwitcherButton extends StatelessWidget {
  const CameraSwitcherButton({this.onSwitch, super.key});

  final VoidCallback? onSwitch;
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(
        Icons.cameraswitch_rounded,
        color: Colors.white,
        size: 30,
      ),
      onPressed: onSwitch,
    );
  }
}
