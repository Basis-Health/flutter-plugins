part of health;

/// A numerical value from Apple HealthKit or Google Fit
/// such as integer or double.
/// E.g. 1, 2.9, -3
///
/// Parameters:
/// * [numericValue] - a [num] value for the [HealthDataPoint]
class NumericHealthValue extends HealthValue {
  final num numericValue;

  const NumericHealthValue(this.numericValue);

  @override
  String toString() => numericValue.toString();

  factory NumericHealthValue.fromJson(json)
    => NumericHealthValue(num.parse(json['numericValue']));

  Map<String, dynamic> toJson() => {
        'numericValue': numericValue.toString(),
      };

  @override
  bool operator ==(Object o) {
    return o is NumericHealthValue && this.numericValue == o.numericValue;
  }

  @override
  int get hashCode => numericValue.hashCode;
}

/// A [HealthValue] object for audiograms
///
/// Parameters:
/// * [frequencies] - array of frequencies of the test
/// * [leftEarSensitivities] threshold in decibel for the left ear
/// * [rightEarSensitivities] threshold in decibel for the left ear
class AudiogramHealthValue extends HealthValue {
  final List<num> _frequencies;
  final List<num> _leftEarSensitivities;
  final List<num> _rightEarSensitivities;

  const AudiogramHealthValue(this._frequencies, this._leftEarSensitivities,
      this._rightEarSensitivities);

  List<num> get frequencies => _frequencies;
  List<num> get leftEarSensitivities => _leftEarSensitivities;
  List<num> get rightEarSensitivities => _rightEarSensitivities;

  @override
  String toString() {
    return """frequencies: ${frequencies.toString()}, 
    left ear sensitivities: ${leftEarSensitivities.toString()}, 
    right ear sensitivities: ${rightEarSensitivities.toString()}""";
  }

  factory AudiogramHealthValue.fromJson(json) {
    return AudiogramHealthValue(
        List<num>.from(json['frequencies']),
        List<num>.from(json['leftEarSensitivities']),
        List<num>.from(json['rightEarSensitivities']));
  }

  Map<String, dynamic> toJson() => {
        'frequencies': frequencies.toString(),
        'leftEarSensitivities': leftEarSensitivities.toString(),
        'rightEarSensitivities': rightEarSensitivities.toString(),
      };

  @override
  bool operator ==(Object o) {
    return o is AudiogramHealthValue &&
        listEquals(this._frequencies, o.frequencies) &&
        listEquals(this._leftEarSensitivities, o.leftEarSensitivities) &&
        listEquals(this._rightEarSensitivities, o.rightEarSensitivities);
  }

  @override
  int get hashCode =>
      Object.hash(frequencies, leftEarSensitivities, rightEarSensitivities);
}

/// A [HealthValue] object for workouts
///
/// Parameters:
/// * [workoutActivityType] - the type of workout
/// * [totalEnergyBurned] - the total energy burned during the workout
/// * [totalEnergyBurnedUnit] - the unit of the total energy burned
/// * [totalDistance] - the total distance of the workout
/// * [totalDistanceUnit] - the unit of the total distance
class WorkoutHealthValue extends HealthValue {
  /// The type of the workout.
  final HealthWorkoutActivityType workoutActivityType;
  /// The total energy burned during the workout.
  /// Might not be available for all workouts.
  final int? totalEnergyBurned;
  /// The unit of the total energy burned during the workout.
  /// Might not be available for all workouts.
  final HealthDataUnit? totalEnergyBurnedUnit;
  /// The total distance covered during the workout.
  /// Might not be available for all workouts.
  final int? totalDistance;
  /// The unit of the total distance covered during the workout.
  /// Might not be available for all workouts.
  final HealthDataUnit? totalDistanceUnit;

  WorkoutHealthValue(
      this.workoutActivityType,
      this.totalEnergyBurned,
      this.totalEnergyBurnedUnit,
      this.totalDistance,
      this.totalDistanceUnit);

  factory WorkoutHealthValue.fromJson(json) {
    return WorkoutHealthValue(
        HealthWorkoutActivityType.fromTypeString(json['workoutActivityType']),
        json['totalEnergyBurned'] != null
            ? (json['totalEnergyBurned'] as num).toInt()
            : null,
        json['totalEnergyBurnedUnit'] != null
            ? HealthDataUnit.fromTypeString(json['totalEnergyBurnedUnit'])
            : null,
        json['totalDistance'] != null
            ? (json['totalDistance'] as num).toInt()
            : null,
        json['totalDistanceUnit'] != null
            ? HealthDataUnit.fromTypeString(json['totalDistanceUnit'])
            : null);
  }

  @override
  Map<String, dynamic> toJson() => {
        'workoutActivityType': workoutActivityType.typeToString(),
        'totalEnergyBurned': totalEnergyBurned,
        'totalEnergyBurnedUnit': totalEnergyBurnedUnit?.typeToString(),
        'totalDistance': totalDistance,
        'totalDistanceUnit': totalDistanceUnit?.typeToString(),
      };

  @override
  String toString() {
    return """workoutActivityType: ${workoutActivityType.typeToString()},
    totalEnergyBurned: $totalEnergyBurned,
    totalEnergyBurnedUnit: ${totalEnergyBurnedUnit?.typeToString()},
    totalDistance: $totalDistance,
    totalDistanceUnit: ${totalDistanceUnit?.typeToString()}""";
  }

  @override
  bool operator ==(Object o) {
    return o is WorkoutHealthValue &&
        workoutActivityType == o.workoutActivityType &&
        totalEnergyBurned == o.totalEnergyBurned &&
        totalEnergyBurnedUnit == o.totalEnergyBurnedUnit &&
        totalDistance == o.totalDistance &&
        totalDistanceUnit == o.totalDistanceUnit;
  }

  @override
  int get hashCode => Object.hash(workoutActivityType, totalEnergyBurned,
      totalEnergyBurnedUnit, totalDistance, totalDistanceUnit);
}

@immutable
abstract class HealthValue {
  const HealthValue();

  Map<String, dynamic> toJson();
}
