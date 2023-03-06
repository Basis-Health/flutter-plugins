//
//  SHP+Call.swift
//  health_plugin
//
//  Created by Michael Jajou on 1/10/23.
//

import Foundation
import HealthKit

enum SHPMethodCall: String {
    case checkIfHealthDataAvailable
    case getBatchData
    case getData
    case getDevices
    case requestAuthorization
    case getTotalStepsInInterval
    case writeData
    case writeAudiogram
    case writeWorkoutData
    case hasPermissions
}
