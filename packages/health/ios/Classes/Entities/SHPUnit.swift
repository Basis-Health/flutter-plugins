//
//  SHPUnit.swift
//  health_plugin
//
//  Created by Michael Jajou on 1/10/23.
//

import Foundation
import HealthKit

enum SHPUnit: String {
    case GRAM
    case KILOGRAM
    case OUNCE
    case POUND
    case STONE
    case METER
    case INCH
    case FOOT
    case YARD
    case MILE
    case LITER
    case MILLILITER
    case FLUID_OUNCE_US
    case FLUID_OUNCE_IMPERIAL
    case CUP_US
    case CUP_IMPERIAL
    case PINT_US
    case PINT_IMPERIAL
    case PASCAL
    case MILLIMETER_OF_MERCURY
    case INCHES_OF_MERCURY
    case CENTIMETER_OF_WATER
    case ATMOSPHERE
    case DECIBEL_A_WEIGHTED_SOUND_PRESSURE_LEVEL
    case SECOND
    case MILLISECOND
    case MINUTE
    case HOUR
    case DAY
    case JOULE
    case KILOCALORIE
    case LARGE_CALORIE
    case SMALL_CALORIE
    case DEGREE_CELSIUS
    case DEGREE_FAHRENHEIT
    case KELVIN
    case DECIBEL_HEARING_LEVEL
    case HERTZ
    case SIEMEN
    case VOLT
    case INTERNATIONAL_UNIT
    case COUNT
    case PERCENT
    case BEATS_PER_MINUTE
    case MILLIGRAM_PER_DECILITER
    case UNKNOWN_UNIT
    case NO_UNIT
    
    var hkUnit: HKUnit {
        switch self {
        case .ATMOSPHERE:
            return HKUnit.atmosphere()
        case .GRAM:
            return HKUnit.gram()
        case .KILOGRAM:
            return HKUnit.gramUnit(with: .kilo)
        case .OUNCE:
            return .ounce()
        case .POUND:
            return .pound()
        case .STONE:
            return .stone()
        case .METER:
            return .meter()
        case .INCH:
            return .inch()
        case .FOOT:
            return .foot()
        case .YARD:
            return .yard()
        case .MILE:
            return .mile()
        case .LITER:
            return .liter()
        case .MILLILITER:
            return .literUnit(with: .milli)
        case .FLUID_OUNCE_US:
            return .fluidOunceUS()
        case .FLUID_OUNCE_IMPERIAL:
            return .fluidOunceImperial()
        case .CUP_US:
            return .cupUS()
        case .CUP_IMPERIAL:
            return .cupImperial()
        case .PINT_US:
            return .pintUS()
        case .PINT_IMPERIAL:
            return .pintImperial()
        case .PASCAL:
            return .pascal()
        case .MILLIMETER_OF_MERCURY:
            return .millimeterOfMercury()
        case .INCHES_OF_MERCURY:
            if #available(iOS 14.0, *) {
                return .inchesOfMercury()
            } else {
                return HKUnit.init(from: "")
            }
        case .CENTIMETER_OF_WATER:
            return .centimeterOfWater()
        case .DECIBEL_A_WEIGHTED_SOUND_PRESSURE_LEVEL:
            return .decibelAWeightedSoundPressureLevel()
        case .SECOND:
            return .second()
        case .MILLISECOND:
            return .secondUnit(with: .milli)
        case .MINUTE:
            return .minute()
        case .HOUR:
            return .hour()
        case .DAY:
            return .day()
        case .JOULE:
            return .joule()
        case .KILOCALORIE:
            return .kilocalorie()
        case .LARGE_CALORIE:
            return .largeCalorie()
        case .SMALL_CALORIE:
            return .smallCalorie()
        case .DEGREE_CELSIUS:
            return .degreeCelsius()
        case .DEGREE_FAHRENHEIT:
            return .degreeFahrenheit()
        case .KELVIN:
            return .degreeFahrenheit()
        case .DECIBEL_HEARING_LEVEL:
            return .decibelHearingLevel()
        case .HERTZ:
            return .hertz()
        case .SIEMEN:
            return .siemen()
        case .VOLT:
            if #available(iOS 14.0, *) {
                return .volt()
            } else {
                return HKUnit.init(from: "")
            }
        case .INTERNATIONAL_UNIT:
            return .internationalUnit()
        case .COUNT:
            return .count()
        case .PERCENT:
            return .percent()
        case .BEATS_PER_MINUTE:
            return HKUnit.init(from: "count/min")
        case .MILLIGRAM_PER_DECILITER:
            return HKUnit.init(from: "mg/dL")
        case .UNKNOWN_UNIT:
            return HKUnit.init(from: "")
        case .NO_UNIT:
            return HKUnit.init(from: "")
        }
    }
}
