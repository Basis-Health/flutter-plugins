//
//  SHP+Interface.swift
//  health_plugin
//
//  Created by Michael Jajou on 1/10/23.
//

import Foundation


protocol SHPInterface {
    func checkIfHealthDataAvailable() -> Bool
    
    func getBatchData(
        types: [SHPSampleQuery],
        startTime: Date,
        endTime: Date,
        limit: Int,
        completion: @escaping ([SHPQueryResult]) -> Void
    )
    
    func getData(
        type: SHPSampleType,
        unit: SHPUnit,
        startTime: Date,
        endTime: Date,
        limit: Int,
        completion: @escaping ([SHPQueryResult]) -> Void
    )
    
    func getDevices(completion: @escaping ([SHPDevice]) -> Void)
    
    func getTotalStepsInInterval(startTime: Date, endTime: Date, completion: @escaping (Int) -> Void)

    func hasPermissions(types: [SHPSampleType], permissions: [Int]) -> Bool
    
    func requestAuthorization(
        types: [SHPSampleType],
        objectTypes: [SHPObjectType],
        permissions: [Int],
        completion: @escaping (Bool) -> Void
    )
    
    func writeAudiogram(
        frequencies: [Double],
        leftEarSensitivities: [Double],
        rightEarSensitivities: [Double],
        startTime: Date,
        endTime: Date,
        deviceName: String?,
        externalUUID: String?,
        completion: @escaping (Bool) -> Void
    )
    
    func writeData(
        value: Double,
        type: SHPSampleType,
        unit: SHPUnit,
        startTime: Date,
        endTime: Date,
        completion: @escaping (Bool) -> Void
    )
    
    func writeWorkoutData(
        activity: SHPActivityType,
        energyUnit: SHPUnit,
        distanceUnit: SHPUnit,
        totalEnergyBurned: Double?,
        totalDistance: Double?,
        startTime: Date,
        endTime: Date,
        completion: @escaping (Bool) -> Void
    )
}
