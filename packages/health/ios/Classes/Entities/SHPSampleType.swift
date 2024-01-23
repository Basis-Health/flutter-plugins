//
//  SHP+SampleType.swift
//  health_plugin
//
//  Created by Michael Jajou on 1/10/23.
//

import Foundation
import HealthKit

enum SHPObjectType: String, CaseIterable, Codable {
    case DATE_OF_BIRTH
    case GENDER

    var objectType: HKObjectType {
        switch (self) {
        case .DATE_OF_BIRTH:
            return .characteristicType(forIdentifier: .dateOfBirth)!
        case .GENDER:
            return .characteristicType(forIdentifier: .biologicalSex)!
        }
    }
}

enum SHPSampleType: String, CaseIterable, Codable {
    case ACTIVE_ENERGY_BURNED
    case AUDIOGRAM
    case BASAL_ENERGY_BURNED
    case BLOOD_GLUCOSE
    case BLOOD_OXYGEN
    case BLOOD_PRESSURE_DIASTOLIC
    case BLOOD_PRESSURE_SYSTOLIC
    case BODY_FAT_PERCENTAGE
    case BODY_MASS_INDEX
    case BODY_TEMPERATURE
    case DIETARY_CARBS_CONSUMED
    case DIETARY_ENERGY_CONSUMED
    case DIETARY_FATS_CONSUMED
    case DIETARY_PROTEIN_CONSUMED
    case ELECTRODERMAL_ACTIVITY
    case FORCED_EXPIRATORY_VOLUME
    case HEART_RATE
    case HEART_RATE_VARIABILITY_SDNN
    case HEIGHT
    case HIGH_HEART_RATE_EVENT
    case IRREGULAR_HEART_RATE_EVENT
    case LOW_HEART_RATE_EVENT
    case RESTING_HEART_RATE
    case STEPS
    case WAIST_CIRCUMFERENCE
    case WALKING_HEART_RATE
    case WEIGHT
    case DISTANCE_WALKING_RUNNING
    case FLIGHTS_CLIMBED
    case WATER
    case MINDFULNESS
    case SLEEP
    case EXERCISE_TIME
    case WORKOUT
    case HEADACHE
    case VO2MAX
    case UNKNOWN
    
    var sampleType: HKSampleType? {
        switch self {
        case .ACTIVE_ENERGY_BURNED:
            return .quantityType(forIdentifier: .activeEnergyBurned)
        case .AUDIOGRAM:
            return .audiogramSampleType()
        case .BASAL_ENERGY_BURNED:
            return .quantityType(forIdentifier: .basalEnergyBurned)
        case .VO2MAX:
            return .quantityType(forIdentifier: .vo2Max)
        case .BLOOD_GLUCOSE:
            return .quantityType(forIdentifier: .bloodGlucose)
        case .BLOOD_OXYGEN:
            return .quantityType(forIdentifier: .oxygenSaturation)
        case .BLOOD_PRESSURE_DIASTOLIC:
            return .quantityType(forIdentifier: .bloodPressureDiastolic)
        case .BLOOD_PRESSURE_SYSTOLIC:
            return .quantityType(forIdentifier: .bloodPressureSystolic)
        case .BODY_FAT_PERCENTAGE:
            return .quantityType(forIdentifier: .bodyFatPercentage)
        case .BODY_MASS_INDEX:
            return .quantityType(forIdentifier: .bodyMassIndex)
        case .BODY_TEMPERATURE:
            return .quantityType(forIdentifier: .bodyTemperature)
        case .DIETARY_CARBS_CONSUMED:
            return .quantityType(forIdentifier: .dietaryCarbohydrates)
        case .DIETARY_ENERGY_CONSUMED:
            return .quantityType(forIdentifier: .dietaryEnergyConsumed)
        case .DIETARY_FATS_CONSUMED:
            return .quantityType(forIdentifier: .dietaryFatTotal)
        case .DIETARY_PROTEIN_CONSUMED:
            return .quantityType(forIdentifier: .dietaryProtein)
        case .ELECTRODERMAL_ACTIVITY:
            return .quantityType(forIdentifier: .electrodermalActivity)
        case .FORCED_EXPIRATORY_VOLUME:
            return .quantityType(forIdentifier: .forcedExpiratoryVolume1)
        case .HEART_RATE:
            return .quantityType(forIdentifier: .heartRate)
        case .HIGH_HEART_RATE_EVENT:
            return .categoryType(forIdentifier: .highHeartRateEvent)
        case .LOW_HEART_RATE_EVENT:
            return .categoryType(forIdentifier: .lowHeartRateEvent)
        case .IRREGULAR_HEART_RATE_EVENT:
            return .categoryType(forIdentifier: .irregularHeartRhythmEvent)
        case .HEART_RATE_VARIABILITY_SDNN:
            return .quantityType(forIdentifier: .heartRateVariabilitySDNN)
        case .HEIGHT:
            return .quantityType(forIdentifier: .height)
        case .HEADACHE:
            if #available(iOS 13.6, *) {
                return .categoryType(forIdentifier: .headache)
            } else {
                return nil
            }
        case .RESTING_HEART_RATE:
            return .quantityType(forIdentifier: .restingHeartRate)
        case .STEPS:
            return .quantityType(forIdentifier: .stepCount)
        case .WAIST_CIRCUMFERENCE:
            return .quantityType(forIdentifier: .waistCircumference)
        case .WALKING_HEART_RATE:
            return .quantityType(forIdentifier: .walkingHeartRateAverage)
        case .WEIGHT:
            return .quantityType(forIdentifier: .bodyMass)
        case .DISTANCE_WALKING_RUNNING:
            return .quantityType(forIdentifier: .distanceWalkingRunning)
        case .FLIGHTS_CLIMBED:
            return .quantityType(forIdentifier: .flightsClimbed)
        case .WATER:
            return .quantityType(forIdentifier: .dietaryWater)
        case .MINDFULNESS:
            return .categoryType(forIdentifier: .mindfulSession)
        case .SLEEP:
            return .categoryType(forIdentifier: .sleepAnalysis)
        case .EXERCISE_TIME:
            return .quantityType(forIdentifier: .appleExerciseTime)
        case .WORKOUT:
            return .workoutType()
        default:
            return nil
        }
    }
    
    var unit: SHPUnit {
        switch self {
        case .ACTIVE_ENERGY_BURNED:
            return .KILOCALORIE
        case .AUDIOGRAM:
            return .DECIBEL_HEARING_LEVEL
        case .BASAL_ENERGY_BURNED:
            return .KILOCALORIE
        case .VO2MAX:
            return .MILLILITER_PER_KILOGRAM_PER_MINUTE
        case .BLOOD_GLUCOSE:
            return .MILLIGRAM_PER_DECILITER
        case .BLOOD_OXYGEN:
            return .PERCENT
        case .BLOOD_PRESSURE_DIASTOLIC:
            return .MILLIMETER_OF_MERCURY
        case .BLOOD_PRESSURE_SYSTOLIC:
            return .MILLIMETER_OF_MERCURY
        case .BODY_FAT_PERCENTAGE:
            return .PERCENT
        case .BODY_TEMPERATURE:
            return .DEGREE_CELSIUS
        case .DIETARY_CARBS_CONSUMED:
            return .GRAM
        case .DIETARY_ENERGY_CONSUMED:
            return .KILOCALORIE
        case .DIETARY_FATS_CONSUMED:
            return .GRAM
        case .DIETARY_PROTEIN_CONSUMED:
            return .GRAM
        case .ELECTRODERMAL_ACTIVITY:
            return .SIEMEN
        case .FORCED_EXPIRATORY_VOLUME:
            return .LITER
        case .HEART_RATE:
            return .BEATS_PER_MINUTE
        case .RESTING_HEART_RATE:
            return .BEATS_PER_MINUTE
        case .STEPS:
            return .COUNT
        case .WAIST_CIRCUMFERENCE:
            return .METER
        case .WALKING_HEART_RATE:
            return .BEATS_PER_MINUTE
        case .WEIGHT:
            return .KILOGRAM
        case .DISTANCE_WALKING_RUNNING:
            return .METER
        case .FLIGHTS_CLIMBED:
            return .COUNT
        case .WATER:
            return .LITER
        case .HEART_RATE_VARIABILITY_SDNN:
            return .MILLISECOND
        case .HEADACHE:
            return .HEADACHE
        case .HEIGHT:
            return .METER
        default:
            return .NO_UNIT
            
        }
    }
    
    static func fromHKType( _ type: HKSampleType) -> SHPSampleType {
        return SHPSampleType.allCases.first(where: { $0.sampleType == type }) ?? .UNKNOWN
    }
}
