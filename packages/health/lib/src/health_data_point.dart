part of health;

/// A [HealthDataPoint] object corresponds to a data point capture from
/// GoogleFit or Apple HealthKit with a [HealthValue] as value.
class HealthDataPoint extends HealthValue {
  final String uuid;
  final HealthValue value;
  final HealthDataType type;
  final HealthDataUnit unit;
  final DateTime dateFrom;
  final DateTime dateTo;
  final PlatformType platform;
  final String sourceId;
  final String sourceName;
  final String? timezone;

  const HealthDataPoint(
    this.uuid,
    this.value,
    this.type,
    this.unit,
    this.dateFrom,
    this.dateTo,
    this.platform,
    this.sourceId,
    this.sourceName,
    this.timezone,
  );

  factory HealthDataPoint.fromData(final dynamic json, final HealthDataType dataType, final PlatformType _platformType) {
     // Handling different [HealthValue] types
    return HealthDataPoint(
      json['uuid'],
      switch (dataType) {
        HealthDataType.AUDIOGRAM => AudiogramHealthValue.fromJson(json),
        HealthDataType.WORKOUT => WorkoutHealthValue.fromJson(json),
        _ => NumericHealthValue(json['value']),
      },
      dataType,
      dataType.unit,
      DateTime.fromMillisecondsSinceEpoch(json['date_from']),
      DateTime.fromMillisecondsSinceEpoch(json['date_to']),
      _platformType,
      json['source_id'],
      json['source_name'],
      json['timezone'],
    );
  }

  /// Converts a json object to the [HealthDataPoint]
  factory HealthDataPoint.fromJson(final dynamic json) {
    final dataType = HealthDataType.fromTypeString(json['data_type']);
    return HealthDataPoint(
      json['uuid'],
      switch (dataType) {
        HealthDataType.AUDIOGRAM => AudiogramHealthValue.fromJson(json['value']),
        HealthDataType.WORKOUT => WorkoutHealthValue.fromJson(json['value']),
        _ => NumericHealthValue.fromJson(json['value']),
      },
      dataType,
      HealthDataUnit.fromTypeString(json['unit']),
      DateTime.parse(json['date_from']).toLocal(),
      DateTime.parse(json['date_to']).toLocal(),
      platformTypeJsonValueReverse[json['platform_type']]!,
      json['source_id'],
      json['source_name'],
      json['timezone'],
    );
  }

  /// Converts the [HealthDataPoint] to a json object
  @override
  Map<String, dynamic> toJson() => {
        'uuid': uuid,
        'value': value.toJson(),
        'data_type': type.typeToString(),
        'unit': unit.typeToString(),
        'date_from': dateFrom.toUtc().toIso8601String(),
        'date_to': dateTo.toUtc().toIso8601String(),
        'platform_type': PlatformTypeJsonValue[platform],
        'source_id': sourceId,
        'source_name': sourceName,
        'timezone': timezone,
      };

  @override
  String toString() => jsonEncode(toJson());

  String get typeString => type.typeToString();
  String get unitString => unit.typeToString();

  @override
  bool operator ==(final Object o) =>
      identical(this, o) ||
      o is HealthDataPoint &&
        uuid == o.uuid &&
        value == o.value &&
        unit == o.unit &&
        dateFrom == o.dateFrom &&
        dateTo == o.dateTo &&
        type == o.type &&
        platform == o.platform &&
        sourceId == o.sourceId &&
        sourceName == o.sourceName &&
        timezone == o.timezone;

  @override
  int get hashCode => uuid.hashCode;
}
