//
//import Flutter
import UIKit
import HealthKit

struct PluginError: Error { let message: String }

// Extend PluginError to conform to LocalizedError
extension PluginError: LocalizedError {
    // Provide a custom error description
    var errorDescription: String? {
        return message
    }
}

public class SwiftHealthPlugin: NSObject, FlutterPlugin {
    let repository = SHPRepository()
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "flutter_health", binaryMessenger: registrar.messenger())
        let instance = SwiftHealthPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        do {
            let method = SHPMethodCall(rawValue: call.method)
            switch method {
            case .checkIfHealthDataAvailable:
                checkIfHealthDataAvailable(call: call, result: result)
            case .getData:
                try getData(call: call, result: result)
            case .getDataWithAnchor:
                try getDataWithAnchor(call: call, result: result)
            case .getBiologicalGender:
                getBiologicalGender(call: call, result: result)
            case .getDateOfBirth:
                getDateOfBirth(call: call, result: result)
            case .getBatchData:
                try getBatchData(call: call, result: result)
            case .getDevices:
                getDevices(call: call, result: result)
            case .requestAuthorization:
                try requestAuthorization(call: call, result: result)
            case .getTotalStepsInInterval:
                getTotalStepsInInterval(call: call, result: result)
            case .writeData:
                try writeData(call: call, result: result)
            case .writeAudiogram:
                try writeAudiogram(call: call, result: result)
            case .writeWorkoutData:
                try writeWorkoutData(call: call, result: result)
            case .hasPermissions:
                try hasPermissions(call: call, result: result)
            default:
                result(FlutterError(code: "not_implemented", message: "Method not implemented", details: nil))
            }
        } catch {
            result(FlutterError(code: "error", message: "Error: \(error.localizedDescription)", details: nil))
        
        }
    }
    
    func checkIfHealthDataAvailable(call: FlutterMethodCall, result: @escaping FlutterResult) {
        result(repository.checkIfHealthDataAvailable())
    }
    
    func getBiologicalGender(call: FlutterMethodCall, result: @escaping FlutterResult) {
        repository.getBiologicalGender() { success in
            DispatchQueue.main.async { result(success) }
        }
    }

    func getDateOfBirth(call: FlutterMethodCall, result: @escaping FlutterResult) {
        repository.getDateOfBirth() { success in
            DispatchQueue.main.async {
                if let date = success {
                    // Date is not nil, format it and send back
                    let formattedDate = ISO8601DateFormatter().string(from: date)
                    result(formattedDate)
                } else {
                    // Date is nil, send back null
                    result(nil)
                }
            }
        }
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
              let objectTypeStrings = arguments["objectTypes"] as? Array<String>,
              let permissions = arguments["permissions"] as? Array<Int>,
              permissions.count == typeStrings.count
        else { throw PluginError(message: "Invalid Arguments!") }

        let types = typeStrings.compactMap({ SHPSampleType(rawValue: $0) })
        let objectTypes = objectTypeStrings.compactMap({ SHPObjectType(rawValue: $0) })
        repository.requestAuthorization(types: types, objectTypes: objectTypes, permissions: permissions) { success in
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

    func createPredicate(startTime: NSNumber?, endTime: NSNumber?) -> NSPredicate? {
        if let start = startTime, let end = endTime {
            // Both start and end times are provided
            return HKQuery.predicateForSamples(
                withStart: Date(timeIntervalSince1970: start.doubleValue / 1000),
                end: Date(timeIntervalSince1970: end.doubleValue / 1000),
                options: .strictStartDate)
        } else if let start = startTime {
            // Only start time is provided
            return HKQuery.predicateForSamples(
                withStart: Date(timeIntervalSince1970: start.doubleValue / 1000),
                end: nil,
                options: .strictStartDate)
        } else if let end = endTime {
            // Only end time is provided
            return HKQuery.predicateForSamples(
                withStart: nil,
                end: Date(timeIntervalSince1970: end.doubleValue / 1000),
                options: .strictStartDate)
        } else {
            // Neither start nor end time is provided, could fetch all samples
            // Note: Depending on your use case, you might not want to set a predicate at all if fetching all samples
            return nil // Or some default predicate depending on your specific requirements
        }
    }

    func getDataWithAnchor(call: FlutterMethodCall, result: @escaping FlutterResult) throws {
        guard let arguments = call.arguments as? NSDictionary else { throw PluginError(message: "Invalid Arguments: not a dictionary")}

        // Since sampleType seems to be required, no change needed here.
        guard let sampleTypeValue = arguments.value(forKey: "sampleType") else { throw PluginError(message: "Invalid Arguments: sampleType not found")}
        guard let sampleTypeData = try? JSONSerialization.data(withJSONObject: sampleTypeValue) else { throw PluginError(message: "Invalid Arguments: sampleType not found")}
        guard let sampleType = try? JSONDecoder().decode(SHPSampleQuery.self, from: sampleTypeData) else { throw PluginError(message: "Invalid Arguments: sampleType not found")}

        // Allowing nil for startTime, endTime, limit, and anchorString
        let startTime = arguments["startTime"] as? NSNumber
        let endTime = arguments["endTime"] as? NSNumber
        let limit = arguments["limit"] as? Int
        let anchorString = arguments["anchor"] as? String

        let predicate = createPredicate(startTime: startTime, endTime: endTime)
        let sortDescriptor = NSSortDescriptor(
            key: HKSampleSortIdentifierEndDate,
            ascending: false
        )

        repository.getBatchQueryUsingAnchor(
            sampleType: sampleType,
            limit: limit ?? HKObjectQueryNoLimit,
            predicate: predicate,
            sortDescriptors: [sortDescriptor],
            anchorString: anchorString
        ) { success, error in
            if let error = error {
                DispatchQueue.main.async { result(FlutterError(code: "error", message: error.localizedDescription, details: nil)) }
            } else {
                DispatchQueue.main.async { result(success.toData()) }
            }
        }
    }
    
    func getBatchData(call: FlutterMethodCall, result: @escaping FlutterResult) throws {
        guard let arguments = call.arguments as? NSDictionary,
              let sampleTypesValue = arguments.value(forKey: "dataTypes"),
              let sampleTypesData = try? JSONSerialization.data(withJSONObject: sampleTypesValue),
              let sampleTypes = try? JSONDecoder().decode([SHPSampleQuery].self, from: sampleTypesData),
              let startTime = (arguments["startTime"] as? NSNumber),
              let endTime = (arguments["endTime"] as? NSNumber)
        else { throw PluginError(message: "Invalid Arguments") }
        repository.getBatchData(
            types: sampleTypes,
            startTime: Date(timeIntervalSince1970: startTime.doubleValue / 1000),
            endTime: Date(timeIntervalSince1970: endTime.doubleValue / 1000),
            limit: (arguments["limit"] as? Int) ?? HKObjectQueryNoLimit
        ) { success in
            let data = success.groupedBySampleTypeData()
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
    
    func getDevices(call: FlutterMethodCall, result: @escaping FlutterResult) {
        repository.getDevices(completion: { devices in
            DispatchQueue.main.async { result(devices.toData()) }
        })
    }
}
