//
//  SHPActivityType.swift
//  health_plugin
//
//  Created by Michael Jajou on 1/10/23.
//

import Foundation
import HealthKit

enum SHPActivityType: String, CaseIterable {
    case ARCHERY
    case BOWLING
    case FENCING
    case GYMNASTICS
    case TRACK_AND_FIELD
    case AMERICAN_FOOTBALL
    case AUSTRALIAN_FOOTBALL
    case BASEBALL
    case BASKETBALL
    case CARDIO_DANCE
    case CRICKET
    case COOLDOWN
    case DISC_SPORTS
    case HANDBALL
    case HOCKEY
    case LACROSSE
    case RUGBY
    case SOCCER
    case SOFTBALL
    case VOLLEYBALL
    case PREPARATION_AND_RECOVERY
    case FLEXIBILITY
    case WALKING
    case RUNNING
    case RUNNING_JOGGING
    case RUNNING_SAND
    case RUNNING_TREADMILL
    case WHEELCHAIR_WALK_PACE
    case WHEELCHAR_RUN_PACE
    case BIKING
    case HAND_CYCLING
    case CORE_TRAINING
    case ELLIPTICAL
    case FUNCTIONAL_STRENGTH_TRAINING
    case TRADITIONAL_STRENGTH_TRAINING
    case CROSS_TRAINING
    case MIXED_CARDIO
    case HIGH_INTENSITY_INTERVAL_TRAINING
    case JUMP_ROPE
    case STAIR_CLIMBING
    case STAIRS
    case STEP_TRAINING
    case FITNESS_GAMING
    case BARRE
    case YOGA
    case MIND_AND_BODY
    case PILATES
    case BADMINTON
    case RACQUETBALL
    case SQUASH
    case TABLE_TENNIS
    case TENNIS
    case CLIMBING
    case ROCK_CLIMBING
    case EQUESTRIAN_SPORTS
    case FISHING
    case GOLF
    case HIKING
    case HUNTING
    case PLAY
    case CROSS_COUNTRY_SKIING
    case CURLING
    case DOWNHILL_SKIING
    case SNOW_SPORTS
    case SNOWBOARDING
    case SKATING
    case SKATING_CROSS
    case SKATING_INDOOR
    case SKATING_INLINE
    case PADDLE_SPORTS
    case PICKLEBALL
    case ROWING
    case SAILING
    case SOCIAL_DANCE
    case SURFING_SPORTS
    case SWIMMING
    case WATER_FITNESS
    case WATER_POLO
    case WATER_SPORTS
    case BOXING
    case KICKBOXING
    case MARTIAL_ARTS
    case TAI_CHI
    case WRESTLING
    case OTHER
    
    var activity: HKWorkoutActivityType? {
        switch self {
        case .AMERICAN_FOOTBALL:
            return .americanFootball
        case .ARCHERY:
            return .archery
        case .BOWLING:
            return .bowling
        case .CARDIO_DANCE:
            if #available(iOS 14.0, *) {
                return .cardioDance
            } else {
                return nil
            }
        case .COOLDOWN:
            if #available(iOS 14.0, *) {
                return .cooldown
            } else {
                return nil
            }
        case .FENCING:
            return .fencing
        case .GYMNASTICS:
            return .gymnastics
        case .TRACK_AND_FIELD:
            return .trackAndField
        case .AUSTRALIAN_FOOTBALL:
            return .australianFootball
        case .BASEBALL:
            return .baseball
        case .BASKETBALL:
            return .basketball
        case .CRICKET:
            return .cricket
        case .DISC_SPORTS:
            return .discSports
        case .HANDBALL:
            return .handball
        case .HOCKEY:
            return .hockey
        case .LACROSSE:
            return .lacrosse
        case .RUGBY:
            return .rugby
        case .SOCCER:
            return .soccer
        case .SOFTBALL:
            return .softball
        case .VOLLEYBALL:
            return .volleyball
        case .PREPARATION_AND_RECOVERY:
            return .preparationAndRecovery
        case .FLEXIBILITY:
            return .flexibility
        case .WALKING:
            return .walking
        case .RUNNING:
            return .running
        case .RUNNING_JOGGING:
            return .running
        case .RUNNING_SAND:
            return .running
        case .RUNNING_TREADMILL:
            return .running
        case .WHEELCHAIR_WALK_PACE:
            return .wheelchairWalkPace
        case .WHEELCHAR_RUN_PACE:
            return .wheelchairRunPace
        case .BIKING:
            return .cycling
        case .HAND_CYCLING:
            return .handCycling
        case .CORE_TRAINING:
            return .coreTraining
        case .ELLIPTICAL:
            return .elliptical
        case .FUNCTIONAL_STRENGTH_TRAINING:
            return .functionalStrengthTraining
        case .TRADITIONAL_STRENGTH_TRAINING:
            return .traditionalStrengthTraining
        case .CROSS_TRAINING:
            return .crossTraining
        case .MIXED_CARDIO:
            return .mixedCardio
        case .HIGH_INTENSITY_INTERVAL_TRAINING:
            return .highIntensityIntervalTraining
        case .JUMP_ROPE:
            return .jumpRope
        case .STAIR_CLIMBING:
            return .stairClimbing
        case .STAIRS:
            return .stairs
        case .STEP_TRAINING:
            return .stepTraining
        case .FITNESS_GAMING:
            return .fitnessGaming
        case .BARRE:
            return .barre
        case .YOGA:
            return .yoga
        case .MIND_AND_BODY:
            return .mindAndBody
        case .PILATES:
            return .pilates
        case .BADMINTON:
            return .badminton
        case .RACQUETBALL:
            return .racquetball
        case .SQUASH:
            return .squash
        case .TABLE_TENNIS:
            return .tableTennis
        case .TENNIS:
            return .tennis
        case .CLIMBING:
            return .climbing
        case .ROCK_CLIMBING:
            return .climbing
        case .EQUESTRIAN_SPORTS:
            return .equestrianSports
        case .FISHING:
            return .fishing
        case .GOLF:
            return .golf
        case .HIKING:
            return .hiking
        case .HUNTING:
            return .hunting
        case .PLAY:
            return .play
        case .CROSS_COUNTRY_SKIING:
            return .crossCountrySkiing
        case .CURLING:
            return .curling
        case .DOWNHILL_SKIING:
            return .downhillSkiing
        case .SNOW_SPORTS:
            return .snowSports
        case .SNOWBOARDING:
            return .snowboarding
        case .SKATING:
            return .skatingSports
        case .SKATING_CROSS:
            return .skatingSports
        case .SKATING_INDOOR:
            return .skatingSports
        case .SKATING_INLINE:
            return .skatingSports
        case .PADDLE_SPORTS:
            return .paddleSports
        case .PICKLEBALL:
            if #available(iOS 14.0, *) {
                return .pickleball
            } else {
                return nil
            }
        case .ROWING:
            return .rowing
        case .SAILING:
            return .sailing
        case .SOCIAL_DANCE:
            if #available(iOS 14.0, *) {
                return .socialDance
            } else {
                return nil
            }
        case .SURFING_SPORTS:
            return .surfingSports
        case .SWIMMING:
            return .swimming
        case .WATER_FITNESS:
            return .waterFitness
        case .WATER_POLO:
            return .waterPolo
        case .WATER_SPORTS:
            return .waterSports
        case .BOXING:
            return .boxing
        case .KICKBOXING:
            return .kickboxing
        case .MARTIAL_ARTS:
            return .martialArts
        case .TAI_CHI:
            return .taiChi
        case .WRESTLING:
            return .wrestling
        case .OTHER:
            return .other
        }
    }
}
