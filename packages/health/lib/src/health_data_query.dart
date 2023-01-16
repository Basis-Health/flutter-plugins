part of health;

class HealthDataQuery {
  final HealthDataType type;
  final HealthDataUnit? unit;

  HealthDataQuery({required this.type, this.unit});

  /// Converts the [HealthDataQuery] to a json object
  Map<String, dynamic> toJson() => {
        'data_type': type.typeToString(),
        'unit': unit?.typeToString(),
  };
}