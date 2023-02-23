import Flutter
import UIKit

public class MotionSleepPlugin: NSObject, FlutterPlugin {
    let manager = MotionSleepManager()
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "motion_sleep", binaryMessenger: registrar.messenger())
        let instance = MotionSleepPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        let method = MotionSleepMethod(rawValue: call.method)
        switch method {
        case .fetchActivites:
            fetchActivities(call: call, result: result)
        case .fetchRecentSleepSession:
            fetchRecentSleepSession(call: call, result: result)
        case .fetchSleepSessions:
            fetchSleepSessions(call: call, result: result)
        case .isActivityAvailable:
            isActivityAvailable(call: call, result: result)
        case .requestAuthorization:
            requestAuthorization(call: call, result: result)
        default:
            print("\(call.method) is not supported")
        }
    }
    
    func fetchActivities(call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let arguments = call.arguments as? NSDictionary,
              let startDate = arguments["start"] as? Int,
              let endDate = arguments["end"] as? Int
        else { result("Invalid Arguments"); return }
        
        let start = Date(timeIntervalSince1970: Double(startDate) / 1000)
        let end = Date(timeIntervalSince1970: Double(endDate) / 1000)
        manager.fetchActivities(start: start, end: end) { motionResult in
            DispatchQueue.main.async {
                switch motionResult {
                case .success(let activities): result(activities.toData())
                case .failure(let error): result(error.localizedDescription)
                }
            }
        }
    }
    
    func fetchRecentSleepSession(call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let arguments = call.arguments as? NSDictionary,
              let startDate = arguments["start"] as? Int,
              let endDate = arguments["end"] as? Int,
              let sleepTimeData = arguments["sleepTime"] as? NSDictionary
        else { result("Invalid Arguments"); return }
        
        let start = Date(timeIntervalSince1970: Double(startDate) / 1000)
        let end = Date(timeIntervalSince1970: Double(endDate) / 1000)
        let sleepTime = SleepTime.fromDictionary(sleepTimeData)
        
        manager.fetchMostRecentSleepSession(start: start, end: end, sleepTime: sleepTime) { motionResult in
            DispatchQueue.main.async {
                switch motionResult {
                case .success(let activities): result(activities.toData())
                case .failure(let error): result(error.localizedDescription)
                }
            }
        }
    }
    
    func fetchSleepSessions(call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let arguments = call.arguments as? NSDictionary,
              let startDate = arguments["start"] as? Int,
              let endDate = arguments["end"] as? Int,
              let sleepTimeData = arguments["sleepTime"] as? NSDictionary
        else { result("Invalid Arguments"); return }
        
        let start = Date(timeIntervalSince1970: Double(startDate) / 1000)
        let end = Date(timeIntervalSince1970: Double(endDate) / 1000)
        let sleepTime = SleepTime.fromDictionary(sleepTimeData)
        
        manager.fetchSleepSessions(start: start, end: end, sleepTime: sleepTime) { motionResult in
            DispatchQueue.main.async {
                switch motionResult {
                case .success(let activities): result(activities.toData())
                case .failure(let error): result(error.localizedDescription)
                }
            }
        }
    }
    
    func isActivityAvailable(call: FlutterMethodCall, result: @escaping FlutterResult) {
        result(manager.isActivityAvailable())
    }
    
    func requestAuthorization(call: FlutterMethodCall, result: @escaping FlutterResult) {
        manager.requestAuthorization()
        result(true)
    }
}
