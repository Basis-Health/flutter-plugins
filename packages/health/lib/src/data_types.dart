part of health;

final Map<String, HealthWorkoutActivityType> _healthWorkoutActivityTypeReverse = Map.fromEntries(
  HealthWorkoutActivityType.values.map((e) => MapEntry(e.typeToString(), e)),
);
final Map<String, HealthDataType> _healthDataTypeReverse = Map.fromEntries(
  HealthDataType.values.map((e) => MapEntry(e.typeToString(), e)),
);
final Map<String, HealthDataUnit> _healthDataUnitReverse = Map.fromEntries(
  HealthDataUnit.values.map((e) => MapEntry(e.typeToString(), e)),
);

/// List of all available data types.
enum HealthDataType {
  ACTIVE_ENERGY_BURNED(HealthDataUnit.KILOCALORIE),
  AUDIOGRAM(HealthDataUnit.DECIBEL_HEARING_LEVEL),
  BASAL_ENERGY_BURNED(HealthDataUnit.KILOCALORIE),
  BLOOD_GLUCOSE(HealthDataUnit.MILLIGRAM_PER_DECILITER),
  BLOOD_OXYGEN(HealthDataUnit.PERCENT),
  BLOOD_PRESSURE_DIASTOLIC(HealthDataUnit.MILLIMETER_OF_MERCURY),
  BLOOD_PRESSURE_SYSTOLIC(HealthDataUnit.MILLIMETER_OF_MERCURY),
  BODY_FAT_PERCENTAGE(HealthDataUnit.PERCENT),
  BODY_MASS_INDEX(HealthDataUnit.NO_UNIT),
  BODY_TEMPERATURE(HealthDataUnit.DEGREE_CELSIUS),
  DIETARY_ENERGY(HealthDataUnit.KILOCALORIE),
  DIETARY_CARBS(HealthDataUnit.GRAM),
  DIETARY_FIBER(HealthDataUnit.GRAM),
  DIETARY_SUGAR(HealthDataUnit.GRAM),
  DIETARY_FAT(HealthDataUnit.GRAM),
  DIETARY_FAT_MONOUNSATURATED(HealthDataUnit.GRAM),
  DIETARY_FAT_POLYUNSATURATED(HealthDataUnit.GRAM),
  DIETARY_FAT_SATURATED(HealthDataUnit.GRAM),
  DIETARY_CHOLESTEROL(HealthDataUnit.MILLIGRAM),
  DIETARY_PROTEIN(HealthDataUnit.GRAM),
  DIETARY_VITAMIN_A(HealthDataUnit.MICROGRAM),
  DIETARY_THIAMIN(HealthDataUnit.MILLIGRAM),
  DIETARY_RIBOFLAVIN(HealthDataUnit.MILLIGRAM),
  DIETARY_NIACIN(HealthDataUnit.MILLIGRAM),
  DIETARY_PANTOTHENIC_ACID(HealthDataUnit.MILLIGRAM),
  DIETARY_VITAMIN_B6(HealthDataUnit.MILLIGRAM),
  DIETARY_BIOTIN(HealthDataUnit.MICROGRAM),
  DIETARY_VITAMIN_B12(HealthDataUnit.MICROGRAM),
  DIETARY_VITAMIN_C(HealthDataUnit.MILLIGRAM),
  DIETARY_VITAMIN_D(HealthDataUnit.MICROGRAM),
  DIETARY_VITAMIN_E(HealthDataUnit.MILLIGRAM),
  DIETARY_VITAMIN_K(HealthDataUnit.MICROGRAM),
  DIETARY_FOLATE(HealthDataUnit.MICROGRAM),
  DIETARY_CALCIUM(HealthDataUnit.MILLIGRAM),
  DIETARY_CHLORIDE(HealthDataUnit.MILLIGRAM),
  DIETARY_IRON(HealthDataUnit.MILLIGRAM),
  DIETARY_MAGNESIUM(HealthDataUnit.MILLIGRAM),
  DIETARY_PHOSPHORUS(HealthDataUnit.MILLIGRAM),
  DIETARY_POTASSIUM(HealthDataUnit.MILLIGRAM),
  DIETARY_SODIUM(HealthDataUnit.MILLIGRAM),
  DIETARY_ZINC(HealthDataUnit.MILLIGRAM),
  DIETARY_WATER(HealthDataUnit.LITER),
  DIETARY_CAFFEINE(HealthDataUnit.MILLIGRAM),
  DIETARY_CHROMIUM(HealthDataUnit.MICROGRAM),
  DIETARY_COPPER(HealthDataUnit.MILLIGRAM),
  DIETARY_IODINE(HealthDataUnit.MICROGRAM),
  DIETARY_MANGANESE(HealthDataUnit.MILLIGRAM),
  DIETARY_MOLYBDENUM(HealthDataUnit.MICROGRAM),
  DIETARY_SELENIUM(HealthDataUnit.MICROGRAM),
  FORCED_EXPIRATORY_VOLUME(HealthDataUnit.LITER),
  HEART_RATE(HealthDataUnit.BEATS_PER_MINUTE),
  HEART_RATE_VARIABILITY_SDNN(HealthDataUnit.MILLISECOND),
  HEIGHT(HealthDataUnit.METER),
  RESTING_HEART_RATE(HealthDataUnit.BEATS_PER_MINUTE),
  STEPS(HealthDataUnit.COUNT),
  WAIST_CIRCUMFERENCE(HealthDataUnit.METER),
  WALKING_HEART_RATE(HealthDataUnit.BEATS_PER_MINUTE),
  WEIGHT(HealthDataUnit.KILOGRAM),
  DISTANCE_WALKING_RUNNING(HealthDataUnit.METER),
  FLIGHTS_CLIMBED(HealthDataUnit.COUNT),
  MOVE_MINUTES(HealthDataUnit.MINUTE),
  DISTANCE_DELTA(HealthDataUnit.METER),
  MINDFULNESS(HealthDataUnit.MINUTE),
  SLEEP(HealthDataUnit.SLEEP),
  EXERCISE_TIME(HealthDataUnit.MINUTE),
  WORKOUT(HealthDataUnit.NO_UNIT),
  HEADACHE(HealthDataUnit.HEADACHE),
  VO2MAX(HealthDataUnit.MILLILITER_PER_KILOGRAM_PER_MINUTE),
  DATE_OF_BIRTH(HealthDataUnit.NO_UNIT),
  GENDER(HealthDataUnit.NO_UNIT),

  // Heart Rate events (specific to Apple Watch)
  HIGH_HEART_RATE_EVENT(HealthDataUnit.NO_UNIT),
  LOW_HEART_RATE_EVENT(HealthDataUnit.NO_UNIT),
  IRREGULAR_HEART_RATE_EVENT(HealthDataUnit.NO_UNIT),
  ELECTRODERMAL_ACTIVITY(HealthDataUnit.SIEMEN),
  ;

  final HealthDataUnit unit;

  const HealthDataType([this.unit = HealthDataUnit.UNKNOWN_UNIT]);

  /// Returns the string representation of the enum
  /// e.g. [HealthDataType.BLOOD_GLUCOSE] -> 'BLOOD_GLUCOSE'
  String typeToString() => name;

  static HealthDataType fromTypeString(String v) => _healthDataTypeReverse[v]!;
}


enum HealthDataAccess {
  READ,
  WRITE,
  READ_WRITE,
}

enum DeviceSleepStage {
  SLEEP_IN_BED(SLEEP_IN_BED_APPLE),
  SLEEP_ASLEEP(SLEEP_ASLEEP_APPLE),
  SLEEP_AWAKE(SLEEP_AWAKE_APPLE),
  SLEEP_CORE(SLEEP_CORE_APPLE),
  SLEEP_DEEP(SLEEP_DEEP_APPLE),
  SLEEP_REM(SLEEP_REM_APPLE);

  static const SLEEP_IN_BED_APPLE = 0;
  static const SLEEP_ASLEEP_APPLE = 1;
  static const SLEEP_AWAKE_APPLE = 2;
  static const SLEEP_CORE_APPLE = 3;
  static const SLEEP_DEEP_APPLE = 4;
  static const SLEEP_REM_APPLE = 5;

  const DeviceSleepStage(this.appleValue);

  final int appleValue;
}


enum DeviceGender {
  unknown(UNKNOWN_APPLE),
  male(MALE_APPLE),
  female(FEMALE_APPLE),
  other(OTHER_APPLE);

  static const UNKNOWN_APPLE = 'unknown';
  static const MALE_APPLE = 'male';
  static const FEMALE_APPLE = 'female';
  static const OTHER_APPLE = 'other';


  final String appleValue;


  const DeviceGender(this.appleValue);
}

enum DeviceHeadache {
  HEADACHE_UNSPECIFIED(HEADACHE_UNSPECIFIED_APPLE),
  HEADACHE_NOT_PRESENT(HEADACHE_NOT_PRESENT_APPLE),
  HEADACHE_MILD(HEADACHE_MILD_APPLE),
  HEADACHE_MODERATE(HEADACHE_MODERATE_APPLE),
  HEADACHE_SEVERE(HEADACHE_SEVERE_APPLE);

  static const HEADACHE_UNSPECIFIED_APPLE = 0;
  static const HEADACHE_NOT_PRESENT_APPLE = 1;
  static const HEADACHE_MILD_APPLE = 2;
  static const HEADACHE_MODERATE_APPLE = 3;
  static const HEADACHE_SEVERE_APPLE = 4;

  const DeviceHeadache(this.appleValue);
  final int appleValue;
}

/// List of data types available on iOS
const Set<HealthDataType> dataTypeKeysIOS = {
  HealthDataType.DATE_OF_BIRTH,
  HealthDataType.GENDER,
  HealthDataType.ACTIVE_ENERGY_BURNED,
  HealthDataType.AUDIOGRAM,
  HealthDataType.BASAL_ENERGY_BURNED,
  HealthDataType.VO2MAX,
  HealthDataType.BLOOD_GLUCOSE,
  HealthDataType.BLOOD_OXYGEN,
  HealthDataType.BLOOD_PRESSURE_DIASTOLIC,
  HealthDataType.BLOOD_PRESSURE_SYSTOLIC,
  HealthDataType.BODY_FAT_PERCENTAGE,
  HealthDataType.BODY_MASS_INDEX,
  HealthDataType.BODY_TEMPERATURE,
  HealthDataType.DIETARY_ENERGY,
  HealthDataType.DIETARY_CARBS,
  HealthDataType.DIETARY_FIBER,
  HealthDataType.DIETARY_SUGAR,
  HealthDataType.DIETARY_FAT,
  HealthDataType.DIETARY_FAT_MONOUNSATURATED,
  HealthDataType.DIETARY_FAT_POLYUNSATURATED,
  HealthDataType.DIETARY_FAT_SATURATED,
  HealthDataType.DIETARY_CHOLESTEROL,
  HealthDataType.DIETARY_PROTEIN,
  HealthDataType.DIETARY_VITAMIN_A,
  HealthDataType.DIETARY_THIAMIN,
  HealthDataType.DIETARY_RIBOFLAVIN,
  HealthDataType.DIETARY_NIACIN,
  HealthDataType.DIETARY_PANTOTHENIC_ACID,
  HealthDataType.DIETARY_VITAMIN_B6,
  HealthDataType.DIETARY_BIOTIN,
  HealthDataType.DIETARY_VITAMIN_B12,
  HealthDataType.DIETARY_VITAMIN_C,
  HealthDataType.DIETARY_VITAMIN_D,
  HealthDataType.DIETARY_VITAMIN_E,
  HealthDataType.DIETARY_VITAMIN_K,
  HealthDataType.DIETARY_FOLATE,
  HealthDataType.DIETARY_CALCIUM,
  HealthDataType.DIETARY_CHLORIDE,
  HealthDataType.DIETARY_IRON,
  HealthDataType.DIETARY_MAGNESIUM,
  HealthDataType.DIETARY_PHOSPHORUS,
  HealthDataType.DIETARY_POTASSIUM,
  HealthDataType.DIETARY_SODIUM,
  HealthDataType.DIETARY_ZINC,
  HealthDataType.DIETARY_WATER,
  HealthDataType.DIETARY_CAFFEINE,
  HealthDataType.DIETARY_CHROMIUM,
  HealthDataType.DIETARY_COPPER,
  HealthDataType.DIETARY_IODINE,
  HealthDataType.DIETARY_MANGANESE,
  HealthDataType.DIETARY_MOLYBDENUM,
  HealthDataType.DIETARY_SELENIUM,
  HealthDataType.ELECTRODERMAL_ACTIVITY,
  HealthDataType.FORCED_EXPIRATORY_VOLUME,
  HealthDataType.HEART_RATE,
  HealthDataType.HEART_RATE_VARIABILITY_SDNN,
  HealthDataType.HEIGHT,
  HealthDataType.HIGH_HEART_RATE_EVENT,
  HealthDataType.IRREGULAR_HEART_RATE_EVENT,
  HealthDataType.LOW_HEART_RATE_EVENT,
  HealthDataType.RESTING_HEART_RATE,
  HealthDataType.STEPS,
  HealthDataType.WAIST_CIRCUMFERENCE,
  HealthDataType.WALKING_HEART_RATE,
  HealthDataType.WEIGHT,
  HealthDataType.FLIGHTS_CLIMBED,
  HealthDataType.DISTANCE_WALKING_RUNNING,
  HealthDataType.MINDFULNESS,
  HealthDataType.SLEEP,
  HealthDataType.EXERCISE_TIME,
  HealthDataType.WORKOUT,
  HealthDataType.HEADACHE,
};
late final dataTypeKeysIOSList = dataTypeKeysIOS.toList(growable: false);

/// List of data types available on Android
const Set<HealthDataType> dataTypeKeysAndroid = {
  HealthDataType.ACTIVE_ENERGY_BURNED,
  HealthDataType.BLOOD_GLUCOSE,
  HealthDataType.BLOOD_OXYGEN,
  HealthDataType.BLOOD_PRESSURE_DIASTOLIC,
  HealthDataType.BLOOD_PRESSURE_SYSTOLIC,
  HealthDataType.BODY_FAT_PERCENTAGE,
  HealthDataType.BODY_MASS_INDEX,
  HealthDataType.BODY_TEMPERATURE,
  HealthDataType.HEART_RATE,
  HealthDataType.HEIGHT,
  HealthDataType.STEPS,
  HealthDataType.WEIGHT,
  HealthDataType.MOVE_MINUTES,
  HealthDataType.DISTANCE_DELTA,
  HealthDataType.SLEEP,
  HealthDataType.DIETARY_WATER, // TODO update key in Android
  HealthDataType.WORKOUT,
};
late final dataTypeKeysAndroidList = dataTypeKeysAndroid.toList(growable: false);

const Set<HealthWorkoutActivityType> activityTypesiOS = const {
  HealthWorkoutActivityType.ARCHERY,
  HealthWorkoutActivityType.BADMINTON,
  HealthWorkoutActivityType.BASEBALL,
  HealthWorkoutActivityType.BASKETBALL,
  HealthWorkoutActivityType.BIKING,
  HealthWorkoutActivityType.BOXING,
  HealthWorkoutActivityType.CRICKET,
  HealthWorkoutActivityType.CURLING,
  HealthWorkoutActivityType.ELLIPTICAL,
  HealthWorkoutActivityType.FENCING,
  HealthWorkoutActivityType.AMERICAN_FOOTBALL,
  HealthWorkoutActivityType.AUSTRALIAN_FOOTBALL,
  HealthWorkoutActivityType.SOCCER,
  HealthWorkoutActivityType.GOLF,
  HealthWorkoutActivityType.GYMNASTICS,
  HealthWorkoutActivityType.HANDBALL,
  HealthWorkoutActivityType.HIGH_INTENSITY_INTERVAL_TRAINING,
  HealthWorkoutActivityType.HIKING,
  HealthWorkoutActivityType.HOCKEY,
  HealthWorkoutActivityType.SKATING,
  HealthWorkoutActivityType.JUMP_ROPE,
  HealthWorkoutActivityType.KICKBOXING,
  HealthWorkoutActivityType.MARTIAL_ARTS,
  HealthWorkoutActivityType.PILATES,
  HealthWorkoutActivityType.RACQUETBALL,
  HealthWorkoutActivityType.ROWING,
  HealthWorkoutActivityType.RUGBY,
  HealthWorkoutActivityType.RUNNING,
  HealthWorkoutActivityType.SAILING,
  HealthWorkoutActivityType.CROSS_COUNTRY_SKIING,
  HealthWorkoutActivityType.DOWNHILL_SKIING,
  HealthWorkoutActivityType.SNOWBOARDING,
  HealthWorkoutActivityType.SOFTBALL,
  HealthWorkoutActivityType.SQUASH,
  HealthWorkoutActivityType.STAIR_CLIMBING,
  HealthWorkoutActivityType.SWIMMING,
  HealthWorkoutActivityType.TABLE_TENNIS,
  HealthWorkoutActivityType.TENNIS,
  HealthWorkoutActivityType.VOLLEYBALL,
  HealthWorkoutActivityType.WALKING,
  HealthWorkoutActivityType.WATER_POLO,
  HealthWorkoutActivityType.YOGA,
  HealthWorkoutActivityType.BOWLING,
  HealthWorkoutActivityType.CROSS_TRAINING,
  HealthWorkoutActivityType.TRACK_AND_FIELD,
  HealthWorkoutActivityType.DISC_SPORTS,
  HealthWorkoutActivityType.LACROSSE,
  HealthWorkoutActivityType.PREPARATION_AND_RECOVERY,
  HealthWorkoutActivityType.FLEXIBILITY,
  HealthWorkoutActivityType.COOLDOWN,
  HealthWorkoutActivityType.WHEELCHAIR_WALK_PACE,
  HealthWorkoutActivityType.WHEELCHAIR_RUN_PACE,
  HealthWorkoutActivityType.HAND_CYCLING,
  HealthWorkoutActivityType.CORE_TRAINING,
  HealthWorkoutActivityType.FUNCTIONAL_STRENGTH_TRAINING,
  HealthWorkoutActivityType.TRADITIONAL_STRENGTH_TRAINING,
  HealthWorkoutActivityType.MIXED_CARDIO,
  HealthWorkoutActivityType.STAIRS,
  HealthWorkoutActivityType.STEP_TRAINING,
  HealthWorkoutActivityType.FITNESS_GAMING,
  HealthWorkoutActivityType.BARRE,
  HealthWorkoutActivityType.CARDIO_DANCE,
  HealthWorkoutActivityType.SOCIAL_DANCE,
  HealthWorkoutActivityType.MIND_AND_BODY,
  HealthWorkoutActivityType.PICKLEBALL,
  HealthWorkoutActivityType.CLIMBING,
  HealthWorkoutActivityType.EQUESTRIAN_SPORTS,
  HealthWorkoutActivityType.FISHING,
  HealthWorkoutActivityType.HUNTING,
  HealthWorkoutActivityType.PLAY,
  HealthWorkoutActivityType.SNOW_SPORTS,
  HealthWorkoutActivityType.PADDLE_SPORTS,
  HealthWorkoutActivityType.SURFING_SPORTS,
  HealthWorkoutActivityType.WATER_FITNESS,
  HealthWorkoutActivityType.WATER_SPORTS,
  HealthWorkoutActivityType.TAI_CHI,
  HealthWorkoutActivityType.WRESTLING,
  HealthWorkoutActivityType.OTHER,
};

const Set<HealthWorkoutActivityType> activityTypesAndroid = const {
  HealthWorkoutActivityType.ARCHERY,
  HealthWorkoutActivityType.BADMINTON,
  HealthWorkoutActivityType.BASEBALL,
  HealthWorkoutActivityType.BASKETBALL,
  HealthWorkoutActivityType.BIKING,
  HealthWorkoutActivityType.BOXING,
  HealthWorkoutActivityType.CRICKET,
  HealthWorkoutActivityType.CURLING,
  HealthWorkoutActivityType.ELLIPTICAL,
  HealthWorkoutActivityType.FENCING,
  HealthWorkoutActivityType.AMERICAN_FOOTBALL,
  HealthWorkoutActivityType.AUSTRALIAN_FOOTBALL,
  HealthWorkoutActivityType.SOCCER,
  HealthWorkoutActivityType.GOLF,
  HealthWorkoutActivityType.GYMNASTICS,
  HealthWorkoutActivityType.HANDBALL,
  HealthWorkoutActivityType.HIGH_INTENSITY_INTERVAL_TRAINING,
  HealthWorkoutActivityType.HIKING,
  HealthWorkoutActivityType.HOCKEY,
  HealthWorkoutActivityType.SKATING,
  HealthWorkoutActivityType.JUMP_ROPE,
  HealthWorkoutActivityType.KICKBOXING,
  HealthWorkoutActivityType.MARTIAL_ARTS,
  HealthWorkoutActivityType.PILATES,
  HealthWorkoutActivityType.RACQUETBALL,
  HealthWorkoutActivityType.ROWING,
  HealthWorkoutActivityType.RUGBY,
  HealthWorkoutActivityType.RUNNING,
  HealthWorkoutActivityType.SAILING,
  HealthWorkoutActivityType.CROSS_COUNTRY_SKIING,
  HealthWorkoutActivityType.DOWNHILL_SKIING,
  HealthWorkoutActivityType.SNOWBOARDING,
  HealthWorkoutActivityType.SOFTBALL,
  HealthWorkoutActivityType.SQUASH,
  HealthWorkoutActivityType.STAIR_CLIMBING,
  HealthWorkoutActivityType.SWIMMING,
  HealthWorkoutActivityType.TABLE_TENNIS,
  HealthWorkoutActivityType.TENNIS,
  HealthWorkoutActivityType.VOLLEYBALL,
  HealthWorkoutActivityType.WALKING,
  HealthWorkoutActivityType.WATER_POLO,
  HealthWorkoutActivityType.YOGA,
  HealthWorkoutActivityType.AEROBICS,
  HealthWorkoutActivityType.BIATHLON,
  HealthWorkoutActivityType.CALISTHENICS,
  HealthWorkoutActivityType.CIRCUIT_TRAINING,
  HealthWorkoutActivityType.CROSS_FIT,
  HealthWorkoutActivityType.DANCING,
  HealthWorkoutActivityType.DIVING,
  HealthWorkoutActivityType.ELEVATOR,
  HealthWorkoutActivityType.ERGOMETER,
  HealthWorkoutActivityType.ESCALATOR,
  HealthWorkoutActivityType.FRISBEE_DISC,
  HealthWorkoutActivityType.GARDENING,
  HealthWorkoutActivityType.GUIDED_BREATHING,
  HealthWorkoutActivityType.HORSEBACK_RIDING,
  HealthWorkoutActivityType.HOUSEWORK,
  HealthWorkoutActivityType.INTERVAL_TRAINING,
  HealthWorkoutActivityType.IN_VEHICLE,
  HealthWorkoutActivityType.KAYAKING,
  HealthWorkoutActivityType.KETTLEBELL_TRAINING,
  HealthWorkoutActivityType.KICK_SCOOTER,
  HealthWorkoutActivityType.KITE_SURFING,
  HealthWorkoutActivityType.MEDITATION,
  HealthWorkoutActivityType.MIXED_MARTIAL_ARTS,
  HealthWorkoutActivityType.P90X,
  HealthWorkoutActivityType.PARAGLIDING,
  HealthWorkoutActivityType.POLO,
  HealthWorkoutActivityType.ROCK_CLIMBING,
  HealthWorkoutActivityType.RUNNING_JOGGING,
  HealthWorkoutActivityType.RUNNING_SAND,
  HealthWorkoutActivityType.RUNNING_TREADMILL,
  HealthWorkoutActivityType.SCUBA_DIVING,
  HealthWorkoutActivityType.SKATING_CROSS,
  HealthWorkoutActivityType.SKATING_INDOOR,
  HealthWorkoutActivityType.SKATING_INLINE,
  HealthWorkoutActivityType.SKIING_BACK_COUNTRY,
  HealthWorkoutActivityType.SKIING_KITE,
  HealthWorkoutActivityType.SKIING_ROLLER,
  HealthWorkoutActivityType.SLEDDING,
  HealthWorkoutActivityType.STAIR_CLIMBING_MACHINE,
  HealthWorkoutActivityType.STANDUP_PADDLEBOARDING,
  HealthWorkoutActivityType.STILL,
  HealthWorkoutActivityType.STRENGTH_TRAINING,
  HealthWorkoutActivityType.SURFING,
  HealthWorkoutActivityType.SWIMMING_OPEN_WATER,
  HealthWorkoutActivityType.SWIMMING_POOL,
  HealthWorkoutActivityType.TEAM_SPORTS,
  HealthWorkoutActivityType.TILTING,
  HealthWorkoutActivityType.VOLLEYBALL_BEACH,
  HealthWorkoutActivityType.VOLLEYBALL_INDOOR,
  HealthWorkoutActivityType.WAKEBOARDING,
  HealthWorkoutActivityType.WALKING_FITNESS,
  HealthWorkoutActivityType.WALKING_NORDIC,
  HealthWorkoutActivityType.WALKING_STROLLER,
  HealthWorkoutActivityType.WALKING_TREADMILL,
  HealthWorkoutActivityType.WEIGHTLIFTING,
  HealthWorkoutActivityType.WHEELCHAIR,
  HealthWorkoutActivityType.WINDSURFING,
  HealthWorkoutActivityType.ZUMBA,
  HealthWorkoutActivityType.OTHER,
};

const PlatformTypeJsonValue = {
  PlatformType.IOS: 'ios', PlatformType.ANDROID: 'android',
};
const platformTypeJsonValueReverse = {
  'ios': PlatformType.IOS, 'android': PlatformType.ANDROID,
};

/// List of all [HealthDataUnit]s.
enum HealthDataUnit {
  // Mass units
  MICROGRAM,
  MILLIGRAM,
  GRAM,
  KILOGRAM,
  OUNCE,
  POUND,
  STONE,
  // MOLE_UNIT_WITH_MOLAR_MASS, // requires molar mass input - not supported yet
  // MOLE_UNIT_WITH_PREFIX_MOLAR_MASS, // requires molar mass & prefix input - not supported yet

  // Length units
  METER,
  INCH,
  FOOT,
  YARD,
  MILE,

  // Volume units
  LITER,
  MILLILITER,
  FLUID_OUNCE_US,
  FLUID_OUNCE_IMPERIAL,
  CUP_US,
  CUP_IMPERIAL,
  PINT_US,
  PINT_IMPERIAL,

  // Pressure units
  PASCAL,
  MILLIMETER_OF_MERCURY,
  INCHES_OF_MERCURY,
  CENTIMETER_OF_WATER,
  ATMOSPHERE,
  DECIBEL_A_WEIGHTED_SOUND_PRESSURE_LEVEL,

  // Time units
  SECOND,
  MILLISECOND,
  MINUTE,
  HOUR,
  DAY,

  SLEEP,
  HEADACHE,

  // vo2max
  MILLILITER_PER_KILOGRAM_PER_MINUTE,

  // Energy units
  JOULE,
  KILOCALORIE,
  LARGE_CALORIE,
  SMALL_CALORIE,

  // Temperature units
  DEGREE_CELSIUS,
  DEGREE_FAHRENHEIT,
  KELVIN,

  // Hearing units
  DECIBEL_HEARING_LEVEL,

  // Frequency units
  HERTZ,

  // Electrical conductance units
  SIEMEN,

  // Potential units
  VOLT,

  // Pharmacology units
  INTERNATIONAL_UNIT,

  // Scalar units
  COUNT,
  PERCENT,

  // Other units
  BEATS_PER_MINUTE,
  MILLIGRAM_PER_DECILITER,
  UNKNOWN_UNIT,
  NO_UNIT;

  /// Returns the string representation of the enum
  /// e.g. [HealthDataUnit.LITER] -> 'LITER'
  String typeToString() => name;

  static HealthDataUnit fromTypeString(String type) => _healthDataUnitReverse[type]!;
}

/// List of [HealthWorkoutActivityType]s.
/// Commented for which platform they are supported
enum HealthWorkoutActivityType {
  // Both
  ARCHERY,
  BADMINTON,
  BASEBALL,
  BASKETBALL,
  BIKING, // This also entails the iOS version where it is called CYCLING
  BOXING,
  CRICKET,
  CURLING,
  ELLIPTICAL,
  FENCING,
  AMERICAN_FOOTBALL,
  AUSTRALIAN_FOOTBALL,
  SOCCER,
  GOLF,
  GYMNASTICS,
  HANDBALL,
  HIGH_INTENSITY_INTERVAL_TRAINING,
  HIKING,
  HOCKEY,
  SKATING,
  JUMP_ROPE,
  KICKBOXING,
  MARTIAL_ARTS,
  PILATES,
  RACQUETBALL,
  ROWING,
  RUGBY,
  RUNNING,
  SAILING,
  CROSS_COUNTRY_SKIING,
  DOWNHILL_SKIING,
  SNOWBOARDING,
  SOFTBALL,
  SQUASH,
  STAIR_CLIMBING,
  SWIMMING,
  TABLE_TENNIS,
  TENNIS,
  VOLLEYBALL,
  WALKING,
  WATER_POLO,
  YOGA,

  // iOS only
  BOWLING,
  CROSS_TRAINING,
  TRACK_AND_FIELD,
  DISC_SPORTS,
  LACROSSE,
  PREPARATION_AND_RECOVERY,
  FLEXIBILITY,
  COOLDOWN,
  WHEELCHAIR_WALK_PACE,
  WHEELCHAIR_RUN_PACE,
  HAND_CYCLING,
  CORE_TRAINING,
  FUNCTIONAL_STRENGTH_TRAINING,
  TRADITIONAL_STRENGTH_TRAINING,
  MIXED_CARDIO,
  STAIRS,
  STEP_TRAINING,
  FITNESS_GAMING,
  BARRE,
  CARDIO_DANCE,
  SOCIAL_DANCE,
  MIND_AND_BODY,
  PICKLEBALL,
  CLIMBING,
  EQUESTRIAN_SPORTS,
  FISHING,
  HUNTING,
  PLAY,
  SNOW_SPORTS,
  PADDLE_SPORTS,
  SURFING_SPORTS,
  WATER_FITNESS,
  WATER_SPORTS,
  TAI_CHI,
  WRESTLING,

  // Android only
  AEROBICS,
  BIATHLON,
  CALISTHENICS,
  CIRCUIT_TRAINING,
  CROSS_FIT,
  DANCING,
  DIVING,
  ELEVATOR,
  ERGOMETER,
  ESCALATOR,
  FRISBEE_DISC,
  GARDENING,
  GUIDED_BREATHING,
  HORSEBACK_RIDING,
  HOUSEWORK,
  INTERVAL_TRAINING,
  IN_VEHICLE,
  KAYAKING,
  KETTLEBELL_TRAINING,
  KICK_SCOOTER,
  KITE_SURFING,
  MEDITATION,
  MIXED_MARTIAL_ARTS,
  P90X,
  PARAGLIDING,
  POLO,
  ROCK_CLIMBING, // on iOS this is the same as CLIMBING
  RUNNING_JOGGING, // on iOS this is the same as RUNNING
  RUNNING_SAND, // on iOS this is the same as RUNNING
  RUNNING_TREADMILL, // on iOS this is the same as RUNNING
  SCUBA_DIVING,
  SKATING_CROSS, // on iOS this is the same as SKATING
  SKATING_INDOOR, // on iOS this is the same as SKATING
  SKATING_INLINE, // on iOS this is the same as SKATING
  SKIING_BACK_COUNTRY,
  SKIING_KITE,
  SKIING_ROLLER,
  SLEDDING,
  STAIR_CLIMBING_MACHINE,
  STANDUP_PADDLEBOARDING,
  STILL,
  STRENGTH_TRAINING,
  SURFING,
  SWIMMING_OPEN_WATER,
  SWIMMING_POOL,
  TEAM_SPORTS,
  TILTING,
  VOLLEYBALL_BEACH,
  VOLLEYBALL_INDOOR,
  WAKEBOARDING,
  WALKING_FITNESS,
  WALKING_NORDIC,
  WALKING_STROLLER,
  WALKING_TREADMILL,
  WEIGHTLIFTING,
  WHEELCHAIR,
  WINDSURFING,
  ZUMBA,

  //
  OTHER;

  /// Returns the string representation of the enum
  /// e.g. [HealthWorkoutActivityType.CYCLING] -> 'CYCLING'
  String typeToString() => name;

  static HealthWorkoutActivityType fromTypeString(String type) => _healthWorkoutActivityTypeReverse[type]!;
}
