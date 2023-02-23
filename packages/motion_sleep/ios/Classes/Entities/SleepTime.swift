//
//  SleepTime.swift
//  motion_sleep
//
//  Created by Michael Jajou on 2/23/23.
//

import Foundation

struct SleepTime {
    var startingHours: Int
    var startingMinutes: Int
    var endingHours: Int
    var endingMinutes: Int
    
    static func fromDictionary(_ data: NSDictionary) -> SleepTime {
        return SleepTime(
            startingHours: data["startingHours"] as! Int,
            startingMinutes: data["startingHours"] as! Int,
            endingHours: data["startingHours"] as! Int,
            endingMinutes: data["startingHours"] as! Int
        )
    }
}
