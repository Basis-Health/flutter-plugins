part of motion_sleep;

class MotionSleep implements MotionSleepInterface {
  static var instance = MotionSleep();
  static const MethodChannel _channel = MethodChannel('motion_sleep');

  @override
  Future<List<MotionActivity>> fetchActivities({
    required DateTime start,
    required DateTime end,
  }) async {
    final response = await _channel.invokeMethod(
      MotionSleepMethod.fetchActivities.name,
      {
        'start': start.millisecondsSinceEpoch,
        'end': end.millisecondsSinceEpoch,
      },
    );
    try {
      final activities = (response as List)
          .map((e) => MotionActivity.fromJson(e as Map<String, dynamic>))
          .toList();
      return activities;
    } catch (e) {
      _log('$e while parsing response $response');
      rethrow;
    }
  }

  @override
  Future<SleepSession> fetchMostRecentSleepSession({
    required DateTime start,
    required DateTime end,
    required SleepTime sleepTime,
  }) async {
    final response = await _channel.invokeMethod(
      MotionSleepMethod.fetchRecentSleepSession.name,
      {
        'start': start.millisecondsSinceEpoch,
        'end': end.millisecondsSinceEpoch,
        'sleepTime': sleepTime.toJson(),
      },
    );
    try {
      return SleepSession.fromJson(response as Map<String, dynamic>);
    } catch (e) {
      _log('$e while parsing response $response');
      rethrow;
    }
  }

  @override
  Future<List<SleepSession>> fetchSleepSessions({
    required DateTime start,
    required DateTime end,
    required SleepTime sleepTime,
  }) async {
    final response = await _channel.invokeMethod(
      MotionSleepMethod.fetchSleepSessions.name,
      {
        'start': start.millisecondsSinceEpoch,
        'end': end.millisecondsSinceEpoch,
        'sleepTime': sleepTime.toJson(),
      },
    );
    try {
      final sessions = (response as List)
          .map((e) => SleepSession.fromJson(e as Map<String, dynamic>))
          .toList();
      return sessions;
    } catch (e) {
      _log('$e while parsing response $response');
      rethrow;
    }
  }

  @override
  Future<bool> isActivityAvailable() async => await _channel.invokeMethod(
        MotionSleepMethod.isActivityAvailable.name,
      );

  @override
  Future<void> requestAuthorization() async => await _channel.invokeMethod(
        MotionSleepMethod.requestAuthorization.name,
      );

  _log(String message) => log(message, name: runtimeType.toString());
}
