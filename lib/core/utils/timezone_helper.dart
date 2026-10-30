import 'package:flutter/foundation.dart';
import 'package:flutter_timezone/flutter_timezone.dart';

Future<String> getUserTimezone() async {
  try {
    final timezone = await FlutterTimezone.getLocalTimezone();
    debugPrint('🌍 Timezone detected: ${timezone.identifier}');
    return timezone.identifier;
  } catch (e) {
    debugPrint('❌ Timezone error: $e');
    return 'UTC';
  }
}