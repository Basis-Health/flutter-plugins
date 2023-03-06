//
//  SleepSession.swift
//  motion_sleep
//
//  Created by Michael Jajou on 2/23/23.
//

import Foundation

enum SleepSessionType: String, Codable {
    case asleep
    case inBed
    case awake
}

enum SleepSessionSource: String, Codable, Hashable {
    case motion
    case manual
}

struct SleepSession: Codable, Hashable {
    var type: SleepSessionType
    var startDate: Date
    var endDate: Date
    var source: SleepSessionSource
    
    func log() {
        print("Sleep session: \(self.startDate) - \(self.endDate), type: \(self.type.rawValue), source: \(self.source.rawValue)")
    }
}

extension SleepSession {
    var interval: DateInterval {
        return DateInterval(start: self.startDate, end: self.endDate)
    }
}

extension Array where Element == SleepSession {
    func eligible() -> [SleepSession] {
        let asleep = self.filter({ $0.type == .asleep })
        let inBed = self.filter({ $0.type == .inBed })
        if !asleep.isEmpty {
            return asleep
        } else if !inBed.isEmpty {
            return inBed
        }
        return []
    }

    func interval() -> DateInterval? {
        if let oldestSleepSession = self.oldest(), let latestSleepSession = self.latest() {
            return DateInterval(start: oldestSleepSession.startDate, end: latestSleepSession.endDate)
        }
        return nil
    }

    func intervals() -> [DateInterval] {
        return self.map({ $0.interval })
    }

    func oldest() -> SleepSession? {
        return self.max(by: { $0.startDate > $1.startDate })
    }

    func latest() -> SleepSession? {
        return self.max(by: { $0.endDate < $1.endDate })
    }
}
