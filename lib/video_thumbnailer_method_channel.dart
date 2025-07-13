import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'video_thumbnailer_platform_interface.dart';

/// An implementation of [VideoThumbnailerPlatform] that uses method channels.
class MethodChannelVideoThumbnailer extends VideoThumbnailerPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel(
    'plugins.morizuq.zed/video_thumbnailer',
  );

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>(
      'getPlatformVersion',
    );
    return version;
  }

  @override
  Future<String?> generateThumbnail({
    required String videoPath,
    String? thumbnailPath,
    int time = 0,
    int format = 0,
    int maxWidth = 0,
    int maxHeight = 0,
    int quality = 75,
  }) async {
    final result = await methodChannel
        .invokeMethod<String>('generateThumbnailFile', {
          'videoPath': videoPath,
          'thumbnailPath': thumbnailPath,
          'timeMs': time,
          'format': format,
          'maxWidth': maxWidth,
          'maxHeight': maxHeight,
          'quality': quality,
        });
    return result;
  }

  @override
  Future<Uint8List?> generateThumbnailData({
    required String videoPath,
    int time = 0,
    int format = 0,
    int maxWidth = 0,
    int maxHeight = 0,
    int quality = 75,
  }) async {
    final result = await methodChannel
        .invokeMethod<Uint8List>('generateThumbnailData', {
          'videoPath': videoPath,
          'timeMs': time,
          'format': format,
          'maxWidth': maxWidth,
          'maxHeight': maxHeight,
          'quality': quality,
        });
    return result;
  }
}
