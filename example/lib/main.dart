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
  var _dataList = List<HKHealthData>();
  bool _isAuthorized = false;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    Future.delayed(Duration(seconds: 2), () async {
      _healthKitOutput = await FlutterHealth.checkIfHealthDataAvailable(context);
      setState(() {});
    });

    DateTime startDate = DateTime.utc(2018);
    DateTime endDate = DateTime.now();
    Future.delayed(Duration(seconds: 2), () async {
      _isAuthorized = await FlutterHealth.requestAuthorization(context);
      if (_isAuthorized) _dataList = await FlutterHealth.getHeartRate(context, startDate, endDate);
      setState(() {});
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
        ),
        body: Center(
          child: Column(
            children: <Widget>[
              Text('Running on: $_healthKitOutput\n'),
              Text('Running on: ${_dataList.length > 0 ? _dataList[0].value : _dataList.length}\n'),
            ],
          ),
        ),
      ),
    );
  }
}
