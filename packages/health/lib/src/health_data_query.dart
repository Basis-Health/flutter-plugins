part of health;


/// Anchor queries (iOS only)
class AnchorQuery extends HealthValue {
  /// The new anchor
  final String? anchor;

  /// The type that was used for this query
  final HealthDataType type;

  /// The list of new samples that were added since the anchor was last used
  final List<HealthDataPoint> newSamples;

  /// UUID of the deleted data point
  final List<String> deletedSamples;

  AnchorQuery({
    required this.anchor,
    required this.type,
    required this.newSamples,
    required this.deletedSamples,
  });

  factory AnchorQuery.fromData(final json, final PlatformType platformType) {
    final sampleType = HealthDataType.fromTypeString(json['sampleType']);
    return AnchorQuery(
      anchor: json['anchor'],
      type: sampleType,
      newSamples: (json['newSamples'] as List)
          .map((e) => HealthDataPoint.fromData(e, sampleType, platformType))
          .toList(growable: false),
      deletedSamples: (json['deletedSamples'] as List).cast<String>(),
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        'anchor': anchor,
        'sampleType': type.typeToString(),
        'newSamples': newSamples.map((e) => e.toJson()).toList(),
        'deletedSamples': deletedSamples,
      };
}

class HealthDataQuery extends HealthValue {
  final HealthDataType type;
  final HealthDataUnit? unit;

  HealthDataQuery({required this.type, this.unit});

  @override
  Map<String, dynamic> toJson() => {
        'type': type.typeToString(),
        'unit': unit?.typeToString(),
  };
}