import Flutter
import UIKit
import HealthKit

public class SwiftFlutterHealthPlugin: NSObject, FlutterPlugin {
    
    let healthStore = HKHealthStore()

  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "flutter_health", binaryMessenger: registrar.messenger())
    let instance = SwiftFlutterHealthPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    if(call.method.elementsEqual("checkIfHealthDataAvailable")){
        if HKHealthStore.isHealthDataAvailable() {
            result("Matomo:: HealthKit available.")
        }
    } else if(call.method.elementsEqual("requestAuthorization")){
        if #available(iOS 11.0, *) {
            let allTypes = Set([
                HKObjectType.workoutType(),
                HKSampleType.quantityType(forIdentifier: .bodyFatPercentage)!,
                HKSampleType.quantityType(forIdentifier: .height)!,
                HKSampleType.quantityType(forIdentifier: .bodyMassIndex)!,
                HKSampleType.quantityType(forIdentifier: .waistCircumference)!,
                HKSampleType.quantityType(forIdentifier: .stepCount)!,
                HKSampleType.quantityType(forIdentifier: .basalEnergyBurned)!,
                HKSampleType.quantityType(forIdentifier: .activeEnergyBurned)!,
                HKSampleType.quantityType(forIdentifier: .heartRate)!,
                HKSampleType.quantityType(forIdentifier: .restingHeartRate)!,
                HKSampleType.quantityType(forIdentifier: .walkingHeartRateAverage)!,
                HKSampleType.quantityType(forIdentifier: .bodyTemperature)!,
                HKSampleType.quantityType(forIdentifier: .bloodPressureSystolic)!,
                HKSampleType.quantityType(forIdentifier: .bloodPressureDiastolic)!,
                HKSampleType.quantityType(forIdentifier: .oxygenSaturation)!,
                HKSampleType.quantityType(forIdentifier: .bloodGlucose)!,
                HKSampleType.quantityType(forIdentifier: .electrodermalActivity)!,
                ])
            healthStore.requestAuthorization(toShare: nil, read: allTypes) { (success, error) in
                if !success {
                    result(false)// Handle the error here.
                } else{
                    result(true)
                }
            }
        } else {
            // Fallback on earlier versions
        }
        
        
    } else if(call.method.elementsEqual("getData")){
        let arguments = call.arguments as? NSDictionary
        let index = (arguments?["index"] as? Int) ?? -1
        let startDate = (arguments?["startDate"] as? NSNumber) ?? 0
        let endDate = (arguments?["endDate"] as? NSNumber) ?? 0
        
        
        let dateFrom = Date(timeIntervalSince1970: startDate.doubleValue / 1000)
        let dateTo = Date(timeIntervalSince1970: endDate.doubleValue / 1000)
        
        if #available(iOS 11.0, *) {
            let allTypes = [
                HKSampleType.quantityType(forIdentifier: .bodyFatPercentage)!,
                HKSampleType.quantityType(forIdentifier: .height)!,
                HKSampleType.quantityType(forIdentifier: .bodyMassIndex)!,
                HKSampleType.quantityType(forIdentifier: .waistCircumference)!,
                HKSampleType.quantityType(forIdentifier: .stepCount)!,
                HKSampleType.quantityType(forIdentifier: .basalEnergyBurned)!,
                HKSampleType.quantityType(forIdentifier: .activeEnergyBurned)!,
                HKSampleType.quantityType(forIdentifier: .heartRate)!,
                HKSampleType.quantityType(forIdentifier: .restingHeartRate)!,
                HKSampleType.quantityType(forIdentifier: .walkingHeartRateAverage)!,
                HKSampleType.quantityType(forIdentifier: .bodyTemperature)!,
                HKSampleType.quantityType(forIdentifier: .bloodPressureSystolic)!,
                HKSampleType.quantityType(forIdentifier: .bloodPressureDiastolic)!,
                HKSampleType.quantityType(forIdentifier: .oxygenSaturation)!,
                HKSampleType.quantityType(forIdentifier: .bloodGlucose)!,
                HKSampleType.quantityType(forIdentifier: .electrodermalActivity)!,
                ]
            print("INDEX IS " , index)
            print("COUNT IS " , allTypes.count)
            if(index >= 0 && index < allTypes.count){
                let dataType = allTypes[index]
                print("DATA TYPE IS ", dataType)
                let predicate = HKQuery.predicateForSamples(withStart: dateFrom, end: dateTo, options: .strictStartDate)
                print("PREDICATE ", predicate)
                
                let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: true)

                
                let query = HKSampleQuery(sampleType: dataType, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: [sortDescriptor]) {
                    _, samplesOrNil, error in
                    
                    print("BEFORE GUARD")

                    guard let samples = samplesOrNil as? [HKQuantitySample] else {
                        print("SAMPLES NULL")
                        result(FlutterError(code: "FlutterHealth", message: "Results are null", details: error))
                        return
                    }
                    print(samples)
                    result(samples.map { sample -> NSDictionary in
                        print(sample.quantity.doubleValue(for: HKUnit.init(from: "count/min")))
                        return [
                            "value": sample.quantity.doubleValue(for: HKUnit.init(from: "count/min")),
                            "date_from": Int(sample.startDate.timeIntervalSince1970 * 1000),
                            "date_to": Int(sample.endDate.timeIntervalSince1970 * 1000),
                        ]
                    })
                    return
                }
                
                
                
                
                
                
                
                
                
                
//
//                let query = HKSampleQuery(sampleType: dataType,
//                                                predicate: predicate,
//                                                limit: HKObjectQueryNoLimit,
//                                                sortDescriptors: nil) {
//                                                    (query, sample, error) in
//                                                    print("BEFORE GUARD")
//                                                    guard
//                                                        error == nil,
//                                                        let quantitySamples = sample as? [HKQuantitySample] else {
//                                                            print("Something went wrong: \(String(describing: error))")
//                                                            return
//                                                    }
//                                                    print("AFTER GUARD AND LEN IS " , quantitySamples.count)
//
//                                                    for (index, element) in quantitySamples.enumerated() {
//                                                        print("Item \(index): \(element)")
//                                                    }
//
//                                                    result(quantitySamples.map { sample -> NSDictionary in
//                                                        return [
//                                                            "value": sample.quantity.doubleValue,
//                                                            "date_from": Int(sample.startDate.timeIntervalSince1970 * 1000),
//                                                            "date_to": Int(sample.endDate.timeIntervalSince1970 * 1000),
//                                                        ]
//                                                    })
//
//                }
                HKHealthStore().execute(query)
            } else{
                print("Something wrong with request")
                result("Unsupported version or data type")
            }
        } else {
            print("Unsupported version 1")
            result("Unsupported version or data type")
        }
        print("Unsupported version")
    }
  }
}




