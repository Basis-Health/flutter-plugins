part of motion_sleep;

class MotionActivity {
  final DateTime startDate;
  final DateTime endDate;
  final bool stationary;
  final bool walking;
  final bool running;
  final bool automotive;
  final bool cycling;
  final int confidence;
  final bool unknown;

  MotionActivity(
    this.startDate,
    this.endDate,
    this.stationary,
    this.walking,
    this.running,
    this.automotive,
    this.cycling,
    this.confidence,
    this.unknown,
  );

  factory MotionActivity.fromJson(Map<String, dynamic> json) {
    return MotionActivity(
      DateTime.fromMillisecondsSinceEpoch(json['startDate']),
      DateTime.fromMillisecondsSinceEpoch(json['endDate']),
      json['stationary'],
      json['walking'],
      json['running'],
      json['automotive'],
      json['cycling'],
      json['confidence'],
      json['unknown'],
    );
  }
}