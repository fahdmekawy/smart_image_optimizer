import 'dart:io';
import 'package:cross_file/cross_file.dart';
import 'platform/optimizer_mobile.dart'
    if (dart.library.html) 'platform/optimizer_web.dart'
    if (dart.library.io) 'platform/optimizer_desktop.dart';

enum ImageFormat { auto, jpg, png, webp, avif }

class SmartImageOptimizer {
  /// Optimize a single image
  static Future<XFile> optimize({
    required XFile file,
    int? maxWidth,
    int? maxHeight,
    int quality = 80,
    int? targetBytes,
    ImageFormat outputFormat = ImageFormat.auto,
    bool preserveExif = false,
  }) {
    return platformOptimize(
      file: file,
      maxWidth: maxWidth,
      maxHeight: maxHeight,
      quality: quality,
      targetBytes: targetBytes,
      outputFormat: outputFormat,
      preserveExif: preserveExif,
    );
  }

  /// Optimize multiple images
  static Future<List<XFile>> optimizeBatch({
    required List<XFile> files,
    int? maxWidth,
    int? maxHeight,
    int quality = 80,
    int? targetBytes,
    ImageFormat outputFormat = ImageFormat.auto,
    bool preserveExif = false,
    void Function(int index, int total)? onProgress,
  }) async {
    List<XFile> results = [];
    for (var i = 0; i < files.length; i++) {
      final optimized = await optimize(
        file: files[i],
        maxWidth: maxWidth,
        maxHeight: maxHeight,
        quality: quality,
        targetBytes: targetBytes,
        outputFormat: outputFormat,
        preserveExif: preserveExif,
      );
      results.add(optimized);
      if (onProgress != null) onProgress(i + 1, files.length);
    }
    return results;
  }
}
