//
//  Entities+Data.swift
//  motion_sleep
//
//  Created by Michael Jajou on 2/23/23.
//

import Foundation

extension MotionActivity {
    func toData() -> NSDictionary {
        return [
            "startDate": Int(startDate.timeIntervalSince1970 * 1000),
            "endDate": Int(startDate.timeIntervalSince1970 * 1000),
            "stationary": stationary,
            "walking": walking,
            "running": running,
            "automotive": automotive,
            "cycling": cycling,
            "confidence": confidence,
            "unknown": unknown
        ]
    }
}

extension SleepSession {
    func toData() -> NSDictionary {
        return [
            "type": type.rawValue,
            "startDate": Int(startDate.timeIntervalSince1970 * 1000),
            "endDate": Int(startDate.timeIntervalSince1970 * 1000),
            "source": source.rawValue
        ]
    }
}

extension Array where Element == MotionActivity {
    func toData() -> [NSDictionary] { map({ $0.toData() }) }
}

extension Array where Element == SleepSession {
    func toData() -> [NSDictionary] { map({ $0.toData() }) }
}
