import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_health/hk_healthdata.dart';

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

  static Future<bool> requestAuthorization(BuildContext context) async {
    final bool isAuthorized = await _channel.invokeMethod('requestAuthorization');
    return isAuthorized;
  }

  static Future<List<Map<String, String>>> getBodyFat(BuildContext context) async {
    Map<String, dynamic> args = {};
    args.putIfAbsent('index', () => 0);
    final List<Map<String, String>> version = await _channel.invokeMethod('getData');
    return version;
  }

  static Future<List<Map<String, String>>> getHeight(BuildContext context) async {
    Map<String, dynamic> args = {};
    args.putIfAbsent('index', () => 1);
    final List<Map<String, String>> version = await _channel.invokeMethod('getData');
    return version;
  }

  static Future<List<Map<String, String>>> getBodyMass(BuildContext context) async {
    Map<String, dynamic> args = {};
    args.putIfAbsent('index', () => 2);
    final List<Map<String, String>> version = await _channel.invokeMethod('getData');
    return version;
  }

  static Future<List<Map<String, String>>> getWaistCircumference(BuildContext context) async {
    Map<String, dynamic> args = {};
    args.putIfAbsent('index', () => 3);
    final List<Map<String, String>> version = await _channel.invokeMethod('getData');
    return version;
  }

  static Future<List<Map<String, String>>> getStepCount(BuildContext context) async {
    Map<String, dynamic> args = {};
    args.putIfAbsent('index', () => 4);
    final List<Map<String, String>> version = await _channel.invokeMethod('getData');
    return version;
  }

  static Future<List<Map<String, String>>> getBasalEnergyBurned(BuildContext context) async {
    Map<String, dynamic> args = {};
    args.putIfAbsent('index', () => 5);
    final List<Map<String, String>> version = await _channel.invokeMethod('getData');
    return version;
  }

  static Future<List<Map<String, String>>> getActiveEnergyBurned(BuildContext context) async {
    Map<String, dynamic> args = {};
    args.putIfAbsent('index', () => 6);
    final List<Map<String, String>> version = await _channel.invokeMethod('getData');
    return version;
  }

  static Future<List<HKHealthData>> getHeartRate(BuildContext context, DateTime startDate, DateTime endDate) async {
    Map<String, dynamic> args = {};
    args.putIfAbsent('index', () => 7);
    args.putIfAbsent('startDate', () => startDate.millisecondsSinceEpoch);
    args.putIfAbsent('endDate', () => endDate.millisecondsSinceEpoch);
    List result = await _channel.invokeMethod('getData', args);
    var hkHealthData = List<HKHealthData>.from(result.map((i) => HKHealthData.fromJson(Map<String, dynamic>.from(i))));
    return hkHealthData;
  }

  static Future<List<Map<String, String>>> getRestingHeartRate(BuildContext context) async {
    Map<String, dynamic> args = {};
    args.putIfAbsent('index', () => 8);
    final List<Map<String, String>> version = await _channel.invokeMethod('getData');
    return version;
  }

  static Future<List<Map<String, String>>> getWalkingHeartRate(BuildContext context) async {
    Map<String, dynamic> args = {};
    args.putIfAbsent('index', () => 9);
    final List<Map<String, String>> version = await _channel.invokeMethod('getData');
    return version;
  }

  static Future<List<Map<String, String>>> getBodyTemperature(BuildContext context) async {
    Map<String, dynamic> args = {};
    args.putIfAbsent('index', () => 10);
    final List<Map<String, String>> version = await _channel.invokeMethod('getData');
    return version;
  }

  static Future<List<List<Map<String, String>>>> getBloodPressure(BuildContext context) async {
    Map<String, dynamic> args = {};
    args.putIfAbsent('index', () => 11);
    List values = List<List<Map<String, String>>>();
    final double value = await _channel.invokeMethod('getData');

    values.add(value);

    args = {};
    args.putIfAbsent('index', () => 12);
    final double value2 = await _channel.invokeMethod('getData');

    values.add(value2);

    return values;
  }

  static Future<List<Map<String, String>>> getBloodOxygen(BuildContext context) async {
    Map<String, dynamic> args = {};
    args.putIfAbsent('index', () => 13);
    final List<Map<String, String>> version = await _channel.invokeMethod('getData');
    return version;
  }

  static Future<List<Map<String, String>>> getBloodGlucose(BuildContext context) async {
    Map<String, dynamic> args = {};
    args.putIfAbsent('index', () => 14);
    final List<Map<String, String>> version = await _channel.invokeMethod('getData');
    return version;
  }

  static Future<List<Map<String, String>>> getElectrodermalActivity(BuildContext context) async {
    Map<String, dynamic> args = {};
    args.putIfAbsent('index', () => 15);
    final List<Map<String, String>> version = await _channel.invokeMethod('getData');
    return version;
  }
}

class HKHealthData {
  int value;
  int dateFrom;
  int dateTo;

  HKHealthData({this.value, this.dateFrom, this.dateTo});

  HKHealthData.fromJson(Map<String, dynamic> json) {
    value = json['value'];
    dateFrom = json['date_from'];
    dateTo = json['date_to'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['value'] = this.value;
    data['date_from'] = this.dateFrom;
    data['date_to'] = this.dateTo;
    return data;
  }
}
