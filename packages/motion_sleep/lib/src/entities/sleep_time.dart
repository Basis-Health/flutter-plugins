part of motion_sleep;

class SleepTime {
  final int startingHours;
  final int startingMinutes;
  final int endingHours;
  final int endingMinutes;

  SleepTime(
    this.startingHours,
    this.startingMinutes,
    this.endingHours,
    this.endingMinutes,
  );

  Map<String, dynamic> toJson() => {
        'startingHours': startingHours,
        'startingMinutes': startingMinutes,
        'endingHours': endingHours,
        'endingMinutes': endingMinutes,
      };
}
