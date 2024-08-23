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
            "endDate": Int(endDate.timeIntervalSince1970 * 1000),
            "stationary": stationary,
            "walking": walking,
            "running": running,
            "automotive": automotive,
            "cycling": cycling,
            "confidence": confidence,
            "unknown": unknown
        ]
    }

    /* Inverted parser
    factory MotionActivity.fromEfficientJson(Map<String, dynamic> json) {
        final data = json['d'];
        return MotionActivity(
        startDate: DateTime.fromMillisecondsSinceEpoch(json['s']),
        endDate: DateTime.fromMillisecondsSinceEpoch(json['e']),
        stationary: data & 1 == 1,
        walking: data & 2 == 2,
        running: data & 4 == 4,
        automotive: data & 8 == 8,
        cycling: data & 16 == 16,
        unknown: data & 32 == 32,
        // confidence is actually 2 bits
        confidence: (data >> 6) & 3, // 0b11
        );
    }
    */
    func toEfficientData() -> NSDictionary {
        return [
            "s": Int(startDate.timeIntervalSince1970 * 1000),
            "e": Int(endDate.timeIntervalSince1970 * 1000),
            "d": (stationary ? 1 : 0) |
                (walking ? 2 : 0) |
                (running ? 4 : 0) |
                (automotive ? 8 : 0) |
                (cycling ? 16 : 0) |
                (unknown ? 32 : 0) |
                (confidence << 6)
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

    func toEfficientData() -> [NSDictionary] { map({ $0.toEfficientData() }) }
}

extension Array where Element == SleepSession {
    func toData() -> [NSDictionary] { map({ $0.toData() }) }
}
