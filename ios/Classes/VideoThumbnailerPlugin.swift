import Flutter
import UIKit
import AVFoundation

public class VideoThumbnailerPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "plugins.morizuq.zed/video_thumbnailer", binaryMessenger: registrar.messenger())
    let instance = VideoThumbnailerPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {

    guard let args = call.arguments as? [String: Any] else {
    result(FlutterError(code: "INVALID_ARGUMENTS", message: "Expected map arguments", details: nil))
    return
    }

    switch call.method {
    case "getPlatformVersion":
      result("iOS " + UIDevice.current.systemVersion)
    
     case "generateThumbnailFile":
      generateThumbnailFile(args: args, result: result)

    case "generateThumbnailData":
      generateThumbnailData(args: args, result: result)

    default:
      result(FlutterMethodNotImplemented)
    }
  }

  private func generateThumbnailFile(args: [String: Any], result: @escaping FlutterResult) {
    guard let videoPath = args["videoPath"] as? String,
          let timeMs = args["timeMs"] as? Int else {
      result(FlutterError(code: "INVALID_ARGUMENTS", message: "Missing videoPath/time", details: nil))
      return
    }

    let format = (args["format"] as? String ?? "jpeg").lowercased()
    let quality = CGFloat(args["quality"] as? Int ?? 75) / 100.0
    let maxWidth = args["maxWidth"] as? CGFloat ?? 0
    let maxHeight = args["maxHeight"] as? CGFloat ?? 0
    let thumbnailPath = args["thumbnailPath"] as? String

    guard let image = generateThumbnail(videoPath: videoPath, timeMs: timeMs, maxWidth: maxWidth, maxHeight: maxHeight) else {
      result(FlutterError(code: "GENERATION_FAILED", message: "Unable to generate thumbnail", details: nil))
      return
    }

    guard let data = imageData(from: image, format: format, quality: quality) else {
      result(FlutterError(code: "FORMAT_ERROR", message: "Unsupported format or conversion failed", details: nil))
      return
    }

    let outputPath = thumbnailPath ?? videoPath.replacingOccurrences(of: ".mp4", with: "_thumbnail.\(format)")
    do {
      try data.write(to: URL(fileURLWithPath: outputPath))
      result(outputPath)
    } catch {
      result(FlutterError(code: "WRITE_ERROR", message: "Failed to save thumbnail", details: error.localizedDescription))
    }
  }

  private func generateThumbnailData(args: [String: Any], result: @escaping FlutterResult) {
    guard let videoPath = args["videoPath"] as? String,
          let timeMs = args["timeMs"] as? Int else {
      result(FlutterError(code: "INVALID_ARGUMENTS", message: "Missing videoPath/time", details: nil))
      return
    }

    let format = (args["format"] as? String ?? "jpeg").lowercased()
    let quality = CGFloat(args["quality"] as? Int ?? 75) / 100.0
    let maxWidth = args["maxWidth"] as? CGFloat ?? 0
    let maxHeight = args["maxHeight"] as? CGFloat ?? 0

    guard let image = generateThumbnail(videoPath: videoPath, timeMs: timeMs, maxWidth: maxWidth, maxHeight: maxHeight) else {
      result(FlutterError(code: "GENERATION_FAILED", message: "Unable to generate thumbnail", details: nil))
      return
    }

    guard let data = imageData(from: image, format: format, quality: quality) else {
      result(FlutterError(code: "FORMAT_ERROR", message: "Unsupported format or conversion failed", details: nil))
      return
    }

    result(FlutterStandardTypedData(bytes: data))
  }

  private func generateThumbnail(videoPath: String, timeMs: Int, maxWidth: CGFloat, maxHeight: CGFloat) -> UIImage? {
    let asset = AVAsset(url: URL(fileURLWithPath: videoPath))
    let generator = AVAssetImageGenerator(asset: asset)
    generator.appliesPreferredTrackTransform = true

    do {
      let cgImage = try generator.copyCGImage(at: CMTimeMake(value: Int64(timeMs), timescale: 1000), actualTime: nil)
      let image = UIImage(cgImage: cgImage)
      return resizeImage(image, maxWidth: maxWidth, maxHeight: maxHeight)
    } catch {
      print("Thumbnail error: \(error.localizedDescription)")
      return nil
    }
  }

  private func resizeImage(_ image: UIImage, maxWidth: CGFloat, maxHeight: CGFloat) -> UIImage {
    guard maxWidth > 0 || maxHeight > 0 else { return image }

    var newSize = image.size
    let aspectRatio = image.size.width / image.size.height

    if maxWidth > 0 && newSize.width > maxWidth {
      newSize.width = maxWidth
      newSize.height = maxWidth / aspectRatio
    }

    if maxHeight > 0 && newSize.height > maxHeight {
      newSize.height = maxHeight
      newSize.width = maxHeight * aspectRatio
    }

    let renderer = UIGraphicsImageRenderer(size: newSize)
    return renderer.image { _ in image.draw(in: CGRect(origin: .zero, size: newSize)) }
  }

    private func imageData(from image: UIImage, format: String, quality: CGFloat) -> Data? {
    switch format {
    case "jpeg", "jpg":
      return image.jpegData(compressionQuality: quality)
    case "png":
      return image.pngData()
    default:
      return nil // iOS doesn't natively support WebP or HEIC easily without custom work
    }
  }
}
