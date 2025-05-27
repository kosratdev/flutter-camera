# flutter_camera

[![style: effective dart](https://img.shields.io/badge/style-effective_dart-40c4ff.svg)](https://github.com/tenhobi/effective_dart)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

A Flutter app example to access camera features.

## Features

- Display live camera preview.
- Capture photos.
- Switch between front and back cameras.
- Control flash mode.
- Display the captured imaged.

## Getting Started

To use this example, add `flutter_camera` as a [dependency in your pubspec.yaml file](https://flutter.dev/docs/development/platform-integration/platform-channels).

## Usage

Here's a simple example of how to use the `FlutterCameraScreen` widget:

```dart
import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_camera/camera/flutter_camera_screen.dart';

List<CameraDescription> _cameras = <CameraDescription>[];

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    _cameras = await availableCameras();
  } on CameraException catch (e) {
    if (kDebugMode) {
      debugPrint('Error fetching cameras: ${e.code} - ${e.description}');
    }
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: FlutterCameraScreen(cameras: _cameras));
  }
}
```

For more detailed implementation, please refer to the [`flutter_camera_screen.dart`](/lib/camera/flutter_camera_screen.dart) widget.
