# flutter_health

Apple Health Kit library for Flutter that support most of the values provided.

Works on from **iOS 11.0**. Some data types are supported from **iOS 12.2**.

[Dart package](https://pub.dev/packages/flutter_health)

[Gitlab link](https://gitlab.com/petleo-and-iatros-opensource/flutter_health)


## How to use

#### Check if Apple Health is available on the device

```$xslt
await FlutterHealth.checkIfHealthDataAvailable()
```

#### Request authorization for the data types supported by the plugin

```$xslt
await FlutterHealth.requestAuthorization()
``` 
######For now, you can request all of the options provided by the library


#### Get the samples of data types authorized by the user within the given time range

```$xslt
await FlutterHealth.getBodyFat(startDate, endDate)
``` 

```$xslt
await FlutterHealth.getHeartRate(startDate, endDate)
``` 

```$xslt
await FlutterHealth.getBloodPressureSys(startDate, endDate)
``` 
...



#### Data will be returning as a List of an object called HKHealthData. This object has the following attributes:

```$xslt
 double value;
 String unit;
 int dateFrom;
 int dateTo;
``` 

### You can get those values with this library:

**Tested:** 

* bodyFatPercentage
* height
* bodyMassIndex
* waistCircumference
* stepCount
* basalEnergyBurned
* activeEnergyBurned
* heartRate
* restingHeartRate
* walkingHeartRateAverage
* bodyTemperature
* bloodPressureSystolic
* bloodPressureDiastolic
* oxygenSaturation
* bloodGlucose
* electrodermalActivity 

**Could not be tested without a watch:**
  
* highHeartRateEvent
* lowHeartRateEvent
* irregularHeartRhythmEvent

## Full Example

```$xslt
 bool _isAuthorized = true;
 DateTime startDate = DateTime.utc(2018);
 DateTime endDate = DateTime.now();
 var _dataList = List<HKHealthData>();
 
 _isAuthorized = await FlutterHealth.requestAuthorization();
 
 if (_isAuthorized) {
     _dataList.addAll(await FlutterHealth.getBodyFat(startDate, endDate));
     _dataList.addAll(await FlutterHealth.getHeight(startDate, endDate));
 }

``` 