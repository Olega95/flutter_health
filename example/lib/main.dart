import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_health/flutter_health.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var _healthKitOutput;
  var _hkDataList = List<HKHealthData>();
  var _gfDataList = List<GFHealthData>();
  var str = "";
  bool _isAuthorized = true;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    /*Future.delayed(Duration(seconds: 2), () async {
      _healthKitOutput = await FlutterHealth.checkIfHealthDataAvailable();
      setState(() {});
    });*/

    DateTime startDate = DateTime.utc(2020, 03, 21);
    DateTime endDate = DateTime.now();
    Future.delayed(Duration(seconds: 2), () async {
      _isAuthorized = await FlutterHealth.requestAuthorization();
      if (_isAuthorized) _gfDataList.addAll(await FlutterHealth.getGFAllData(startDate, endDate));
      setState(() {});
//      if (_isAuthorized) _hkDataList.addAll(await FlutterHealth.getHKAllDataWithCombinedBPWithoutSteps(startDate, endDate));
//      setState(() {});
//      if (_isAuthorized) _dataList.addAll(await FlutterHealth.getHKStepCount(startDate, endDate));
//      setState(() {});
//      if (_isAuthorized) _dataList.addAll(await FlutterHealth.getHKHeartRate(startDate, endDate));
//      setState(() {});
      /* if (_isAuthorized) _dataList.addAll(await FlutterHealth.getHeight(startDate, endDate));
      setState(() {});
      if (_isAuthorized) _dataList.addAll(await FlutterHealth.getBodyMass(startDate, endDate));
      setState(() {});
      if (_isAuthorized) _dataList.addAll(await FlutterHealth.getWaistCircumference(startDate, endDate));
      setState(() {});
      if (_isAuthorized) _dataList.addAll(await FlutterHealth.getStepCount(startDate, endDate));
      setState(() {});
      if (_isAuthorized) _dataList.addAll(await FlutterHealth.getBasalEnergyBurned(startDate, endDate));
      setState(() {});
      if (_isAuthorized) _dataList.addAll(await FlutterHealth.getActiveEnergyBurned(startDate, endDate));
      setState(() {});
      if (_isAuthorized) _dataList.addAll(await FlutterHealth.getHeartRate(startDate, endDate));
      setState(() {});
      if (_isAuthorized) _dataList.addAll(await FlutterHealth.getRestingHeartRate(startDate, endDate));
      setState(() {});
      if (_isAuthorized) _dataList.addAll(await FlutterHealth.getWalkingHeartRate(startDate, endDate));
      setState(() {});
      if (_isAuthorized) _dataList.addAll(await FlutterHealth.getBodyTemperature(startDate, endDate));
      setState(() {});
      if (_isAuthorized) _dataList.addAll(await FlutterHealth.getBloodPressureSys(startDate, endDate));
      if (_isAuthorized) _dataList.addAll(await FlutterHealth.getBloodPressureDia(startDate, endDate));
      if (_isAuthorized) _dataList.addAll(await FlutterHealth.getBloodOxygen(startDate, endDate));
      if (_isAuthorized) _dataList.addAll(await FlutterHealth.getBloodGlucose(startDate, endDate));
      if (_isAuthorized) _dataList.addAll(await FlutterHealth.getElectrodermalActivity(startDate, endDate));
      setState(() {});*/
    });

    /*Future.delayed(Duration(seconds: 2), () async {
      _healthKitOutput = await FlutterHealth.getBloodType(context);
      setState(() {});
    });*/

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.sync),
              onPressed: () {
                initPlatformState();
              },
            )
          ],
        ),
        body: _hkDataList.isEmpty
            ? Text('Running on: $_healthKitOutput\n')
            : ListView.builder(
            itemCount: _hkDataList.length,
            itemBuilder: (_, index) =>
                ListTile(
                  title: Text(_hkDataList[index].value.toString() + " " + _hkDataList[index].value2.toString()),
                  trailing: Text(_hkDataList[index].unit),
                  subtitle: Text(DateTime.fromMillisecondsSinceEpoch(_hkDataList[index].dateFrom).toIso8601String()),
                  /*title: Text(str),
                  trailing: Text(str),
                  subtitle: Text(str),*/
                )),
      ),
    );
  }
}
