//
//import Flutter
import UIKit
import HealthKit

public class SwiftHealthPlugin: NSObject, FlutterPlugin {
    let repository = SHPRepository()
    struct PluginError: Error { let message: String }
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "flutter_health", binaryMessenger: registrar.messenger())
        let instance = SwiftHealthPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        let method = SHPMethodCall(rawValue: call.method)
        switch method {
        case .checkIfHealthDataAvailable:
            checkIfHealthDataAvailable(call: call, result: result)
        case .getData:
            try! getData(call: call, result: result)
        case .getBatchData:
            try! getBatchData(call: call, result: result)
        case .requestAuthorization:
            try! requestAuthorization(call: call, result: result)
        case .getTotalStepsInInterval:
            getTotalStepsInInterval(call: call, result: result)
        case .writeData:
            try! writeData(call: call, result: result)
        case .writeAudiogram:
            try! writeAudiogram(call: call, result: result)
        case .writeWorkoutData:
            try! writeWorkoutData(call: call, result: result)
        case .hasPermissions:
            try! hasPermissions(call: call, result: result)
        default:
            print("Method not supported")
        }
    }
    
    func checkIfHealthDataAvailable(call: FlutterMethodCall, result: @escaping FlutterResult) {
        result(repository.checkIfHealthDataAvailable())
    }
    
    func hasPermissions(call: FlutterMethodCall, result: @escaping FlutterResult) throws {
        let arguments = call.arguments as? NSDictionary
        guard let typeStrings = arguments?["types"] as? Array<String>,
              let permissions = arguments?["permissions"] as? Array<Int>,
              typeStrings.count == permissions.count
        else { throw PluginError(message: "Invalid Arguments!") }
        let types = typeStrings.compactMap({ SHPSampleType(rawValue: $0) })
        result(repository.hasPermissions(types: types, permissions: permissions))
    }
    
    func requestAuthorization(call: FlutterMethodCall, result: @escaping FlutterResult) throws {
        guard let arguments = call.arguments as? NSDictionary,
              let typeStrings = arguments["types"] as? Array<String>,
              let permissions = arguments["permissions"] as? Array<Int>,
              permissions.count == typeStrings.count
        else { throw PluginError(message: "Invalid Arguments!") }
        
        let types = typeStrings.compactMap({ SHPSampleType(rawValue: $0) })
        repository.requestAuthorization(types: types, permissions: permissions) { success in
            DispatchQueue.main.async { result(success) }
        }
    }
    
    func writeData(call: FlutterMethodCall, result: @escaping FlutterResult) throws {
        guard let arguments = call.arguments as? NSDictionary,
              let value = (arguments["value"] as? Double),
              let typeString = (arguments["dataTypeKey"] as? String),
              let type = SHPSampleType(rawValue: typeString),
              let unitString = (arguments["dataUnitKey"] as? String),
              let unit = SHPUnit(rawValue: unitString),
              let startTime = (arguments["startTime"] as? NSNumber),
              let endTime = (arguments["endTime"] as? NSNumber)
        else { throw PluginError(message: "Invalid Arguments") }
        repository.writeData(
            value: value,
            type: type,
            unit: unit,
            startTime: Date(timeIntervalSince1970: startTime.doubleValue / 1000),
            endTime: Date(timeIntervalSince1970: endTime.doubleValue / 1000)
        ) { success in
            DispatchQueue.main.async { result(success) }
        }
    }
    
    func writeAudiogram(call: FlutterMethodCall, result: @escaping FlutterResult) throws {
        guard let arguments = call.arguments as? NSDictionary,
              let frequencies = (arguments["frequencies"] as? Array<Double>),
              let leftEarSensitivities = (arguments["leftEarSensitivities"] as? Array<Double>),
              let rightEarSensitivities = (arguments["rightEarSensitivities"] as? Array<Double>),
              let startTime = (arguments["startTime"] as? NSNumber),
              let endTime = (arguments["endTime"] as? NSNumber)
        else { throw PluginError(message: "Invalid Arguments") }
        
        let metadata = (arguments["metadata"] as? [String: Any]?)
        repository.writeAudiogram(
            frequencies: frequencies,
            leftEarSensitivities: leftEarSensitivities,
            rightEarSensitivities: rightEarSensitivities,
            startTime: Date(timeIntervalSince1970: startTime.doubleValue / 1000),
            endTime: Date(timeIntervalSince1970: endTime.doubleValue / 1000),
            deviceName: metadata?!["HKDeviceName"] as? String,
            externalUUID: metadata?!["HKExternalUUID"] as? String) { success in
                DispatchQueue.main.async { result(success) }
            }
    }
    
    func writeWorkoutData(call: FlutterMethodCall, result: @escaping FlutterResult) throws {
        guard let arguments = call.arguments as? NSDictionary,
              let activityTypeString = (arguments["activityType"] as? String),
              let activityType = SHPActivityType(rawValue: activityTypeString),
              let startTime = (arguments["startTime"] as? NSNumber),
              let endTime = (arguments["endTime"] as? NSNumber),
              let energyUnitString = (arguments["totalEnergyBurnedUnit"] as? String),
              let energyUnit = SHPUnit(rawValue: energyUnitString),
              let distanceUnitString = (arguments["totalDistanceUnit"] as? String),
              let distanceUnit = SHPUnit(rawValue: distanceUnitString)
        else { throw PluginError(message: "Invalid Arguments - ActivityType, startTime or endTime invalid") }
        
        repository.writeWorkoutData(
            activity: activityType,
            energyUnit: energyUnit,
            distanceUnit: distanceUnit,
            totalEnergyBurned: arguments["totalEnergyBurned"] as? Double,
            totalDistance: arguments["totalDistance"] as? Double,
            startTime: Date(timeIntervalSince1970: startTime.doubleValue / 1000),
            endTime: Date(timeIntervalSince1970: endTime.doubleValue / 1000)
        ) { success in
            DispatchQueue.main.async { result(success) }
        }
    }
    
    func getData(call: FlutterMethodCall, result: @escaping FlutterResult) throws {
        guard let arguments = call.arguments as? NSDictionary,
              let dataTypeKey = (arguments["dataTypeKey"] as? String),
              let dataType = SHPSampleType(rawValue: dataTypeKey),
              let dataUnitKey = (arguments["dataUnitKey"] as? String),
              let dataUnit = SHPUnit(rawValue: dataUnitKey),
              let startTime = (arguments["startTime"] as? NSNumber),
              let endTime = (arguments["endTime"] as? NSNumber)
        else { throw PluginError(message: "Invalid Arguments") }
        repository.getData(
            type: dataType,
            unit: dataUnit,
            startTime: Date(timeIntervalSince1970: startTime.doubleValue / 1000),
            endTime: Date(timeIntervalSince1970: endTime.doubleValue / 1000),
            limit: (arguments["limit"] as? Int) ?? HKObjectQueryNoLimit
        ) { success in
            let data = success.map({ $0.toData() })
            DispatchQueue.main.async { result(data) }
        }
    }
    
    func getBatchData(call: FlutterMethodCall, result: @escaping FlutterResult) throws {
        guard let arguments = call.arguments as? NSDictionary,
              let dataTypesKeys = (arguments["dataTypesKey"] as? [String]),
              let dataUnitKey = (arguments["dataUnitKey"] as? String),
              let dataUnit = SHPUnit(rawValue: dataUnitKey),
              let startTime = (arguments["startTime"] as? NSNumber),
              let endTime = (arguments["endTime"] as? NSNumber)
        else { throw PluginError(message: "Invalid Arguments") }
        repository.getBatchData(
            types: dataTypesKeys.compactMap({ SHPSampleType(rawValue: $0) }),
            unit: dataUnit,
            startTime: Date(timeIntervalSince1970: startTime.doubleValue / 1000),
            endTime: Date(timeIntervalSince1970: endTime.doubleValue / 1000),
            limit: (arguments["limit"] as? Int) ?? HKObjectQueryNoLimit
        ) { success in
            let data = success.map({ $0.toData() })
            DispatchQueue.main.async { result(data) }
        }
    }
    
    func getTotalStepsInInterval(call: FlutterMethodCall, result: @escaping FlutterResult) {
        let arguments = call.arguments as? NSDictionary
        let startTime = (arguments?["startTime"] as? NSNumber) ?? 0
        let endTime = (arguments?["endTime"] as? NSNumber) ?? 0
        repository.getTotalStepsInInterval(
            startTime: Date(timeIntervalSince1970: startTime.doubleValue / 1000),
            endTime: Date(timeIntervalSince1970: endTime.doubleValue / 1000)
        ) { steps in
            DispatchQueue.main.async { result(steps) }
        }
    }
}
