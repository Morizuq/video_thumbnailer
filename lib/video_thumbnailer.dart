// import 'package:flutter/services.dart';

import 'dart:convert';
import 'dart:typed_data';

import 'video_thumbnailer_platform_interface.dart';

enum ImageFormat { jpeg, png, webp }

extension ImageFormatExtension on ImageFormat {
  String get name {
    switch (this) {
      case ImageFormat.jpeg:
        return 'jpeg';
      case ImageFormat.png:
        return 'png';
      case ImageFormat.webp:
        return 'webp';
    }
  }
}

/// A utility class for generating video thumbnails in various formats.
///
/// Provides methods to generate thumbnails as file paths, raw byte data,
/// or base64-encoded strings. Supports customization of output format,
/// dimensions, quality, and extraction time.
///
/// Example usage:
/// ```dart
/// final thumbnailPath = await VideoThumbnailer.generateThumbnail(
///   videoPath: 'path/to/video.mp4',
///   time: 1000, // in milliseconds
///   format: ImageFormat.png,
///   maxWidth: 320,
///   maxHeight: 240,
///   quality: 80,
/// );
/// ```

class VideoThumbnailer {
  static Future<String?> generateThumbnail({
    required String videoPath,
    String? thumbnailPath,
    int time = 0,
    ImageFormat format = ImageFormat.jpeg,
    int maxWidth = 0,
    int maxHeight = 0,
    int quality = 75,
  }) {
    return VideoThumbnailerPlatform.instance.generateThumbnail(
      videoPath: videoPath,
      thumbnailPath: thumbnailPath,
      time: time,
      format: format.name,
      maxWidth: maxWidth,
      maxHeight: maxHeight,
      quality: quality,
    );
  }

  static Future<Uint8List?> generateThumbnailData({
    required String videoPath,
    int time = 0,
    ImageFormat format = ImageFormat.jpeg,
    int maxWidth = 0,
    int maxHeight = 0,
    int quality = 75,
  }) {
    return VideoThumbnailerPlatform.instance.generateThumbnailData(
      videoPath: videoPath,
      time: time,
      format: format.name,
      maxWidth: maxWidth,
      maxHeight: maxHeight,
      quality: quality,
    );
  }

  static Future<String?> generateThumbnailBase64({
    required String videoPath,
    int time = 0,
    ImageFormat format = ImageFormat.jpeg,
    int maxWidth = 0,
    int maxHeight = 0,
    int quality = 75,
  }) async {
    final bytes = await generateThumbnailData(
      videoPath: videoPath,
      time: time,
      format: format,
      maxWidth: maxWidth,
      maxHeight: maxHeight,
      quality: quality,
    );
    return bytes != null ? base64Encode(bytes) : null;
  }

  Future<String?> getPlatformVersion() {
    return VideoThumbnailerPlatform.instance.getPlatformVersion();
  }
}
