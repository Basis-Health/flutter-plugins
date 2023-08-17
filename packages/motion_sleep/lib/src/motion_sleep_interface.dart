part of motion_sleep;

abstract class MotionSleepInterface {
  Future<MotionAuthorizationStatus> fetchAuthorizationStatus();
  Future<bool> isActivityAvailable();
  Future<void> requestAuthorization();
  Future<SleepSession?> fetchMostRecentSleepSession({
    required DateTime start,
    required DateTime end,
    required SleepTime sleepTime,
  });
  Future<List<SleepSession>> fetchSleepSessions({
    required DateTime start,
    required DateTime end,
    required SleepTime sleepTime,
  });
  Future<List<MotionActivity>> fetchActivities({
    required DateTime start,
    required DateTime end,
  });
}
