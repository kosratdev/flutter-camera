import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_camera/camera/widgets/bottom_controls/bottom_camera_controls.dart';
import 'package:flutter_camera/camera/widgets/image_preview.dart';
import 'package:flutter_camera/camera/widgets/top_controls/top_camera_controls.dart';
import 'package:flutter_camera/camera/widgets/camera_preview/app_camera_preview.dart';

/// A screen that displays the camera preview and allows the user to take pictures.
class CameraScreen extends StatefulWidget {
  const CameraScreen({required this.cameras, super.key});

  final List<CameraDescription> cameras;
  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen>
    with WidgetsBindingObserver {
  CameraController? _controller;
  XFile? _imageFile;
  FlashMode _flashMode = FlashMode.auto;
  double _minAvailableZoom = 1.0;
  double _maxAvailableZoom = 1.0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeCameraController(widget.cameras[0]);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final CameraController? cameraController = _controller;

    // App state changed before we got the chance to initialize.
    if (cameraController == null || !cameraController.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      cameraController.dispose();
    } else if (state == AppLifecycleState.resumed) {
      _initializeCameraController(cameraController.description);
    }
  }

  /// Initializes the camera controller with the given [cameraDescription].
  Future<void> _initializeCameraController(
    CameraDescription cameraDescription,
  ) async {
    final CameraController cameraController = CameraController(
      cameraDescription,
      kIsWeb ? ResolutionPreset.max : ResolutionPreset.medium,
      imageFormatGroup: ImageFormatGroup.jpeg,
    );

    _controller = cameraController;

    // If the controller is updated then update the UI.
    cameraController.addListener(() {
      if (mounted) {
        setState(() {});
      }
      if (cameraController.value.hasError) {
        showInSnackBar(
          'Camera error ${cameraController.value.errorDescription}',
        );
      }
    });

    try {
      await cameraController.initialize();
      await Future.wait(<Future<Object?>>[
        cameraController.setExposureMode(ExposureMode.auto),
        cameraController.setFocusMode(FocusMode.auto),
        cameraController.getMaxZoomLevel().then(
          (double value) => _maxAvailableZoom = value,
        ),
        cameraController.getMinZoomLevel().then(
          (double value) => _minAvailableZoom = value,
        ),
      ]);
    } on CameraException catch (e) {
      switch (e.code) {
        case 'CameraAccessDenied':
          showInSnackBar('You have denied camera access.');
        case 'CameraAccessDeniedWithoutPrompt':
          // iOS only
          showInSnackBar('Please go to Settings app to enable camera access.');
        case 'CameraAccessRestricted':
          // iOS only
          showInSnackBar('Camera access is restricted.');
        case 'AudioAccessDenied':
          showInSnackBar('You have denied audio access.');
        case 'AudioAccessDeniedWithoutPrompt':
          // iOS only
          showInSnackBar('Please go to Settings app to enable audio access.');
        case 'AudioAccessRestricted':
          // iOS only
          showInSnackBar('Audio access is restricted.');
        default:
          _showCameraException(e);
      }
    }

    if (mounted) {
      setState(() {});
    }
  }

  /// Takes a picture and updates the state with the captured image file.
  void onTakePicture() {
    takePicture().then((XFile? file) {
      if (mounted) {
        setState(() {
          _imageFile = file;
        });
      }
    });
  }

  /// Takes a picture using the camera controller and returns the captured image file.
  Future<XFile?> takePicture() async {
    final CameraController? cameraController = _controller;
    if (cameraController == null || !cameraController.value.isInitialized) {
      return null;
    }

    if (cameraController.value.isTakingPicture) {
      return null;
    }

    try {
      final XFile file = await cameraController.takePicture();
      return file;
    } on CameraException catch (e) {
      _showCameraException(e);
      return null;
    }
  }

  /// Toggles the flash mode between auto, always on, and off.
  void toggleFlash() {
    switch (_flashMode) {
      case FlashMode.auto:
        setFlashMode(FlashMode.always);
        break;
      case FlashMode.always:
        setFlashMode(FlashMode.off);
        break;
      case FlashMode.off:
        setFlashMode(FlashMode.auto);
        break;
      default:
        setFlashMode(FlashMode.auto);
        break;
    }
  }

  /// Sets the flash mode for the camera controller.
  void setFlashMode(FlashMode mode) {
    final CameraController? cameraController = _controller;

    if (cameraController == null || !cameraController.value.isInitialized) {
      return;
    }

    try {
      cameraController.setFlashMode(mode);
      setState(() {
        _flashMode = mode;
      });
    } on CameraException catch (e) {
      _showCameraException(e);
    }
  }

  /// Change the zoom level of the camera based on the provided [zoomValue].
  void zoomCamera(double zoomValue) {
    if (_controller == null || !_controller!.value.isInitialized) {
      return;
    }
    final double zoomLevel = zoomValue.clamp(
      _minAvailableZoom,
      _maxAvailableZoom,
    );
    _controller?.setZoomLevel(zoomLevel);
  }

  /// Switches the camera between the front and back cameras if available.
  void switchCamera() {
    final int nextCameraIndex =
        (widget.cameras.length > 1 &&
                widget.cameras.indexOf(_controller!.description) == 0)
            ? 1
            : 0;
    _initializeCameraController(widget.cameras[nextCameraIndex]);
  }

  /// Shows the image preview of the captured image if available.
  void showImagePreview() {
    if (_imageFile != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder:
              (context) => ImagePreview(capturedImagePath: _imageFile?.path),
        ),
      );
    }
  }

  /// Displays a message in a SnackBar.
  void showInSnackBar(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  /// Shows a camera exception message in a SnackBar.
  void _showCameraException(CameraException e) {
    showInSnackBar('Error: ${e.code}\n${e.description}');
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null || !_controller!.value.isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            TopCameraControls(flashMode: _flashMode, toggleFlash: toggleFlash),
            Expanded(
              child: AppCameraPreview(
                camera: widget.cameras[0],
                controller: _controller,
                onZoomChanged: zoomCamera,
              ),
            ),
            BottomCameraControls(
              capturedImagePath: _imageFile?.path,
              onSwitch: switchCamera,
              onCapture: onTakePicture,
              onImageTap: showImagePreview,
            ),
          ],
        ),
      ),
    );
  }
}
