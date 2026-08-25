import 'dart:io';
import 'package:image/image.dart' as img;
import 'package:clause_verify/core/utils/logging/logger.dart';

/// lib/core/utils/image_converter.dart এ এই ফাইলটা replace করুন
///
/// ⚠️ গুরুত্বপূর্ণ আপডেট: আগের ভার্সনে normal-দেখতে JPEG (magic bytes ঠিক)
/// কে skip করে দেওয়া হচ্ছিল, ধরে নিয়ে যে conversion শুধু HEIC এর জন্যই দরকার।
/// কিন্তু আসল কারণ ছিল ভিন্ন — real device এর camera JPEG এ থাকা
/// EXIF/metadata/maker-notes backend কে crash করাচ্ছিল, ফরম্যাট যাই হোক না কেন।
/// তাই এখন **সব ছবিই** re-encode করা হয় (এটাই আসল fix), কিন্তু
/// speed এর জন্য প্রথমে resize করে ছোট করে নেওয়া হয় — এতে decode+encode
/// অনেক দ্রুত হয়, এবং upload ও দ্রুত হয় (ছোট ফাইল সাইজ)।
class ImageConverter {
  /// Document scan এর জন্য এই resolution যথেষ্টের চেয়ে বেশি,
  /// টেক্সট পড়া/analyze করায় কোনো সমস্যা হবে না।
  static const int _maxDimension = 1600;

  static Future<File> convertToJpegIfNeeded(File file) async {
    try {
      final lowerPath = file.path.toLowerCase();

      // PDF, DOC, DOCX ইত্যাদি নন-ইমেজ ফাইল কখনোই ছোঁয়া হবে না
      if (lowerPath.endsWith('.pdf') ||
          lowerPath.endsWith('.doc') ||
          lowerPath.endsWith('.docx')) {
        return file;
      }

      final bytes = await file.readAsBytes();
      final decoded = img.decodeImage(bytes);

      if (decoded == null) {
        AppLoggerHelper.warning(
          '⚠️ Image decode failed, uploading original file as-is: ${file.path}',
        );
        return file;
      }

      // 👇 প্রথমে resize করা হচ্ছে (যদি ছবিটা বড় হয়) — এতে পরের
      // encode ধাপ অনেক দ্রুত হবে এবং ফাইল সাইজও অনেক কমে যাবে
      img.Image resized = decoded;
      if (decoded.width > _maxDimension || decoded.height > _maxDimension) {
        resized = img.copyResize(
          decoded,
          width: decoded.width >= decoded.height ? _maxDimension : null,
          height: decoded.height > decoded.width ? _maxDimension : null,
        );
      }

      // এখন resize হওয়া (ছোট) ছবিটাকে clean JPEG হিসেবে re-encode করা হচ্ছে —
      // এটাই আসল fix, কারণ এতে original ফাইলের problematic metadata/segment
      // মুছে গিয়ে backend এর জন্য একদম standard, predictable JPEG তৈরি হয়
      final jpegBytes = img.encodeJpg(resized, quality: 85);

      final newPath =
          '${file.parent.path}/${DateTime.now().millisecondsSinceEpoch}_converted.jpg';
      final newFile = File(newPath);
      await newFile.writeAsBytes(jpegBytes);

      AppLoggerHelper.info(
        '🔄 Converted & resized image: ${file.path} (${decoded.width}x${decoded.height}) -> $newPath (${resized.width}x${resized.height})',
      );

      return newFile;
    } catch (e) {
      AppLoggerHelper.error(
        '❌ Image conversion error: $e — uploading original file as fallback',
      );
      return file;
    }
  }
}