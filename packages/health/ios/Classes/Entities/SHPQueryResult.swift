//
//  SHPQueryResult.swift
//  health_plugin
//
//  Created by Michael Jajou on 1/10/23.
//

import Foundation
import HealthKit

class SHPQueryResult {
    var uuid: String
    var dateFrom: Date
    var dateTo: Date
    var sourceId: String
    var sourceName: String
    var dataType: SHPSampleType
    var timezone: String?
    
    init(
        uuid: String,
        dateFrom: Date,
        dateTo: Date,
        sourceId: String,
        sourceName: String,
        dataType: SHPSampleType,
        timezone: String? = nil
    ) {
        self.uuid = uuid
        self.dateFrom = dateFrom
        self.dateTo = dateTo
        self.sourceId = sourceId
        self.sourceName = sourceName
        self.dataType = dataType
        self.timezone = timezone
    }
    
    func toData() -> NSDictionary { [:] }
}

class SHPQuantitySample: SHPQueryResult {
    var value: Double = 0
    
    init(sample: HKQuantitySample, unit: SHPUnit, sampleType: SHPSampleType) {
        super.init(
            uuid: sample.uuid.uuidString,
            dateFrom: sample.startDate,
            dateTo: sample.endDate,
            sourceId: sample.sourceRevision.source.bundleIdentifier,
            sourceName: sample.sourceRevision.source.name,
            dataType: sampleType,
            timezone: sample.metadata?[HKMetadataKeyTimeZone] as? String
        )

        self.value = sample.quantity.doubleValue(for: unit.hkUnit)
    }
    
    override func toData() -> NSDictionary {
        return [
            "uuid": uuid,
            "value": value,
            "date_from": Int(dateFrom.timeIntervalSince1970 * 1000),
            "date_to": Int(dateTo.timeIntervalSince1970 * 1000),
            "source_id": sourceId,
            "source_name": sourceName,
            "timezone": timezone as Any
        ]
    }
}

class SHPCategorySample: SHPQueryResult {
    var value: Int = 0
    
    init(sample: HKCategorySample, unit: SHPUnit, sampleType: SHPSampleType) {
        super.init(
            uuid: sample.uuid.uuidString,
            dateFrom: sample.startDate,
            dateTo: sample.endDate,
            sourceId: sample.sourceRevision.source.bundleIdentifier,
            sourceName: sample.sourceRevision.source.name,
            dataType: sampleType,
            timezone: sample.metadata?[HKMetadataKeyTimeZone] as? String
        )
        self.value = sample.value
    }
    
    override func toData() -> NSDictionary {
        return [
            "uuid": uuid,
            "value": value,
            "date_from": Int(dateFrom.timeIntervalSince1970 * 1000),
            "date_to": Int(dateTo.timeIntervalSince1970 * 1000),
            "source_id": sourceId,
            "source_name": sourceName,
            "timezone": timezone as Any
        ]
    }
}

class SHPWorkout: SHPQueryResult {
    var workoutActivityType: SHPActivityType?
    var totalEnergyBurned: Double?
    let totalEnergyBurnedUnit = SHPUnit.KILOCALORIE
    var totalDistance: Double?
    let totalDistanceUnit = SHPUnit.METER
    
    init(sample: HKWorkout, sampleType: SHPSampleType) {
        super.init(
            uuid: sample.uuid.uuidString,
            dateFrom: sample.startDate,
            dateTo: sample.endDate,
            sourceId: sample.sourceRevision.source.bundleIdentifier,
            sourceName: sample.sourceRevision.source.name,
            dataType: sampleType,
            timezone: sample.metadata?[HKMetadataKeyTimeZone] as? String
        )
        self.workoutActivityType = SHPActivityType.allCases.first(
            where: { $0.activity == sample.workoutActivityType }
        )
        self.totalEnergyBurned = sample.totalEnergyBurned?.doubleValue(for: .kilocalorie())
        self.totalDistance = sample.totalDistance?.doubleValue(for: .meter())
    }
    
    override func toData() -> NSDictionary {
        return [
            "uuid": uuid,
            "workoutActivityType": workoutActivityType?.rawValue as Any,
            "totalEnergyBurned": totalEnergyBurned as Any,
            "totalEnergyBurnedUnit": totalEnergyBurnedUnit.rawValue,
            "totalDistance": totalDistance as Any,
            "totalDistanceUnit": totalDistanceUnit.rawValue,
            "date_from": Int(dateFrom.timeIntervalSince1970 * 1000),
            "date_to": Int(dateTo.timeIntervalSince1970 * 1000),
            "source_id": sourceId,
            "source_name": sourceName,
            "timezone": timezone as Any
        ]
    }
}

class SHPAudiogramSample: SHPQueryResult {
    var frequencies: [Double] = []
    var leftEarSensitivities: [Double] = []
    var rightEarSensitivities: [Double] = []
    
    init(sample: HKAudiogramSample, sampleType: SHPSampleType) {
        super.init(
            uuid: sample.uuid.uuidString,
            dateFrom: sample.startDate,
            dateTo: sample.endDate,
            sourceId: sample.sourceRevision.source.bundleIdentifier,
            sourceName: sample.sourceRevision.source.name,
            dataType: sampleType,
            timezone: sample.metadata?[HKMetadataKeyTimeZone] as? String
        )
        self.frequencies = sample.sensitivityPoints.map({
            $0.frequency.doubleValue(for: .hertz())
        })
        self.leftEarSensitivities = sample.sensitivityPoints.compactMap({
            $0.leftEarSensitivity?.doubleValue(for: .hertz())
        })
        self.rightEarSensitivities = sample.sensitivityPoints.compactMap({
            $0.rightEarSensitivity?.doubleValue(for: .hertz())
        })
    }
    
    override func toData() -> NSDictionary {
        return [
            "uuid": uuid,
            "frequencies": frequencies,
            "leftEarSensitivities": leftEarSensitivities,
            "rightEarSensitivities": rightEarSensitivities,
            "date_from": Int(dateFrom.timeIntervalSince1970 * 1000),
            "date_to": Int(dateTo.timeIntervalSince1970 * 1000),
            "source_id": sourceId,
            "source_name": sourceName,
            "timezone": timezone as Any
        ]
    }
}

extension Array where Element == SHPQueryResult {
    func groupedBySampleType() -> [SHPSampleType: [SHPQueryResult]] {
        return Dictionary(grouping: self, by: { $0.dataType })
    }
    
    func groupedBySampleTypeData() -> [NSDictionary] {
        return groupedBySampleType().map({ ["dataType": $0.key.rawValue, "dataPoints": $0.value.map({ $0.toData() })] })
    }
}
