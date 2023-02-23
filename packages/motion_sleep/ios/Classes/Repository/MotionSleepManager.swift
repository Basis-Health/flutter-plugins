//
//  MotionSleepManager.swift
//  motion_sleep
//
//  Created by Michael Jajou on 2/23/23.
//

import Foundation
import CoreMotion

class MotionSleepManager: MotionSleepInterface {
    static let shared = MotionSleepManager()
    private let manager = CMMotionActivityManager()
    
    func isActivityAvailable() -> Bool { CMMotionActivityManager.isActivityAvailable() }
    
    func requestAuthorization() { manager.queryActivityStarting(from: Date(), to: Date(), to: .main) { _, _ in } }
    
    func fetchMostRecentSleepSession(
        start: Date,
        end: Date,
        sleepTime: SleepTime,
        completion: @escaping (Result<SleepSession, Error>) -> Void
    ) {
        manager.queryActivityStarting(
            from: start,
            to: end,
            to: OperationQueue.main
        ) { activities, error in
            if let error = error {
                completion(.failure(error))
            } else if let sleepSession = activities?.toEligibleSleepSessions(sleepTime: sleepTime).latest() {
                completion(.success(sleepSession))
            } else {
                completion(.failure(self.defaultError))
            }
        }
    }
    
    func fetchSleepSessions(
        start: Date,
        end: Date,
        sleepTime: SleepTime,
        completion: @escaping (Result<[SleepSession], Error>) -> Void
    ) {
        self.manager.queryActivityStarting(
            from: start,
            to: end,
            to: OperationQueue.main
        ) { activities, error in
            if let error = error {
                completion(.failure(error))
            } else if let activities = activities {
                completion(.success(activities.toEligibleSleepSessions(sleepTime: sleepTime)))
            } else {
                completion(.failure(self.defaultError))
            }
        }
    }
    
    func fetchActivities(
        start: Date,
        end: Date,
        completion: @escaping (Result<[MotionActivity], Error>) -> Void
    ) {
        self.manager.queryActivityStarting(
            from: start,
            to: end,
            to: OperationQueue.main
        ) { activities, error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(activities?.compactMap({ $0.toMotionActivity() }) ?? []))
            }
        }
    }
    
    private var defaultError: NSError {
        NSError(
            domain: Bundle.main.bundleIdentifier ?? String(),
            code: NSUserCancelledError,
            userInfo: nil
        )
    }
}
