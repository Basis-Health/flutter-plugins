part of motion_sleep;

class MotionSleep implements MotionSleepInterface {
  static final logger = Logger('MotionSleep');

  static final instance = MotionSleep();
  static const _channel = MethodChannel('motion_sleep');

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
    bool efficient = false
  }) async {
    var response = await _channel.invokeMethod(
      MotionSleepMethod.fetchActivities.name,
      {
        'start': start.millisecondsSinceEpoch,
        'end': end.millisecondsSinceEpoch,
        'efficient': efficient,
      },
    );
    try {
      final activities = (response as List)
          .map(efficient ?
            (e) => MotionActivity.fromEfficientJson((e as Map).cast<String, dynamic>()) :
            (e) => MotionActivity.fromJson((e as Map).cast<String, dynamic>()))
          .toList(growable: false);
      return activities;
    } catch (e, t) {
      logger.severe('error while parsing response $response', e, t);
      return const [];
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
    } catch (e, t) {
      logger.severe('error while parsing response $response', e, t);
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
          .toList(growable: false);
      return sessions;
    } catch (e, t) {
      logger.severe('error while parsing response $response', e, t);
      return const [];
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
}
