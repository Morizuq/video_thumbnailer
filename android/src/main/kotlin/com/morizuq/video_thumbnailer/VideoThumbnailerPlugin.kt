package com.morizuq.video_thumbnailer

import android.graphics.Bitmap
import android.media.MediaMetadataRetriever
import android.os.Environment
import java.io.ByteArrayOutputStream
import java.io.File
import java.io.FileOutputStream

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

/** VideoThumbnailerPlugin */
class VideoThumbnailerPlugin: FlutterPlugin, MethodCallHandler {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private lateinit var channel : MethodChannel

  override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "plugins.morizuq.zed/video_thumbnailer")
    channel.setMethodCallHandler(this)
  }

  override fun onMethodCall(call: MethodCall, result: Result) {
    when(call.method){
      "getPlatformVersion" -> {
        result.success("Android ${android.os.Build.VERSION.RELEASE}")
      }

      "generateThumbnailFile" -> {
        val videoPath = call.argument<String>("videoPath")
        val timeMs = call.argument<Int>("timeMs") ?: 0 // In milliseconds
        val formatStr = call.argument<String>("format") ?: "jpeg"
        val maxWidth = call.argument<Int>("maxWidth") ?: 0
        val maxHeight = call.argument<Int>("maxHeight") ?: 0
        val quality = call.argument<Int>("quality") ?: 75
        var thumbnailPath = call.argument<String>("thumbnailPath")

        try {
            val rawBitmap = generateThumbnail(videoPath!!, timeMs)
            val bitmap = resizeBitmap(rawBitmap, maxWidth, maxHeight)
            val format = getCompressFormat(formatStr)

            if (thumbnailPath == null) {
                val ext = when (format) {
                Bitmap.CompressFormat.PNG -> "png"
                Bitmap.CompressFormat.WEBP -> "webp"
                else -> "jpg"
            }
            thumbnailPath = videoPath.replace(".mp4", "_thumbnail.$ext")
            }
            val file = File(thumbnailPath)
            FileOutputStream(file).use { fos ->
                bitmap.compress(format, quality, fos)
            }
            result.success(file.absolutePath)
        } catch (e: Exception) {
            result.error("ERROR", "Failed to generate thumbnail", e.message)
        }
      }

      "generateThumbnailData" -> {
        val videoPath = call.argument<String>("videoPath")
        val timeMs = call.argument<Int>("timeMs") ?: 0
        val formatStr = call.argument<String>("format") ?: "jpeg"
        val maxWidth = call.argument<Int>("maxWidth") ?: 0
        val maxHeight = call.argument<Int>("maxHeight") ?: 0
        val quality = call.argument<Int>("quality") ?: 75

        try {
        val bitmap = resizeBitmap(
            generateThumbnail(videoPath!!, timeMs),
            maxWidth,
            maxHeight
        )

        val format = getCompressFormat(formatStr)

        val outputStream = ByteArrayOutputStream()
        bitmap.compress(format, quality, outputStream)
        val byteArray = outputStream.toByteArray()

        result.success(byteArray)  // Sent to Dart as Uint8List
        } catch (e: Exception) {
            result.error("ERROR", "Failed to generate thumbnail data", e.message)
      }
    }

      else -> result.notImplemented()
    }
    
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }

  private fun generateThumbnail(videoPath: String, timeMs: Int): Bitmap {
        return MediaMetadataRetriever().use { retriever ->
            retriever.setDataSource(videoPath)
            retriever.getFrameAtTime(timeMs * 1000L)!!
        }
  }

  private fun bitmapToByteArray(bitmap: Bitmap): ByteArray {
        return ByteArrayOutputStream().use { outputStream ->
            bitmap.compress(Bitmap.CompressFormat.JPEG, 75, outputStream)
            outputStream.toByteArray()
        }
    }

  private fun getCompressFormat(format: String): Bitmap.CompressFormat {
    return when (format.lowercase()) {
        "png" -> Bitmap.CompressFormat.PNG
        "webp" -> Bitmap.CompressFormat.WEBP
        else -> Bitmap.CompressFormat.JPEG
    }
  }

  private fun resizeBitmap(bitmap: Bitmap, maxWidth: Int, maxHeight: Int): Bitmap {
        if (maxWidth <= 0 && maxHeight <= 0) return bitmap

        val width = bitmap.width
        val height = bitmap.height
        val aspectRatio = width.toFloat() / height

        var newWidth = width
        var newHeight = height

      
        if (maxWidth > 0 && width > maxWidth) {
            newWidth = maxWidth
            newHeight = (newWidth / aspectRatio).toInt()
        }

        if (maxHeight > 0 && newHeight > maxHeight) {
            newHeight = maxHeight
            newWidth = (newHeight * aspectRatio).toInt()
        }

        return Bitmap.createScaledBitmap(bitmap, newWidth, newHeight, true)
    }

}
