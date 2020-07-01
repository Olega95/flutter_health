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

  static Future<List<HKHealthData>> getHKBodyFat(DateTime startDate, DateTime endDate) async {
    return getHKHealthData(startDate, endDate, 0);
  }

  static Future<List<GFHealthData>> getGFBodyFat(DateTime startDate, DateTime endDate) async {
    return getGFHealthData(startDate, endDate, 0);
  }

  static Future<List<HKHealthData>> getHKHeight(DateTime startDate, DateTime endDate) async {
    return getHKHealthData(startDate, endDate, 1);
  }

  static Future<List<GFHealthData>> getGFHeight(DateTime startDate, DateTime endDate) async {
    return getGFHealthData(startDate, endDate, 1);
  }

  static Future<List<HKHealthData>> getHKBodyMass(DateTime startDate, DateTime endDate) async {
    return getHKHealthData(startDate, endDate, 2);
  }

  static Future<List<HKHealthData>> getHKWaistCircumference(DateTime startDate, DateTime endDate) async {
    return getHKHealthData(startDate, endDate, 3);
  }

  static Future<List<HKHealthData>> getHKStepCount(DateTime startDate, DateTime endDate) async {
    return getHKHealthData(startDate, endDate, 4);
  }

  static Future<List<HKHealthData>> getHKStepCountSummary(DateTime startDate, DateTime endDate) async {
    return getHKHealthSummary(startDate, endDate, 4);
  }

  static Future<List<GFHealthData>> getGFStepCount(DateTime startDate, DateTime endDate) async {
    return getGFHealthData(startDate, endDate, 2);
  }

  static Future<List<HKHealthData>> getHKBasalEnergyBurned(DateTime startDate, DateTime endDate) async {
    return getHKHealthData(startDate, endDate, 5);
  }

  static Future<List<HKHealthData>> getHKActiveEnergyBurned(DateTime startDate, DateTime endDate) async {
    return getHKHealthData(startDate, endDate, 6);
  }

  static Future<List<GFHealthData>> getGFEnergyBurned(DateTime startDate, DateTime endDate) async {
    return getGFHealthData(startDate, endDate, 3);
  }

  static Future<List<HKHealthData>> getHKHeartRate(DateTime startDate, DateTime endDate) async {
    return getHKHealthData(startDate, endDate, 7);
  }

  static Future<List<GFHealthData>> getGFHeartRate(DateTime startDate, DateTime endDate) async {
    return getGFHealthData(startDate, endDate, 4);
  }

  static Future<List<HKHealthData>> getHKRestingHeartRate(DateTime startDate, DateTime endDate) async {
    return getHKHealthData(startDate, endDate, 8);
  }

  static Future<List<HKHealthData>> getHKWalkingHeartRate(DateTime startDate, DateTime endDate) async {
    return getHKHealthData(startDate, endDate, 9);
  }

  static Future<List<HKHealthData>> getHKBodyTemperature(DateTime startDate, DateTime endDate) async {
    return getHKHealthData(startDate, endDate, 10);
  }

  static Future<List<GFHealthData>> getGFBodyTemperature(DateTime startDate, DateTime endDate) async {
    return getGFHealthData(startDate, endDate, 5);
  }

  static Future<List<List<HKHealthData>>> getHKBloodPressure(DateTime startDate, DateTime endDate) async {
    var sys = await getHKHealthData(startDate, endDate, 11);
    var dia = await getHKHealthData(startDate, endDate, 12);
    return [sys, dia];
  }

  static Future<List<GFHealthData>> getGFBloodPressure(DateTime startDate, DateTime endDate) async {
    return await getGFHealthData(startDate, endDate, 6);
  }

  static Future<List<HKHealthData>> getHKBloodPressureSys(DateTime startDate, DateTime endDate) async {
    return getHKHealthData(startDate, endDate, 11);
  }

  static Future<List<HKHealthData>> getHKBloodPressureDia(DateTime startDate, DateTime endDate) async {
    return getHKHealthData(startDate, endDate, 12);
  }

  static Future<List<HKHealthData>> getHKBloodOxygen(DateTime startDate, DateTime endDate) async {
    return getHKHealthData(startDate, endDate, 13);
  }

  static Future<List<GFHealthData>> getGFBloodOxygen(DateTime startDate, DateTime endDate) async {
    return getGFHealthData(startDate, endDate, 7);
  }

  static Future<List<HKHealthData>> getHKBloodGlucose(DateTime startDate, DateTime endDate) async {
    return getHKHealthData(startDate, endDate, 14);
  }

  static Future<List<GFHealthData>> getGFBloodGlucose(DateTime startDate, DateTime endDate) async {
    return getGFHealthData(startDate, endDate, 8);
  }

  static Future<List<HKHealthData>> getHKElectrodermalActivity(DateTime startDate, DateTime endDate) async {
    return getHKHealthData(startDate, endDate, 15);
  }

  static Future<List<HKHealthData>> getHKWeight(DateTime startDate, DateTime endDate) async {
    return getHKHealthData(startDate, endDate, 16);
  }

  static Future<List<GFHealthData>> getGFWeight(DateTime startDate, DateTime endDate) async {
    return getGFHealthData(startDate, endDate, 9);
  }

  static Future<List<HKHealthData>> getHKHighHeart(DateTime startDate, DateTime endDate) async {
    return getHKHeartData(startDate, endDate, 17);
  }

  static Future<List<HKHealthData>> getHKLowHeart(DateTime startDate, DateTime endDate) async {
    return getHKHeartData(startDate, endDate, 18);
  }

  static Future<List<HKHealthData>> getHKIrregular(DateTime startDate, DateTime endDate) async {
    return getHKHeartData(startDate, endDate, 19);
  }

  static Future<List<HKHealthData>> getHKAllData(DateTime startDate, DateTime endDate) async {
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

  static Future<List<GFHealthData>> getGFHealthData(DateTime startDate, DateTime endDate, int type) async {
    Map<String, dynamic> args = {};
    args.putIfAbsent('index', () => type);
    args.putIfAbsent('startDate', () => startDate.millisecondsSinceEpoch);
    args.putIfAbsent('endDate', () => endDate.millisecondsSinceEpoch);
    try {
      List result = await _channel.invokeMethod('getGFHealthData', args);
      var gfHealthData = List<GFHealthData>.from(result.map((i) => GFHealthData.fromJson(Map<String, dynamic>.from(i))));
      return gfHealthData;
    } catch (e, s) {
      return const [];
    }
  }

  static Future<List<GFHealthData>> getGFAllData(DateTime startDate, DateTime endDate) async {
    List<GFHealthData> allData = new List<GFHealthData>();
    var healthData = List.from(GFDataType.values);

    for (int i = 0; i < healthData.length; i++) {
      allData.addAll(await getGFHealthData(startDate, endDate, i));
    }
    return allData;
  }

  static Future<List<GFHealthData>> getGFAllDataWithoutStepsAndCalories(DateTime startDate, DateTime endDate) async {
    List<GFHealthData> allData = new List<GFHealthData>();
    for (int i = 0; i < GFDataType.values.length; i++) {
      if (i != GFDataType.values.indexOf(GFDataType.CALORIES) && i != GFDataType.values.indexOf(GFDataType.STEPS)) {
        allData.addAll(await getGFHealthData(startDate, endDate, i));
      }
    }
    return allData;
  }

  static Future<List<GFHealthData>> getSpecificGFDataList(DateTime startDate, DateTime endDate, List<GFDataType> list) async {
    List<GFHealthData> allData = new List<GFHealthData>();
    for (int i = 0; i < list.length; i++) {
      allData.addAll(await getGFHealthData(startDate, endDate, i));
    }
    return allData;
  }

  static Future<List<HKHealthData>> getHKAllDataWithCombinedBP(DateTime startDate, DateTime endDate) async {
    List<HKHealthData> allData = new List<HKHealthData>();
    var healthData = List.from(HKDataType.values);
    healthData.removeRange(
        HKDataType.values.indexOf(HKDataType.HIGH_HEART_RATE_EVENT), HKDataType.values.indexOf(HKDataType.IRREGULAR_HEART_RATE_EVENT));
    List<HKHealthData> bpRecords = [];
    for (int i = 0; i < healthData.length; i++) {
      if (healthData[i] == HKDataType.BLOOD_PRESSURE_SYSTOLIC) {
        bpRecords = await getHKHealthData(startDate, endDate, i);
      } else if (healthData[i] == HKDataType.BLOOD_PRESSURE_DIASTOLIC) {
        var dia = await getHKHealthData(startDate, endDate, i);
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

  static Future<List<HKHealthData>> getHKAllDataWithCombinedBPWithSpecificDataTypes(
      DateTime startDate, DateTime endDate, List<HKDataType> list) async {
    List<HKHealthData> allData = new List<HKHealthData>();
    List<HKHealthData> bpRecords = [];
    for (int i = 0; i < list.length; i++) {
      if (list[i] == HKDataType.BLOOD_PRESSURE_SYSTOLIC) {
        bpRecords = await getHKHealthData(startDate, endDate, i);
      } else if (list[i] == HKDataType.BLOOD_PRESSURE_DIASTOLIC) {
        var dia = await getHKHealthData(startDate, endDate, i);
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

  static Future<List<HKHealthData>> getHKAllDataWithCombinedBPWithoutSteps(DateTime startDate, DateTime endDate) async {
    List<HKHealthData> allData = new List<HKHealthData>();
    var healthData = List.from(HKDataType.values);
    healthData.removeRange(
        HKDataType.values.indexOf(HKDataType.HIGH_HEART_RATE_EVENT), HKDataType.values.indexOf(HKDataType.IRREGULAR_HEART_RATE_EVENT));
    List<HKHealthData> bpRecords = [];
    for (int i = 0; i < healthData.length; i++) {
      if (healthData[i] != HKDataType.STEPS &&
          healthData[i] != HKDataType.BASAL_ENERGY_BURNED &&
          healthData[i] != HKDataType.ACTIVE_ENERGY_BURNED &&
          healthData[i] != HKDataType.WAIST_CIRCUMFERENCE) {
        if (healthData[i] == HKDataType.BLOOD_PRESSURE_SYSTOLIC) {
          bpRecords = await getHKHealthData(startDate, endDate, i);
        } else if (healthData[i] == HKDataType.BLOOD_PRESSURE_DIASTOLIC) {
          var dia = await getHKHealthData(startDate, endDate, i);
          for (int j = 0; j < dia.length; j++) {
            try {
              bpRecords[j].value2 = dia[j].value;
            } catch (e) {}
          }
          allData.addAll(bpRecords);
        } else
          allData.addAll(await getHKHealthData(startDate, endDate, i));
      }
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

  static Future<List<HKHealthData>> getHKHealthSummary(DateTime startDate, DateTime endDate, int type) async {
    Map<String, dynamic> args = {};
    args.putIfAbsent('index', () => type);
    args.putIfAbsent('startDate', () => startDate.millisecondsSinceEpoch);
    args.putIfAbsent('endDate', () => endDate.millisecondsSinceEpoch);
    try {
      List result = await _channel.invokeMethod('getSummary', args);
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

class GFHealthData {
  String value;
  String value2;
  String unit;
  int dateFrom;
  int dateTo;
  GFDataType dataType;

  GFHealthData({this.value, this.unit, this.dateFrom, this.dateTo, this.dataType});

  GFHealthData.fromJson(Map<String, dynamic> json) {
    value = json['value'].toString();
    value2 = json['value2'].toString();
    unit = json['unit'];
    dateFrom = json['date_from'];
    dateTo = json['date_to'];
    dataType = GFDataType.values[json['data_type_index']];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['value'] = this.value;
    data['value2'] = this.value2;
    data['unit'] = this.unit;
    data['date_from'] = this.dateFrom;
    data['date_to'] = this.dateTo;
    data['data_type_index'] = GFDataType.values.indexOf(this.dataType);
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
  BODY_MASS,
  HIGH_HEART_RATE_EVENT,
  LOW_HEART_RATE_EVENT,
  IRREGULAR_HEART_RATE_EVENT,
}

enum GFDataType {
  BODY_FAT,
  HEIGHT,
  STEPS,
  CALORIES,
  HEART_RATE,
  BODY_TEMPERATURE,
  BLOOD_PRESSURE,
  BLOOD_OXYGEN,
  BLOOD_GLUCOSE,
  WEIGHT,
}
