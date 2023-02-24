//
//  MotionActivity.swift
//  motion_sleep
//
//  Created by Michael Jajou on 2/23/23.
//

import Foundation
import CoreMotion

struct MotionActivity: Codable {
    var startDate: Date
    var endDate: Date
    var stationary: Bool
    var walking: Bool
    var running: Bool
    var automotive: Bool
    var cycling: Bool
    var confidence: Int
    var unknown: Bool
    
    init(activity: CMMotionActivity) {
        self.startDate = activity.startDate
        self.endDate = activity.startDate
        self.stationary = activity.stationary
        self.walking = activity.walking
        self.running = activity.running
        self.automotive = activity.automotive
        self.cycling = activity.cycling
        self.confidence = activity.confidence.rawValue
        self.unknown = activity.unknown
    }
}

extension Array where Element == MotionActivity {
    func toSleepSessions() -> [SleepSession] {
        var results: [DateInterval] = []
        for activity in self {
            if let lastResult = results.last {
                if activity.startDate > lastResult.end && activity.isEligibleForSleep() {
                    if let nextActivity = self.first(where: { $0.startDate > activity.startDate && $0.isEligibleForSleepInterval(lowerBound: activity) }) {
                        results.append(DateInterval(start: activity.startDate, end: nextActivity.startDate))
                        continue
                    }
                }
            } else {
                if activity.isEligibleForSleep() {
                    if let nextActivity = self.first(where: { $0.isEligibleForSleepInterval(lowerBound: activity) }) {
                        results.append(DateInterval(start: activity.startDate, end: nextActivity.startDate))
                        continue
                    }
                }
            }
        }
        return results.compactMap({ SleepSession(type: .asleep, startDate: $0.start, endDate: $0.end, source: SleepSessionSource.motion) })
    }

    func toEligibleSleepSessions(sleepTime: SleepTime) -> [SleepSession] {
        var calendar = Calendar.autoupdatingCurrent
        if let timeZone = TimeZone(secondsFromGMT: 0) {
            calendar.timeZone = timeZone
        }
        
        let sleepSessions = self.toSleepSessions()
        let filteredSleepSessions = sleepSessions.filter { sleepSession -> Bool in
            if sleepSession.interval.duration < 1800 {
                return false
            }
            guard let sleepStartTime = self.date(date: sleepSession.interval.start, with: sleepTime.startingHours, minute: sleepTime.startingMinutes, calendar: calendar),
                  let sleepEndTime = self.date(date: sleepSession.interval.end, with: sleepTime.endingHours, minute: sleepTime.endingMinutes, calendar: calendar),
                  sleepStartTime <= sleepEndTime else {
                return false
            }
            let sleepTimeInterval = DateInterval(start: sleepStartTime, end: sleepEndTime)
            return sleepTimeInterval.contains(sleepSession.startDate) && sleepTimeInterval.contains(sleepSession.endDate)
        }
        return self.aggregate(sleepSessions: filteredSleepSessions, component: .minute, difference: 15, calendar: calendar)
    }
    
    private func date(date: Date, with hour: Int, minute: Int, calendar: Calendar) -> Date? {
        var dateComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        dateComponents.hour = hour
        dateComponents.minute = minute
        dateComponents.second = 0
        return calendar.date(from: dateComponents)
    }
    
    func aggregate(sleepSessions: [SleepSession], component: Calendar.Component, difference: Int, calendar: Calendar) -> [SleepSession] {
        let intervals: [DateInterval] = sleepSessions.compactMap({ $0.interval }).sorted(by: { $0 < $1 })
        var results: [DateInterval] = []
        for interval in intervals {
            if let lastResult = results.last {
                let dateComponents = calendar.dateComponents([component], from: lastResult.end, to: interval.start)
                if let value = dateComponents.value(for: component) {
                    let absoluteValue = abs(value)
                    if absoluteValue <= difference {
                        if let lastResultIndex = results.lastIndex(where: { $0 == lastResult }) {
                            results[lastResultIndex] = DateInterval(start: lastResult.start, end: interval.end)
                            continue
                        }
                    } else {
                        results.append(interval)
                        continue
                    }
                }
            } else {
                results.append(interval)
                continue
            }
        }
        return results.compactMap({ SleepSession(type: .asleep, startDate: $0.start, endDate: $0.end, source: .motion) })
    }
}

private extension MotionActivity {
    func isEligibleForSleep() -> Bool {
        if self.cycling || self.running || self.walking || self.automotive || self.unknown || !self.stationary {
            return false
        }
        if self.stationary && self.confidence == CMMotionActivityConfidence.high.rawValue {
            return true
        }
        return false
    }

    func isNotEligibleForSleep() -> Bool {
        if (self.cycling || self.running || self.walking || self.automotive || self.unknown || !self.stationary) && self.confidence == CMMotionActivityConfidence.high.rawValue {
            return true
        }
        return false
    }

    func isEligibleForSleepInterval(lowerBound: MotionActivity) -> Bool {
        if lowerBound.startDate > self.startDate {
            return false
        }
        if !lowerBound.isEligibleForSleep() {
            return false
        }
        if !self.isNotEligibleForSleep() {
            return false
        }
        return true
    }
}
