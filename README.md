# 📼 video_thumbnailer

A Flutter plugin to generate video thumbnails (as images or raw bytes) from local video files on Android and iOS using platform channels.

> 🔧 This plugin is inspired by [`video_thumbnail`](https://github.com/justsoft/video_thumbnail) but written from scratch for learning purposes, with cleaner native code and customizable logic.  
> Currently supports **local file paths** only. URL support will be added in a future release.

---

## ✨ Features

- ✅ Generate thumbnail **images from local video files**
- ✅ Choose thumbnail time (in milliseconds)
- ✅ Customize output format (JPEG, PNG, WebP, HEIC)
- ✅ Adjust quality, max width, and max height
- ✅ Generate:
  - 📁 A **thumbnail file** (saved to disk)
  - 🧠 **Thumbnail bytes** (`Uint8List` for in-memory use)

---

## 🚀 Getting Started

Add the dependency:

```yaml
dependencies:
  video_thumbnailer:
    git:
      url: https://github.com/Morizuq/video_thumbnailer.git
```

---

## 🧑‍💻 Usage

```dart
import 'package:video_thumbnailer/video_thumbnailer.dart';

void generate() async {
  final thumbnailPath = await VideoThumbnailer.generateThumbnail(
    videoPath: '/path/to/video.mp4',
    time: 1000, // in milliseconds
    format: 'jpeg', // JPEG
    quality: 75,
    maxWidth: 320,
    maxHeight: 240,
  );

  final thumbnailData = await VideoThumbnailer.generateThumbnailData(
    videoPath: '/path/to/video.mp4',
    time: 500,
    format: 'jpeg',
  );
}
```

---

## 🧾 Parameters

| Parameter       | Type         | Description                                      | Default    |
|----------------|--------------|--------------------------------------------------|------------|
| `videoPath`     | `String`     | Local path to the video file                     | _required_ |
| `thumbnailPath` | `String?`    | Output path for thumbnail file (optional)        | auto-generated |
| `time`          | `int`        | Timestamp to capture thumbnail (in ms)           | `0`        |
| `format`        | `int`        | Image format index: `0=JPEG`, `1=PNG`, etc.      | `0`        |
| `maxWidth`      | `int`        | Resize width                                     | `0` (original) |
| `maxHeight`     | `int`        | Resize height                                    | `0` (original) |
| `quality`       | `int`        | Compression quality (0–100)                      | `75`       |

---

## 📱 Platform Support

| Platform | Status       |
|----------|--------------|
| Android  | ✅ Supported |
| iOS      | ✅ Supported |
| Web      | ❌ Not supported |
| macOS/Linux/Windows | ❌ Not supported |

---

## 🧪 Testing

Includes:
- Dart unit tests using `flutter_test` with mocked method channels
<!-- - Android native unit test (Kotlin) -->
- iOS support added but tests TBD

To run tests:

```bash
flutter test
```

<!-- For Android native tests:

```bash
cd morizuq/android
./gradlew testDebugUnitTest
``` -->

---

## 🔮 Roadmap

- [x] File-based thumbnail generation
- [x] In-memory `Uint8List` support
- [ ] Remote video URL support
- [ ] Resize thumbnail dimensions
- [ ] Frame-by-frame extraction
- [ ] Null-safety & DartDoc complete typing

---

## 🏗 Architecture

- Uses **Flutter Method Channels**
- Native Android: `MediaMetadataRetriever`
- Native iOS: `AVAssetImageGenerator`
- Dart-side plugin wraps method channels and provides an easy-to-use API

---

## 📚 References

- Flutter Method Channel documentation: https://docs.flutter.dev/platform-integration/platform-channels
- Android MediaMetadataRetriever: https://developer.android.com/reference/android/media/MediaMetadataRetriever
- iOS AVFoundation: https://developer.apple.com/documentation/avfoundation/avassetimagegenerator
- Original inspiration: [`video_thumbnail`](https://github.com/justsoft/video_thumbnail)

---

## 📦 Publishing

This plugin is currently in development and meant for educational use.  
Feel free to fork, improve, or contribute via PRs!

---

## 👨‍💻 Author

**Morizuq Shoneye**  
Mobile Developer | Flutter & Kotlin  
[GitHub](https://github.com/Morizuq) | [Twitter](https://twitter.com/mrizuq)

---

## 📄 License

MIT License — See [LICENSE](LICENSE)
