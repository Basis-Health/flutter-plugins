import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:motion_sleep/motion_sleep.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _motionSleepPlugin = MotionSleep();
  final _startDate = DateTime.now().subtract(const Duration(days: 41));
  final _endDate = DateTime.now();
  final _sleepTime = SleepTime(22, 0, 6, 0);
  @override
  void initState() {
    super.initState();
    _motionSleepPlugin.fetchAuthorizationStatus().then((value) => print(value));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Column(
            children: [
              ElevatedButton(
                onPressed: () async {
                  final activities = await _motionSleepPlugin.fetchActivities(
                    start: _startDate,
                    end: _endDate,
                  );
                  print(activities);
                },
                child: const Text('Fetch Activities'),
              ),
              ElevatedButton(
                onPressed: () async {
                  final sleepSession =
                      await _motionSleepPlugin.fetchMostRecentSleepSession(
                    start: _startDate,
                    end: _endDate,
                    sleepTime: SleepTime(22, 0, 6, 0),
                  );
                  print(sleepSession);
                },
                child: const Text('Fetch Most Recent Sleep Session'),
              ),
              ElevatedButton(
                onPressed: () async {
                  final sleepSessions =
                      await _motionSleepPlugin.fetchSleepSessions(
                    start: _startDate,
                    end: _endDate,
                    sleepTime: SleepTime(22, 0, 6, 0),
                  );
                  print(sleepSessions);
                },
                child: const Text('Fetch Sleep Sessions'),
              ),
              ElevatedButton(
                onPressed: () async {
                  final isAvailable =
                      await _motionSleepPlugin.isActivityAvailable();
                  print(isAvailable);
                },
                child: const Text('Is Activity Available'),
              ),
              ElevatedButton(
                onPressed: () async {
                  final isAuthorized =
                      await _motionSleepPlugin.requestAuthorization();
                },
                child: const Text('Request Authorization'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
