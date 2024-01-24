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
    case DIETARY_ENERGY
    case DIETARY_CARBS
    case DIETARY_FIBER
    case DIETARY_SUGAR
    case DIETARY_FAT
    case DIETARY_FAT_MONOUNSATURATED
    case DIETARY_FAT_POLYUNSATURATED
    case DIETARY_FAT_SATURATED
    case DIETARY_CHOLESTEROL
    case DIETARY_PROTEIN
    case DIETARY_VITAMIN_A
    case DIETARY_THIAMIN
    case DIETARY_RIBOFLAVIN
    case DIETARY_NIACIN
    case DIETARY_PANTOTHENIC_ACID
    case DIETARY_VITAMIN_B6
    case DIETARY_BIOTIN
    case DIETARY_VITAMIN_B12
    case DIETARY_VITAMIN_C
    case DIETARY_VITAMIN_D
    case DIETARY_VITAMIN_E
    case DIETARY_VITAMIN_K
    case DIETARY_FOLATE
    case DIETARY_CALCIUM
    case DIETARY_CHLORIDE
    case DIETARY_IRON
    case DIETARY_MAGNESIUM
    case DIETARY_PHOSPHORUS
    case DIETARY_POTASSIUM
    case DIETARY_SODIUM
    case DIETARY_ZINC
    case DIETARY_WATER
    case DIETARY_CAFFEINE
    case DIETARY_CHROMIUM
    case DIETARY_COPPER
    case DIETARY_IODINE
    case DIETARY_MANGANESE
    case DIETARY_MOLYBDENUM
    case DIETARY_SELENIUM
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
        case .DIETARY_ENERGY:
            return .quantityType(forIdentifier: .dietaryEnergyConsumed)
        case .DIETARY_CARBS:
            return .quantityType(forIdentifier: .dietaryCarbohydrates)
        case .DIETARY_FIBER:
            return .quantityType(forIdentifier: .dietaryFiber)
        case .DIETARY_SUGAR:
            return .quantityType(forIdentifier: .dietarySugar)
        case .DIETARY_FAT:
            return .quantityType(forIdentifier: .dietaryFatTotal)
        case .DIETARY_FAT_MONOUNSATURATED:
            return .quantityType(forIdentifier: .dietaryFatMonounsaturated)
        case .DIETARY_FAT_POLYUNSATURATED:
            return .quantityType(forIdentifier: .dietaryFatPolyunsaturated)
        case .DIETARY_FAT_SATURATED:
            return .quantityType(forIdentifier: .dietaryFatSaturated)
        case .DIETARY_CHOLESTEROL:
            return .quantityType(forIdentifier: .dietaryCholesterol)
        case .DIETARY_PROTEIN:
            return .quantityType(forIdentifier: .dietaryProtein)
        case .DIETARY_VITAMIN_A:
            return .quantityType(forIdentifier: .dietaryVitaminA)
        case .DIETARY_THIAMIN:
            return .quantityType(forIdentifier: .dietaryThiamin)
        case .DIETARY_RIBOFLAVIN:
            return .quantityType(forIdentifier: .dietaryRiboflavin)
        case .DIETARY_NIACIN:
            return .quantityType(forIdentifier: .dietaryNiacin)
        case .DIETARY_PANTOTHENIC_ACID:
            return .quantityType(forIdentifier: .dietaryPantothenicAcid)
        case .DIETARY_VITAMIN_B6:
            return .quantityType(forIdentifier: .dietaryVitaminB6)
        case .DIETARY_BIOTIN:
            return .quantityType(forIdentifier: .dietaryBiotin)
        case .DIETARY_VITAMIN_B12:
            return .quantityType(forIdentifier: .dietaryVitaminB12)
        case .DIETARY_VITAMIN_C:
            return .quantityType(forIdentifier: .dietaryVitaminC)
        case .DIETARY_VITAMIN_D:
            return .quantityType(forIdentifier: .dietaryVitaminD)
        case .DIETARY_VITAMIN_E:
            return .quantityType(forIdentifier: .dietaryVitaminE)
        case .DIETARY_VITAMIN_K:
            return .quantityType(forIdentifier: .dietaryVitaminK)
        case .DIETARY_FOLATE:
            return .quantityType(forIdentifier: .dietaryFolate)
        case .DIETARY_CALCIUM:
            return .quantityType(forIdentifier: .dietaryCalcium)
        case .DIETARY_CHLORIDE:
            return .quantityType(forIdentifier: .dietaryChloride)
        case .DIETARY_IRON:
            return .quantityType(forIdentifier: .dietaryIron)
        case .DIETARY_MAGNESIUM:
            return .quantityType(forIdentifier: .dietaryMagnesium)
        case .DIETARY_PHOSPHORUS:
            return .quantityType(forIdentifier: .dietaryPhosphorus)
        case .DIETARY_POTASSIUM:
            return .quantityType(forIdentifier: .dietaryPotassium)
        case .DIETARY_SODIUM:
            return .quantityType(forIdentifier: .dietarySodium)
        case .DIETARY_ZINC:
            return .quantityType(forIdentifier: .dietaryZinc)
        case .DIETARY_WATER:
            return .quantityType(forIdentifier: .dietaryWater)
        case .DIETARY_CAFFEINE:
            return .quantityType(forIdentifier: .dietaryCaffeine)
        case .DIETARY_CHROMIUM:
            return .quantityType(forIdentifier: .dietaryChromium)
        case .DIETARY_COPPER:
            return .quantityType(forIdentifier: .dietaryCopper)
        case .DIETARY_IODINE:
            return .quantityType(forIdentifier: .dietaryIodine)
        case .DIETARY_MANGANESE:
            return .quantityType(forIdentifier: .dietaryManganese)
        case .DIETARY_MOLYBDENUM:
            return .quantityType(forIdentifier: .dietaryMolybdenum)
        case .DIETARY_SELENIUM:
            return .quantityType(forIdentifier: .dietarySelenium)
        case .MINDFULNESS:
            return .categoryType(forIdentifier: .mindfulSession)
        case .SLEEP:
            return .categoryType(forIdentifier: .sleepAnalysis)
        case .EXERCISE_TIME:
            return .quantityType(forIdentifier: .appleExerciseTime)
        case .WORKOUT:
            return .workoutType()
        case .UNKNOWN:
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
        case .DIETARY_ENERGY:
            return .KILOCALORIE
        case .DIETARY_CARBS:
            return .GRAM
        case .DIETARY_FIBER:
            return .GRAM
        case .DIETARY_SUGAR:
            return .GRAM
        case .DIETARY_FAT:
            return .GRAM
        case .DIETARY_FAT_MONOUNSATURATED:
            return .GRAM
        case .DIETARY_FAT_POLYUNSATURATED:
            return .GRAM
        case .DIETARY_FAT_SATURATED:
            return .GRAM
        case .DIETARY_CHOLESTEROL:
            return .MILLIGRAM
        case .DIETARY_PROTEIN:
            return .GRAM
        case .DIETARY_VITAMIN_A:
            return .MICROGRAM
        case .DIETARY_THIAMIN:
            return .MILLIGRAM
        case .DIETARY_RIBOFLAVIN:
            return .MILLIGRAM
        case .DIETARY_NIACIN:
            return .MILLIGRAM
        case .DIETARY_PANTOTHENIC_ACID:
            return .MILLIGRAM
        case .DIETARY_VITAMIN_B6:
            return .MILLIGRAM
        case .DIETARY_BIOTIN:
            return .MICROGRAM
        case .DIETARY_VITAMIN_B12:
            return .MICROGRAM
        case .DIETARY_VITAMIN_C:
            return .MILLIGRAM
        case .DIETARY_VITAMIN_D:
            return .MICROGRAM
        case .DIETARY_VITAMIN_E:
            return .MILLIGRAM
        case .DIETARY_VITAMIN_K:
            return .MICROGRAM
        case .DIETARY_FOLATE:
            return .MICROGRAM
        case .DIETARY_CALCIUM:
            return .MILLIGRAM
        case .DIETARY_CHLORIDE:
            return .MILLIGRAM
        case .DIETARY_IRON:
            return .MILLIGRAM
        case .DIETARY_MAGNESIUM:
            return .MILLIGRAM
        case .DIETARY_PHOSPHORUS:
            return .MILLIGRAM
        case .DIETARY_POTASSIUM:
            return .MILLIGRAM
        case .DIETARY_SODIUM:
            return .MILLIGRAM
        case .DIETARY_ZINC:
            return .MILLIGRAM
        case .DIETARY_WATER:
            return .MILLILITER
        case .DIETARY_CAFFEINE:
            return .MILLIGRAM
        case .DIETARY_CHROMIUM:
            return .MICROGRAM
        case .DIETARY_COPPER:
            return .MILLIGRAM
        case .DIETARY_IODINE:
            return .MICROGRAM
        case .DIETARY_MANGANESE:
            return .MILLIGRAM
        case .DIETARY_MOLYBDENUM:
            return .MICROGRAM
        case .DIETARY_SELENIUM:
            return .MICROGRAM
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
