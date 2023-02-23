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
}

enum SleepSessionType {
  asleep,
  inBed,
  awake;
}

enum SleepSessionSource {
  motion,
  manual;
}
