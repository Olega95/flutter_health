import 'dart:async';

import 'package:flutter/services.dart';

class FlutterHealth {
  static const MethodChannel _channel = const MethodChannel('flutter_health');

  static Future<bool> checkIfHealthDataAvailable() async {
    final bool isHealthDataAvailable = await _channel.invokeMethod('checkIfHealthDataAvailable');
    return isHealthDataAvailable;
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
    return getHKHeartData(startDate, endDate, 16);
  }

  static Future<List<HKHealthData>> getHKLowHeart(DateTime startDate, DateTime endDate) async {
    return getHKHeartData(startDate, endDate, 17);
  }

  static Future<List<HKHealthData>> getHKIrregular(DateTime startDate, DateTime endDate) async {
    return getHKHeartData(startDate, endDate, 18);
  }

  static Future<List<HKHealthData>> getAllData(DateTime startDate, DateTime endDate) async {
    List<HKHealthData> allData = new List<HKHealthData>();
    var healthData = List.from(HKDataType.values);
    healthData.removeRange(
        HKDataType.values.indexOf(HKDataType.HIGH_HEART_RATE_EVENT), HKDataType.values.indexOf(HKDataType.IRREGULAR_HEART_RATE_EVENT));
    for (int i = 0; i < healthData.length; i++) {
      allData.addAll(await getHKHealthData(startDate, endDate, i));
    }
    for (int i = HKDataType.values.indexOf(HKDataType.HIGH_HEART_RATE_EVENT); i < HKDataType.values.length; i++) {
      allData.addAll(await getHKHeartData(startDate, endDate, i));
    }
    return allData;
  }

  static Future<List<HKHealthData>> getAllDataWithCombinedBP(DateTime startDate, DateTime endDate) async {
    List<HKHealthData> allData = new List<HKHealthData>();
    var healthData = List.from(HKDataType.values);
    healthData.removeRange(
        HKDataType.values.indexOf(HKDataType.HIGH_HEART_RATE_EVENT), HKDataType.values.indexOf(HKDataType.IRREGULAR_HEART_RATE_EVENT));
    List<HKHealthData> bpRecords = [];
    for (int i = 0; i < healthData.length; i++) {
      if (healthData[i] == HKDataType.BLOOD_PRESSURE_SYSTOLIC) {
        bpRecords = await getHKHealthData(startDate, endDate, i);
        print("BPREC LEN 1  ${bpRecords.length}        $i");
      }

      else if (healthData[i] == HKDataType.BLOOD_PRESSURE_DIASTOLIC) {
        var dia = await getHKHealthData(startDate, endDate, i);
        print("DIA LEN ${dia.length}");
        print("BPREC LEN ${bpRecords.length}");
        for (int j = 0; j < dia.length; j++) {
          try {
            bpRecords[j].value2 = dia[j].value;
          } catch (e) {}
        }
        allData.addAll(bpRecords);
      } else
        allData.addAll(await getHKHealthData(startDate, endDate, i));
    }
    for (int i = HKDataType.values.indexOf(HKDataType.HIGH_HEART_RATE_EVENT); i < HKDataType.values.length; i++) {
      allData.addAll(await getHKHeartData(startDate, endDate, i));
    }
    return allData;
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
    } catch (e) {
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
    } catch (e) {
      return const [];
    }
  }
}

class HKHealthData {
  double value;
  double value2;
  String unit;
  int dateFrom;
  int dateTo;
  HKDataType dataType;

  HKHealthData({this.value, this.unit, this.dateFrom, this.dateTo, this.dataType});

  HKHealthData.fromJson(Map<String, dynamic> json) {
    value = json['value'];
    unit = json['unit'];
    dateFrom = json['date_from'];
    dateTo = json['date_to'];
    dataType = HKDataType.values[json['data_type_index']];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['value'] = this.value;
    data['unit'] = this.unit;
    data['date_from'] = this.dateFrom;
    data['date_to'] = this.dateTo;
    data['data_type_index'] = HKDataType.values.indexOf(this.dataType);
    return data;
  }
}

enum HKDataType {
  BODY_FAT,
  HEIGHT,
  BODY_MASS_INDEX,
  WAIST_CIRCUMFERENCE,
  STEPS,
  BASAL_ENERGY_BURNED,
  ACTIVE_ENERGY_BURNED,
  HEART_RATE,
  BODY_TEMPERATURE,
  BLOOD_PRESSURE_SYSTOLIC,
  BLOOD_PRESSURE_DIASTOLIC,
  RESTING_HEART_RATE,
  WALKING_HEART_RATE,
  BLOOD_OXYGEN,
  BLOOD_GLUCOSE,
  ELECTRODERMAL_ACTIVITY,
  HIGH_HEART_RATE_EVENT,
  LOW_HEART_RATE_EVENT,
  IRREGULAR_HEART_RATE_EVENT
}
