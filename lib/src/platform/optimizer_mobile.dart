import 'package:cross_file/cross_file.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import '../optimizer.dart';

Future<XFile> platformOptimize({
  required XFile file,
  int? maxWidth,
  int? maxHeight,
  required int quality,
  int? targetBytes,
  required ImageFormat outputFormat,
  required bool preserveExif,
}) async {
  final result = await FlutterImageCompress.compressWithFile(
    file.path,
    minWidth: maxWidth ?? 1920,
    minHeight: maxHeight ?? 1080,
    quality: quality,
    format: _mapFormat(outputFormat),
    keepExif: preserveExif,
  );

  return XFile.fromData(
    result!,
    name: file.name,
    mimeType: 'image/${outputFormat.name}',
  );
}

CompressFormat _mapFormat(ImageFormat format) {
  switch (format) {
    case ImageFormat.png:
      return CompressFormat.png;
    case ImageFormat.webp:
      return CompressFormat.webp;
    case ImageFormat.avif:
      return CompressFormat.heic; // AVIF not supported directly yet
    case ImageFormat.auto:
    case ImageFormat.jpg:
    default:
      return CompressFormat.jpeg;
  }
}
