import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

class FlutterHealth {
  static const MethodChannel _channel = const MethodChannel('flutter_health');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future<String> checkIfHealthDataAvailable(BuildContext context) async {
    final String version = await _channel.invokeMethod('checkIfHealthDataAvailable');
    return version;
  }

  static Future<String> requestAuthorization(BuildContext context) async {
    final String version = await _channel.invokeMethod('requestAuthorization');
    return version;
  }
}
