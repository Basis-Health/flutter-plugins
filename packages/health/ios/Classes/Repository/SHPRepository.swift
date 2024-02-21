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

    func getDateOfBirth(completion: @escaping (Date?) -> Void) {
        let type = HKObjectType.characteristicType(forIdentifier: .dateOfBirth)!
        store.requestAuthorization(toShare: nil, read: [type]) { (success, _) in
            if success {
                do {
                    let dateOfBirth = try self.store.dateOfBirthComponents()
                    let calendar = Calendar.current
                    let date = calendar.date(from: dateOfBirth)
                    completion(date)
                } catch {
                    completion(nil)
                }
            } else {
                completion(nil)
            }
        }
    }

    func getBiologicalGender(completion: @escaping (String) -> Void) {
        let type = HKObjectType.characteristicType(forIdentifier: .biologicalSex)!
        store.requestAuthorization(toShare: nil, read: [type]) { (success, _) in
            if success {
                do {
                    let biologicalSex = try self.store.biologicalSex().biologicalSex
                    var genderString = "unknown"

                    switch biologicalSex {
                    case .male:
                        genderString = "male"
                    case .female:
                        genderString = "female"
                    case .other:
                        genderString = "other"
                    default:
                        break
                    }

                    completion(genderString)
                } catch {
                    completion("unknown")
                }
            } else {
                completion("unknown")
            }
        }
    }

    func getBatchData(
        types: [SHPSampleQuery],
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
        if #available(iOS 15.0, *) {
            getBatchQueryUsingDescriptors(
                sampleTypes: types.valid(),
                limit: limit,
                predicate: predicate,
                sortDescriptors: [sortDescriptor],
                completion: completion
            )
        } else {
            getBatchQueryUsingQueues(
                sampleTypes: types.valid(),
                limit: limit,
                startTime: startTime,
                endTime: endTime,
                completion: completion
            )
        }
    }

    //@available(iOS 15.0, *)
    func getBatchQueryUsingAnchor(
        sampleType: SHPSampleQuery,
        limit: Int,
        predicate: NSPredicate?,
        sortDescriptors: [NSSortDescriptor],
        anchorString: String?,
        completion: @escaping (SHPAnchorQueryResult, Error?) -> Void
    ) {
        // check if type is nil
        let emptyResult = SHPAnchorQueryResult(anchor: nil, sampleType: sampleType.type, newSamples: [], deletedSamples: [])
        guard let type = sampleType.type.sampleType else {
            completion(emptyResult, nil)
            return
        }

        // Decode the anchor from the Base64 encoded string
        let anchorData = anchorString != nil ? Data(base64Encoded: anchorString!) : nil
        let anchor = anchorData != nil ? (try? NSKeyedUnarchiver.unarchivedObject(ofClasses: [HKQueryAnchor.self], from: anchorData!)) as? HKQueryAnchor : nil
        
        let anchoredQuery = HKAnchoredObjectQuery(
            type: type ,
            predicate: predicate,
            anchor: anchor,
            limit: limit
        ) { query, newSamplesOrNil, deletedSamplesOrNil, newAnchor, error in
            if let error = error {
                completion(emptyResult, error)
            }

            // Process the new samples and handle the new anchor
            let newSamples = self.process(healthSamples: newSamplesOrNil ?? [], sampleUnits: [sampleType])
            let deletedSamples = deletedSamplesOrNil?.map({ $0.uuid.uuidString }) ?? []
            let newAnchorString = newAnchor != nil ? (try? NSKeyedArchiver.archivedData(withRootObject: newAnchor, requiringSecureCoding: true))?.base64EncodedString() : nil
            completion(SHPAnchorQueryResult(
                anchor: newAnchorString,
                sampleType: sampleType.type,
                newSamples: newSamples,
                deletedSamples: deletedSamples
            ), nil)
        }
        
        // Execute each query
        store.execute(anchoredQuery)
    }
    
    @available(iOS 15.0, *)
    private func getBatchQueryUsingDescriptors(
        sampleTypes: [SHPSampleQuery],
        limit: Int,
        predicate: NSPredicate,
        sortDescriptors: [NSSortDescriptor],
        completion: @escaping ([SHPQueryResult]) -> Void
    ) {
        let descriptors = sampleTypes
            .compactMap({ $0.type.sampleType })
            .map({ HKQueryDescriptor(sampleType: $0, predicate: predicate) })
        let query = HKSampleQuery(
            queryDescriptors: Array(Set(descriptors)),
            limit: limit,
            sortDescriptors: sortDescriptors
        ) { query, samplesOrNil, _ in
            let samples = self.process(healthSamples: samplesOrNil ?? [], sampleUnits: sampleTypes)
            completion(samples)
        }
        
        store.execute(query)
    }
    
    private func getBatchQueryUsingQueues(
        sampleTypes: [SHPSampleQuery],
        limit: Int,
        startTime: Date,
        endTime: Date,
        completion: @escaping ([SHPQueryResult]) -> Void
    ) {
        let group = DispatchGroup()
        var results: [SHPQueryResult] = []
        for type in sampleTypes {
            group.enter()
            getData(type: type.type, unit: type.unit, startTime: startTime, endTime: endTime, limit: limit) { samples in
                results.append(contentsOf: samples)
                group.leave()
            }
        }
        
        group.notify(queue: .main) { completion(results) }
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
            let samples = self.process(
                healthSamples: samplesOrNil ?? [],
                sampleUnits: [SHPSampleQuery(type: type, unit: unit)]
            )
            completion(samples)
        }
        store.execute(query)
    }
    
    func getDevices(completion: @escaping ([SHPDevice]) -> Void) {
        getBatchData(
            types: SHPSampleType.allCases.map({ SHPSampleQuery.fromType($0) }).valid(),
            startTime: Date().addingTimeInterval(86400 * -100),
            endTime: Date(),
            limit: HKObjectQueryNoLimit
        ) { results in
            let devices = results.map({ SHPDevice(result: $0) })
            completion(devices.groupedBySourceId())
        }
    }
    
    private func process(
        healthSamples: [HKSample],
        sampleUnits: [SHPSampleQuery]
    ) -> [SHPQueryResult] {
        return healthSamples.compactMap({ sample in
            switch sample {
            case let (sample as HKQuantitySample) as Any:
                return SHPQuantitySample(
                    sample: sample,
                    unit: sampleUnits.unitForType(sample.sampleType),
                    sampleType: SHPSampleType.fromHKType(sample.sampleType)
                )
            case let (sample as HKCategorySample) as Any:
                return SHPCategorySample(
                    sample: sample,
                    unit: sampleUnits.unitForType(sample.sampleType),
                    sampleType: SHPSampleType.fromHKType(sample.sampleType)
                )
            case let (sample as HKWorkout) as Any:
                return SHPWorkout(sample: sample, sampleType: SHPSampleType.fromHKType(sample.sampleType))
            case let (sample as HKAudiogramSample) as Any:
                return SHPAudiogramSample(sample: sample, sampleType: SHPSampleType.fromHKType(sample.sampleType))
            default: return nil
            }
        })
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
        objectTypes: [SHPObjectType],
        permissions: [Int],
        completion: @escaping (Bool) -> Void
    ) {
        var read = Set<HKObjectType>()
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
        for type in objectTypes {
            read.insert(type.objectType)
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
