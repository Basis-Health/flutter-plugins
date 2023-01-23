//
//  SHPDevice.swift
//  health
//
//  Created by Michael Jajou on 1/18/23.
//

import Foundation

class SHPDevice {
    let sourceId: String
    let name: String
    var lastSynced: Date
    var sourceNames: Set<String>
    
    init(result: SHPQueryResult) {
        self.sourceId = result.sourceId
        self.name = result.sourceId
        self.lastSynced = result.dateTo
        self.sourceNames = [result.sourceName]
    }
    
    func toData() -> NSDictionary {
        return [
            "sourceId": sourceId,
            "sourceNames": Array(sourceNames),
            "lastSynced": lastSynced.timeIntervalSince1970
        ]
    }
}

extension Array where Element == SHPDevice {
    func groupedBySourceId() -> [SHPDevice] {
        var results: [String: SHPDevice] = [:]
        for device in self {
            if results[device.sourceId] == nil {
                results[device.sourceId] = device
            } else {
                results[device.sourceId]!.sourceNames.insert(device.name)
                let currentLastSynced = results[device.sourceId]!.lastSynced
                results[device.sourceId]!.lastSynced = Swift.max(currentLastSynced, device.lastSynced)
            }
        }
        return results.map({ $0.value })
    }
}

extension Array where Element == SHPDevice { func toData() -> [NSDictionary] { map({ $0.toData() })} }
