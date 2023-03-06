//
//  MotionSleepInterface.swift
//  motion_sleep
//
//  Created by Michael Jajou on 2/23/23.
//

import Foundation

protocol MotionSleepInterface {
    func isActivityAvailable() -> Bool
    func requestAuthorization()
    func fetchMostRecentSleepSession(
        start: Date,
        end: Date,
        sleepTime: SleepTime,
        completion: @escaping (Result<SleepSession, Error>) -> Void
    )
    func fetchSleepSessions(
        start: Date,
        end: Date,
        sleepTime: SleepTime,
        completion: @escaping (Result<[SleepSession], Error>) -> Void
    )
    func fetchActivities(
        start: Date,
        end: Date,
        completion: @escaping (Result<[MotionActivity], Error>) -> Void
    )
}
