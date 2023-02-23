part of motion_sleep;

class MotionSleep implements MotionSleepInterface {
  static var instance = MotionSleep();

  @override
  Future<List<MotionActivity>> fetchActivities({
    required DateTime start,
    required DateTime end,
  }) {
    // TODO: implement fetchActivities
    throw UnimplementedError();
  }

  @override
  Future<SleepSession> fetchMostRecentSleepSession({
    required DateTime start,
    required DateTime end,
    required SleepTime sleepTime,
  }) {
    // TODO: implement fetchMostRecentSleepSession
    throw UnimplementedError();
  }

  @override
  Future<List<SleepSession>> fetchSleepSessions({
    required DateTime start,
    required DateTime end,
    required SleepTime sleepTime,
  }) {
    // TODO: implement fetchSleepSessions
    throw UnimplementedError();
  }

  @override
  Future<bool> isActivityAvailable() {
    // TODO: implement isActivityAvailable
    throw UnimplementedError();
  }

  @override
  Future<void> requestAuthorization() {
    // TODO: implement requestAuthorization
    throw UnimplementedError();
  }
}
