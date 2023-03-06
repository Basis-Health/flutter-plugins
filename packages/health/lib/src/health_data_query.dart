part of health;

class HealthDataQuery {
  final HealthDataType type;
  final HealthDataUnit? unit;

  HealthDataQuery({required this.type, this.unit});

  Map<String, dynamic> toJson() => {
        'type': type.typeToString(),
        'unit': unit?.typeToString(),
  };
}