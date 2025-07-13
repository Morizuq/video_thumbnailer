import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:video_thumbnailer/video_thumbnailer.dart';
import 'package:video_thumbnailer/video_thumbnailer_platform_interface.dart';
import 'package:video_thumbnailer/video_thumbnailer_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockVideoThumbnailerPlatform
    with MockPlatformInterfaceMixin
    implements VideoThumbnailerPlatform {
  @override
  Future<String?> getPlatformVersion() => Future.value('42');

  @override
  Future<String?> generateThumbnail({
    required String videoPath,
    String? thumbnailPath,
    int time = 0,
    int format = 0,
    int maxWidth = 0,
    int maxHeight = 0,
    int quality = 75,
  }) async 
    => thumbnailPath ?? '/mock/path/${videoPath.split('/').last}_thumb.jpg';
  

  @override
  Future<Uint8List?> generateThumbnailData({
    required String videoPath,
    int time = 0,
    int format = 0,
    int maxWidth = 0,
    int maxHeight = 0,
    int quality = 75,
  }) async => Uint8List.fromList(
        List<int>.generate(100, (index) => index % 256),
      );
}

void main() {
  final VideoThumbnailerPlatform initialPlatform =
      VideoThumbnailerPlatform.instance;

  test('$MethodChannelVideoThumbnailer is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelVideoThumbnailer>());
  });

  test('getPlatformVersion', () async {
    VideoThumbnailer videoThumbnailerPlugin = VideoThumbnailer();
    MockVideoThumbnailerPlatform fakePlatform = MockVideoThumbnailerPlatform();
    VideoThumbnailerPlatform.instance = fakePlatform;

    expect(await videoThumbnailerPlugin.getPlatformVersion(), '42');
  });

  test('generateThumbnailFile', () async {
    // Arrange
    MockVideoThumbnailerPlatform fakePlatform = MockVideoThumbnailerPlatform();
    VideoThumbnailerPlatform.instance = fakePlatform;
    // Act
    final thumbnailPath = await VideoThumbnailer.generateThumbnail(
      videoPath: 'path/to/video.mp4',
      time: 1000,
      format: ImageFormat.jpeg,
      maxWidth: 320,
      maxHeight: 240,
      quality: 80,
    );
    // Assert
    expect(thumbnailPath, '/mock/path/video.mp4_thumb.jpg');
  });

  test('generateThumbnailData', () async {
    // Arrange
    MockVideoThumbnailerPlatform fakePlatform = MockVideoThumbnailerPlatform();
    VideoThumbnailerPlatform.instance = fakePlatform;
    // Act
    final thumbnailData = await VideoThumbnailer.generateThumbnailData(
      videoPath: 'path/to/video.mp4',
      time: 1000,
      format: ImageFormat.jpeg,
      maxWidth: 320,
      maxHeight: 240,
      quality: 80,
    );
    // Assert
    expect(thumbnailData, isA<Uint8List>());
    expect(thumbnailData!.length, 100);
  });
}
