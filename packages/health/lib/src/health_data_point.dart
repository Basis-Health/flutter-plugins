part of health;

/// A [HealthDataPoint] object corresponds to a data point capture from
/// GoogleFit or Apple HealthKit with a [HealthValue] as value.
class HealthDataPoint {
  HealthValue _value;
  HealthDataType _type;
  HealthDataUnit _unit;
  DateTime _dateFrom;
  DateTime _dateTo;
  PlatformType _platform;
  String _sourceId;
  String _sourceName;
  String? _timezone;

  HealthDataPoint(
    this._value,
    this._type,
    this._unit,
    this._dateFrom,
    this._dateTo,
    this._platform,
    this._sourceId,
    this._sourceName,
    this._timezone,
  );

  /// Converts a json object to the [HealthDataPoint]
  factory HealthDataPoint.fromJson(json) {
    var dataType = HealthDataType.fromTypeString(json['data_type']);
    HealthValue value;
    if (dataType == HealthDataType.AUDIOGRAM) {
      value = AudiogramHealthValue.fromJson(json['value']);
    } else if (dataType == HealthDataType.WORKOUT) {
      value = WorkoutHealthValue.fromJson(json['value']);
    } else {
      value = NumericHealthValue.fromJson(json['value']);
    }

    return HealthDataPoint(
      value,
      dataType,
      HealthDataUnit.fromTypeString(json['unit']),
      DateTime.parse(json['date_from']),
      DateTime.parse(json['date_to']),
      platformTypeJsonValueReverse[json['platform_type']]!,
      json['source_id'],
      json['source_name'],
      json['timezone'],
    );
  }

  /// Converts the [HealthDataPoint] to a json object
  Map<String, dynamic> toJson() => {
        'value': value.toJson(),
        'data_type': type.typeToString(),
        'unit': unit.typeToString(),
        'date_from': dateFrom.toIso8601String(),
        'date_to': dateTo.toIso8601String(),
        'platform_type': PlatformTypeJsonValue[platform],
        'source_id': sourceId,
        'source_name': sourceName,
        'timezone': _timezone,
      };

  @override
  String toString() => """${this.runtimeType} - 
    value: ${value.toString()},
    unit: $unit,
    dateFrom: $dateFrom,
    dateTo: $dateTo,
    dataType: $type,
    platform: $platform,
    sourceId: $sourceId,
    sourceName: $sourceName,
    timezone: $_timezone""";

  // / The quantity value of the data point
  HealthValue get value => _value;

  /// The start of the time interval
  DateTime get dateFrom => _dateFrom;

  /// The end of the time interval
  DateTime get dateTo => _dateTo;

  /// The type of the data point
  HealthDataType get type => _type;

  /// The unit of the data point
  HealthDataUnit get unit => _unit;

  /// The software platform of the data point
  PlatformType get platform => _platform;

  /// The data point type as a string
  String get typeString => _type.typeToString();

  /// The data point unit as a string
  String get unitString => _unit.typeToString();

  /// The id of the source from which the data point was fetched.
  String get sourceId => _sourceId;

  /// The name of the source from which the data point was fetched.
  String get sourceName => _sourceName;

  String? get timezone => _timezone;

  @override
  bool operator ==(Object o) {
    return identical(this, o) ||
        o is HealthDataPoint &&
            this.value == o.value &&
            this.unit == o.unit &&
            this.dateFrom == o.dateFrom &&
            this.dateTo == o.dateTo &&
            this.type == o.type &&
            this.platform == o.platform &&
            this.sourceId == o.sourceId &&
            this.sourceName == o.sourceName &&
            this.timezone == o.timezone;
  }

  @override
  int get hashCode => Object.hash(
        value,
        unit,
        dateFrom,
        dateTo,
        type,
        platform,
        sourceId,
        sourceName,
        timezone,
      );
}
