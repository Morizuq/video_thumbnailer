import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:video_thumbnailer/video_thumbnailer.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  final _videoThumbnailerPlugin = VideoThumbnailer();

  String? _thumbnailPath;
  Uint8List? _thumbnailBytes;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      platformVersion =
          await _videoThumbnailerPlugin.getPlatformVersion() ??
          'Unknown platform version';
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  Future<void> pickVideoAndGenerateThumbnail() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.video);

    if (result != null && result.files.single.path != null) {
      final videoPath = result.files.single.path!;

      final path = await VideoThumbnailer.generateThumbnail(
        videoPath: videoPath,
        time: 1000, // 1 second into the video
        quality: 75,
        format: ImageFormat.jpeg, // JPEG
      );

      final bytes = await VideoThumbnailer.generateThumbnailData(
        videoPath: videoPath,
        time: 1000,
      );

      setState(() {
        _thumbnailPath = path;
        _thumbnailBytes = bytes;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Video thumbnailer example')),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Text('Platform Version: $_platformVersion'),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: pickVideoAndGenerateThumbnail,
                child: const Text('Pick Video & Generate Thumbnail'),
              ),
              const SizedBox(height: 20),
              if (_thumbnailBytes != null)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Thumbnail from Memory:'),
                    Image.memory(_thumbnailBytes!),
                  ],
                ),
              const SizedBox(height: 20),
              if (_thumbnailPath != null)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Thumbnail from File:'),
                    Image.file(File(_thumbnailPath!)),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
