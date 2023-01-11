//
//  SHPRepository.swift
//  health_plugin
//
//  Created by Michael Jajou on 1/10/23.
//

import Foundation
import HealthKit

class SHPRepository: SHPInterface {
    private let store = HKHealthStore()
    
    func checkIfHealthDataAvailable() -> Bool {
        return HKHealthStore.isHealthDataAvailable()
    }
    
    func getData(
        type: SHPSampleType,
        unit: SHPUnit,
        startTime: Date,
        endTime: Date,
        limit: Int,
        completion: @escaping ([SHPQueryResult]) -> Void
    ) {
        let predicate = HKQuery.predicateForSamples(
            withStart: startTime,
            end: endTime,
            options: .strictStartDate
        )
        let sortDescriptor = NSSortDescriptor(
            key: HKSampleSortIdentifierEndDate,
            ascending: false
        )
        
        let query = HKSampleQuery(
            sampleType: type.sampleType!,
            predicate: predicate,
            limit: limit,
            sortDescriptors: [sortDescriptor]
        ) { x, samplesOrNil, error in
            let samples = self.processSamples(samplesOrNil ?? [], unit: unit)
            completion(samples)
        }

        store.execute(query)
    }
    
    private func processSamples(_ samples: [HKSample], unit: SHPUnit) -> [SHPQueryResult] {
        switch samples {
        case let (samples as [HKQuantitySample]) as Any:
            return samples.map { SHPQuantitySample(sample: $0, unit: unit) }
        case let (samplesCategory as [HKCategorySample]) as Any:
            return samplesCategory.map { SHPCategorySample(sample: $0, unit: unit) }
        case let (samplesWorkout as [HKWorkout]) as Any:
            return samplesWorkout.map { SHPWorkout(sample: $0) }
        case let (samplesAudiogram as [HKAudiogramSample]) as Any:
            return samplesAudiogram.map { SHPAudiogramSample(sample: $0) }
        default:
            return []
        }
    }
    
    func getTotalStepsInInterval(
        startTime: Date,
        endTime: Date,
        completion: @escaping (Int) -> Void
    ) {
        let sampleType = HKQuantityType.quantityType(forIdentifier: .stepCount)!
        let predicate = HKQuery.predicateForSamples(
            withStart: startTime,
            end: endTime,
            options: .strictStartDate
        )
        let query = HKStatisticsQuery(
            quantityType: sampleType,
            quantitySamplePredicate: predicate,
            options: .cumulativeSum
        ) { query, queryResult, error in
            guard let queryResult = queryResult else {
                let error = error! as NSError
                print("Error getting total steps in interval \(error.localizedDescription)")
                completion(0)
                return
            }
            
            var steps = 0.0
            if let quantity = queryResult.sumQuantity() {
                let unit = HKUnit.count()
                steps = quantity.doubleValue(for: unit)
            }
            
            let totalSteps = Int(steps)
            completion(totalSteps)
        }
        
        store.execute(query)
    }
    
    func hasPermissions(types: [SHPSampleType], permissions: [Int]) -> Bool {
        for (index, type) in types.enumerated() {
            if !hasPermission(type: type, access: permissions[index]) {
                return false
            }
        }
        
        return true
    }
    
    private func hasPermission(type: SHPSampleType, access: Int) -> Bool {
        guard let sampleType = type.sampleType else { return false }
        let status = store.authorizationStatus(for: sampleType)
        switch access {
        case 0:
            return false
        case 1:
            return status == HKAuthorizationStatus.sharingAuthorized
        default:
            return false
        }
    }
    
    func requestAuthorization(
        types: [SHPSampleType],
        permissions: [Int],
        completion: @escaping (Bool) -> Void
    ) {
        var read = Set<HKSampleType>()
        var write = Set<HKSampleType>()
        for (index, type) in types.enumerated() {
            if let sampleType = type.sampleType {
                let access = permissions[index]
                switch access {
                case 0:
                    read.insert(sampleType)
                case 1:
                    write.insert(sampleType)
                default:
                    read.insert(sampleType)
                    write.insert(sampleType)
                }
            }
        }
        store.requestAuthorization(toShare: write, read: read) { (success, _) in
            completion(success)
        }
    }
    
    func writeAudiogram(
        frequencies: [Double],
        leftEarSensitivities: [Double],
        rightEarSensitivities: [Double],
        startTime: Date,
        endTime: Date,
        deviceName: String?,
        externalUUID: String?,
        completion: @escaping (Bool) -> Void
    ) {
        var sensitivityPoints = [HKAudiogramSensitivityPoint]()
        for index in 0...frequencies.count-1 {
            let frequency = HKQuantity(
                unit: HKUnit.hertz(),
                doubleValue: frequencies[index]
            )
            let dbUnit = HKUnit.decibelHearingLevel()
            let left = HKQuantity(unit: dbUnit, doubleValue: leftEarSensitivities[index])
            let right = HKQuantity(unit: dbUnit, doubleValue: rightEarSensitivities[index])
            if let sensitivityPoint = try? HKAudiogramSensitivityPoint(
                frequency: frequency,
                leftEarSensitivity: left,
                rightEarSensitivity: right
            ) {
                sensitivityPoints.append(sensitivityPoint)
            }
        }
        
        let audiogram: HKAudiogramSample
        if let deviceName = deviceName, let externalUUID = externalUUID {
            audiogram = HKAudiogramSample(
                sensitivityPoints: sensitivityPoints,
                start: startTime,
                end: endTime,
                metadata: [
                    HKMetadataKeyDeviceName: deviceName,
                    HKMetadataKeyExternalUUID: externalUUID
                ]
            )
            
        } else {
            audiogram = HKAudiogramSample(
                sensitivityPoints: sensitivityPoints,
                start: startTime,
                end: endTime,
                metadata: nil
            )
        }
        
        store.save(audiogram, withCompletion: { (success, error) in
            if let err = error {
                print("Error Saving Audiogram. Sample: \(err.localizedDescription)")
            }
            completion(success)
        })
    }
    
    func writeData(
        value: Double,
        type: SHPSampleType,
        unit: SHPUnit,
        startTime: Date,
        endTime: Date,
        completion: @escaping (Bool) -> Void
    ) {
        let sample: HKObject
        if (unit.hkUnit == HKUnit.init(from: "")) {
            sample = HKCategorySample(
                type: type.sampleType as! HKCategoryType,
                value: Int(value),
                start: startTime,
                end: endTime
            )
        } else {
            let quantity = HKQuantity(unit: unit.hkUnit, doubleValue: value)
            sample = HKQuantitySample(
                type: type.sampleType as! HKQuantityType,
                quantity: quantity,
                start: startTime,
                end: endTime
            )
        }
        
        store.save(sample, withCompletion: { (success, error) in
            if let err = error {
                print("Error Saving \(type) Sample: \(err.localizedDescription)")
            }
            completion(success)
        })
    }
    
    func writeWorkoutData(
        activity: SHPActivityType,
        energyUnit: SHPUnit,
        distanceUnit: SHPUnit,
        totalEnergyBurned: Double?,
        totalDistance: Double?,
        startTime: Date,
        endTime: Date,
        completion: @escaping (Bool) -> Void
    ) {
        guard let hkActivity = activity.activity else { completion(false); return }
        var energyBurnedQuantity: HKQuantity?
        var distanceQuantity: HKQuantity? = nil
        if let totalEnergyBurned = totalEnergyBurned {
            energyBurnedQuantity = HKQuantity(
                unit: energyUnit.hkUnit,
                doubleValue: totalEnergyBurned
            )
        }
        if let totalDistance = totalDistance {
            distanceQuantity = HKQuantity(
                unit: distanceUnit.hkUnit,
                doubleValue: totalDistance
            )
        }
        
        let workout = HKWorkout(
            activityType: hkActivity,
            start: startTime,
            end: endTime,
            duration: endTime.timeIntervalSince(startTime),
            totalEnergyBurned: energyBurnedQuantity ?? nil,
            totalDistance: distanceQuantity ?? nil,
            metadata: nil
        )
        
        store.save(workout, withCompletion: { (success, error) in
            if let err = error {
                print("Error Saving Workout. Sample: \(err.localizedDescription)")
            }
            completion(success)
        })
    }
}