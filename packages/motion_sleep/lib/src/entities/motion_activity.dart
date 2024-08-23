part of motion_sleep;

@immutable
final class MotionActivity {
  final DateTime startDate;
  final DateTime endDate;
  final bool stationary;
  final bool walking;
  final bool running;
  final bool automotive;
  final bool cycling;
  final int confidence;
  final bool unknown;

  const MotionActivity({
    required this.startDate,
    required this.endDate,
    required this.stationary,
    required this.walking,
    required this.running,
    required this.automotive,
    required this.cycling,
    required this.confidence,
    required this.unknown,
  });

  factory MotionActivity.fromEfficientJson(Map<String, dynamic> json) {
    final data = json['d'];
    return MotionActivity(
      startDate: DateTime.fromMillisecondsSinceEpoch(json['s']),
      endDate: DateTime.fromMillisecondsSinceEpoch(json['e']),
      stationary: data & 1 == 1,
      walking: data & 2 == 2,
      running: data & 4 == 4,
      automotive: data & 8 == 8,
      cycling: data & 16 == 16,
      unknown: data & 32 == 32,
      // confidence is actually 2 bits
      confidence: (data >> 6) & 3, // 0b11
    );
  }

  factory MotionActivity.fromJson(Map<String, dynamic> json) {
    return MotionActivity(
      startDate: DateTime.fromMillisecondsSinceEpoch(json['startDate']),
      endDate: DateTime.fromMillisecondsSinceEpoch(json['endDate']),
      stationary: json['stationary'],
      walking: json['walking'],
      running: json['running'],
      automotive: json['automotive'],
      cycling: json['cycling'],
      confidence: json['confidence'],
      unknown: json['unknown'],
    );
  }
}