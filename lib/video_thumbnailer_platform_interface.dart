import 'dart:typed_data';

import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'video_thumbnailer_method_channel.dart';

abstract class VideoThumbnailerPlatform extends PlatformInterface {
  /// Constructs a VideoThumbnailerPlatform.
  VideoThumbnailerPlatform() : super(token: _token);

  static final Object _token = Object();

  static VideoThumbnailerPlatform _instance = MethodChannelVideoThumbnailer();

  /// The default instance of [VideoThumbnailerPlatform] to use.
  ///
  /// Defaults to [MethodChannelVideoThumbnailer].
  static VideoThumbnailerPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [VideoThumbnailerPlatform] when
  /// they register themselves.
  static set instance(VideoThumbnailerPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<String?> generateThumbnail({
    required String videoPath,
    String? thumbnailPath,
    int time = 0,
    int format = 0,
    int maxWidth = 0,
    int maxHeight = 0,
    int quality = 75,
  }) {
    throw UnimplementedError('generateThumbnail() has not been implemented.');
  }

  Future<Uint8List?> generateThumbnailData({
    required String videoPath,
    int time = 0,
    int format = 0,
    int maxWidth = 0,
    int maxHeight = 0,
    int quality = 75,
  }) {
    throw UnimplementedError(
      'generateThumbnailData() has not been implemented.',
    );
  }
}
