import 'dart:async';

import 'package:flutter/services.dart';

class ThriweLib {
  static const MethodChannel _channel = const MethodChannel('thriwe_lib');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future<bool> clearAllNotification() async {
    final bool success = await _channel.invokeMethod('clearAllNotification');
    return success;
  }
}
