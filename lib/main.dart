import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_camera/camera/camera_screen.dart';

/// CameraApp is the Main Application.
class CameraApp extends StatelessWidget {
  const CameraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: CameraScreen(cameras: _cameras));
  }
}

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
  runApp(const CameraApp());
}
