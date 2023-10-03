part of motion_sleep;

class MotionSleep implements MotionSleepInterface {
  static var instance = MotionSleep();
  static const MethodChannel _channel = MethodChannel('motion_sleep');

  @override
  Future<MotionAuthorizationStatus> fetchAuthorizationStatus() {
    return _channel.invokeMethod(
      MotionSleepMethod.fetchAuthorizationStatus.name,
    ).then((value) => MotionAuthorizationStatus.fromString(value as String));
  }

  @override
  Future<List<MotionActivity>> fetchActivities({
    required DateTime start,
    required DateTime end,
  }) async {
    var response = await _channel.invokeMethod(
      MotionSleepMethod.fetchActivities.name,
      {
        'start': start.millisecondsSinceEpoch,
        'end': end.millisecondsSinceEpoch,
      },
    );
    try {
      response = jsonDecode(jsonEncode(response));
      final activities = (response as List)
          .map((e) => MotionActivity.fromJson(e as Map<String, dynamic>))
          .toList();
      return activities;
    } catch (e) {
      _log('$e while parsing response $response');
      return [];
    }
  }

  @override
  Future<SleepSession?> fetchMostRecentSleepSession({
    required DateTime start,
    required DateTime end,
    required SleepTime sleepTime,
  }) async {
    var response = await _channel.invokeMethod(
      MotionSleepMethod.fetchRecentSleepSession.name,
      {
        'start': start.millisecondsSinceEpoch,
        'end': end.millisecondsSinceEpoch,
        'sleepTime': sleepTime.toJson(),
      },
    );
    try {
      response = jsonDecode(jsonEncode(response));
      return SleepSession.fromJson(response as Map<String, dynamic>);
    } catch (e) {
      _log(e.toString());
      return null;
    }
  }

  @override
  Future<List<SleepSession>> fetchSleepSessions({
    required DateTime start,
    required DateTime end,
    required SleepTime sleepTime,
  }) async {
    var response = await _channel.invokeMethod(
      MotionSleepMethod.fetchSleepSessions.name,
      {
        'start': start.millisecondsSinceEpoch,
        'end': end.millisecondsSinceEpoch,
        'sleepTime': sleepTime.toJson(),
      },
    );

    try {
      response = jsonDecode(jsonEncode(response));
      final sessions = (response as List)
          .map((e) => SleepSession.fromJson(e as Map<String, dynamic>))
          .toList();
      return sessions;
    } catch (e) {
      _log('$e while parsing response $response');
      return [];
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
