//
//  SHPSampleUnit.swift
//  health
//
//  Created by Michael Jajou on 1/16/23.
//

import Foundation
import HealthKit

struct SHPSampleQuery: Codable {
    let type: SHPSampleType
    var unit: SHPUnit = .NO_UNIT
    
    func isType(_ hkType: HKSampleType) -> Bool { type.sampleType == hkType }
}

extension Array where Element == SHPSampleQuery {
    func unitForType(_ sample: HKSampleType) -> SHPUnit {
        return self.first(where: { $0.isType(sample) })?.unit ?? .NO_UNIT
    }
}
