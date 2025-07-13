import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:video_thumbnailer/video_thumbnailer_method_channel.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  MethodChannelVideoThumbnailer platform = MethodChannelVideoThumbnailer();
  const MethodChannel channel = MethodChannel(
    'plugins.morizuq.zed/video_thumbnailer',
  );

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
          // print(
          //   'Method called: ${methodCall.method}, args: ${methodCall.arguments}',
          // );

          final args = methodCall.arguments as Map<Object?, Object?>?;

          switch (methodCall.method) {
            case 'generateThumbnailFile':
              if (args == null || !args.containsKey('videoPath')) {
                throw ArgumentError('Missing videoPath');
              }
              final videoPath = args['videoPath'] as String;
              return videoPath.replaceAll('.mp4', '.mp4_thumb.jpg');

            case 'generateThumbnailData':
              return Uint8List.fromList(List.generate(10, (i) => i));

            case 'getPlatformVersion':
              return '42';

            default:
              return null;
          }
        });
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  test('getPlatformVersion', () async {
    expect(await platform.getPlatformVersion(), '42');
  });

  test('generateThumbnail', () async {
    final String videoPath = 'path/to/video.mp4';
    final String? thumbnailPath = await platform.generateThumbnail(
      videoPath: videoPath,
      time: 1000,
      format: 0, // Assuming 0 corresponds to JPEG
      maxWidth: 320,
      maxHeight: 240,
      quality: 80,
    );
    expect(thumbnailPath, isNotNull);
    expect(thumbnailPath, contains('video.mp4_thumb.jpg'));
  });

  test('generateThumbnailData', () async {
    final String videoPath = 'path/to/video.mp4';
    final Uint8List? thumbnailData = await platform.generateThumbnailData(
      videoPath: videoPath,
      time: 1000,
      format: 0, // Assuming 0 corresponds to JPEG
      maxWidth: 320,
      maxHeight: 240,
      quality: 80,
    );
    expect(thumbnailData, isNotNull);
    expect(thumbnailData!.length, greaterThan(0));
  });
}
