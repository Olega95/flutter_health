import 'dart:async';

import 'package:flutter/services.dart';

class FlutterHealth {
  static const MethodChannel _channel = const MethodChannel('flutter_health');

  static Future<String> checkIfHealthDataAvailable() async {
    final String version = await _channel.invokeMethod('checkIfHealthDataAvailable');
    return version;
  }

  static Future<bool> requestAuthorization() async {
    final bool isAuthorized = await _channel.invokeMethod('requestAuthorization');
    return isAuthorized;
  }

  static Future<List<HKHealthData>> getBodyFat(DateTime startDate, DateTime endDate) async {
    return getHKHealthData(startDate, endDate, 0);
  }

  static Future<List<HKHealthData>> getHeight(DateTime startDate, DateTime endDate) async {
    return getHKHealthData(startDate, endDate, 1);
  }

  static Future<List<HKHealthData>> getBodyMass(DateTime startDate, DateTime endDate) async {
    return getHKHealthData(startDate, endDate, 2);
  }

  static Future<List<HKHealthData>> getWaistCircumference(DateTime startDate, DateTime endDate) async {
    return getHKHealthData(startDate, endDate, 3);
  }

  static Future<List<HKHealthData>> getStepCount(DateTime startDate, DateTime endDate) async {
    return getHKHealthData(startDate, endDate, 4);
  }

  static Future<List<HKHealthData>> getBasalEnergyBurned(DateTime startDate, DateTime endDate) async {
    return getHKHealthData(startDate, endDate, 5);
  }

  static Future<List<HKHealthData>> getActiveEnergyBurned(DateTime startDate, DateTime endDate) async {
    return getHKHealthData(startDate, endDate, 6);
  }

  static Future<List<HKHealthData>> getHeartRate(DateTime startDate, DateTime endDate) async {
    return getHKHealthData(startDate, endDate, 7);
  }

  static Future<List<HKHealthData>> getRestingHeartRate(DateTime startDate, DateTime endDate) async {
    return getHKHealthData(startDate, endDate, 8);
  }

  static Future<List<HKHealthData>> getWalkingHeartRate(DateTime startDate, DateTime endDate) async {
    return getHKHealthData(startDate, endDate, 9);
  }

  static Future<List<HKHealthData>> getBodyTemperature(DateTime startDate, DateTime endDate) async {
    return getHKHealthData(startDate, endDate, 10);
  }

  static Future<List<List<HKHealthData>>> getBloodPressure(DateTime startDate, DateTime endDate) async {
    var sys = await getHKHealthData(startDate, endDate, 11);
    var dia = await getHKHealthData(startDate, endDate, 12);
    return [sys, dia];
  }

  static Future<List<HKHealthData>> getBloodPressureSys(DateTime startDate, DateTime endDate) async {
    return getHKHealthData(startDate, endDate, 11);
  }

  static Future<List<HKHealthData>> getBloodPressureDia(DateTime startDate, DateTime endDate) async {
    return getHKHealthData(startDate, endDate, 12);
  }

  static Future<List<HKHealthData>> getBloodOxygen(DateTime startDate, DateTime endDate) async {
    return getHKHealthData(startDate, endDate, 13);
  }

  static Future<List<HKHealthData>> getBloodGlucose(DateTime startDate, DateTime endDate) async {
    return getHKHealthData(startDate, endDate, 14);
  }

  static Future<List<HKHealthData>> getElectrodermalActivity(DateTime startDate, DateTime endDate) async {
    return getHKHealthData(startDate, endDate, 15);
  }

  static Future<List<HKHealthData>> getHKHighHeart(DateTime startDate, DateTime endDate) async {
    return getHKHeartData(startDate, endDate, 0);
  }

  static Future<List<HKHealthData>> getHKLowHeart(DateTime startDate, DateTime endDate) async {
    return getHKHeartData(startDate, endDate, 1);
  }

  static Future<List<HKHealthData>> getHKIrregular(DateTime startDate, DateTime endDate) async {
    return getHKHeartData(startDate, endDate, 2);
  }

  static Future<List<HKHealthData>> getHKHealthData(DateTime startDate, DateTime endDate, int type) async {
    Map<String, dynamic> args = {};
    args.putIfAbsent('index', () => type);
    args.putIfAbsent('startDate', () => startDate.millisecondsSinceEpoch);
    args.putIfAbsent('endDate', () => endDate.millisecondsSinceEpoch);
    try {
      List result = await _channel.invokeMethod('getData', args);
      var hkHealthData = List<HKHealthData>.from(result.map((i) => HKHealthData.fromJson(Map<String, dynamic>.from(i))));
      return hkHealthData;
    } catch (e, s) {
      return const [];
    }
  }

  static Future<List<HKHealthData>> getHKHeartData(DateTime startDate, DateTime endDate, int type) async {
    Map<String, dynamic> args = {};
    args.putIfAbsent('index', () => type);
    args.putIfAbsent('startDate', () => startDate.millisecondsSinceEpoch);
    args.putIfAbsent('endDate', () => endDate.millisecondsSinceEpoch);
    try {
      List result = await _channel.invokeMethod('getHeartAlerts', args);
      var hkHealthData = List<HKHealthData>.from(result.map((i) => HKHealthData.fromJson(Map<String, dynamic>.from(i))));
      return hkHealthData;
    } catch (e, s) {
      return const [];
    }
  }
}

class HKHealthData {
  double value;
  String unit;
  int dateFrom;
  int dateTo;

  HKHealthData({this.value, this.unit, this.dateFrom, this.dateTo});

  HKHealthData.fromJson(Map<String, dynamic> json) {
    value = json['value'];
    unit = json['unit'];
    dateFrom = json['date_from'];
    dateTo = json['date_to'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['value'] = this.value;
    data['unit'] = this.unit;
    data['date_from'] = this.dateFrom;
    data['date_to'] = this.dateTo;
    return data;
  }
}
