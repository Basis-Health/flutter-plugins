part of motion_sleep;

class SleepSession {
  final SleepSessionType type;
  final DateTime startDate;
  final DateTime endDate;
  final SleepSessionSource source;

  SleepSession(
    this.type,
    this.startDate,
    this.endDate,
    this.source,
  );

  factory SleepSession.fromJson(Map<String, dynamic> json) {
    return SleepSession(
      SleepSessionType.fromString(json['type']),
      DateTime.fromMillisecondsSinceEpoch(json['startDate']),
      DateTime.fromMillisecondsSinceEpoch(json['endDate']),
      SleepSessionSource.fromString(json['source']),
    );
  }
}

enum SleepSessionType {
  asleep,
  inBed,
  awake,
  unknown;

  static SleepSessionType fromString(String type) {
    return SleepSessionType.values.firstWhere(
      (element) => element.toString() == type,
      orElse: () => SleepSessionType.unknown,
    );
  }
}

enum SleepSessionSource {
  motion,
  manual,
  unknown;

  static SleepSessionSource fromString(String source) {
    return SleepSessionSource.values.firstWhere(
      (element) => element.toString() == source,
      orElse: () => SleepSessionSource.unknown,
    );
  }
}
