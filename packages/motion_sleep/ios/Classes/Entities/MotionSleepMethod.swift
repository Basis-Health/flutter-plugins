//
//  MotionSleepMethod.swift
//  motion_sleep
//
//  Created by Michael Jajou on 2/23/23.
//

import Foundation

enum MotionSleepMethod: String {
    case fetchAuthorizationStatus
    case fetchActivities
    case fetchRecentSleepSession
    case fetchSleepSessions
    case isActivityAvailable
    case requestAuthorization
}
