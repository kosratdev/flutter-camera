import 'dart:io';

import 'package:flutter/material.dart';

/// A widget that displays the preview of a captured image.
class ImagePreview extends StatelessWidget {
  const ImagePreview({this.capturedImagePath, super.key});

  final String? capturedImagePath;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Captured Image Preview')),
      body: SafeArea(
        minimum: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16.0),
                child: Image.file(File(capturedImagePath ?? '')),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
