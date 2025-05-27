import 'dart:io';

import 'package:flutter/material.dart';

/// A widget that displays a thumbnail of the captured image.
class ImageThumbnail extends StatelessWidget {
  const ImageThumbnail({this.capturedImagePath, this.onImageTap, super.key});

  final String? capturedImagePath;
  final VoidCallback? onImageTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onImageTap,
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(8),
          image:
              capturedImagePath != null
                  ? DecorationImage(
                    image: Image.file(File(capturedImagePath!)).image,
                    fit: BoxFit.cover,
                  )
                  : null,
        ),
        child:
            capturedImagePath == null
                ? const Icon(
                  Icons.photo_library,
                  color: Colors.white70,
                  size: 24,
                )
                : null,
      ),
    );
  }
}
