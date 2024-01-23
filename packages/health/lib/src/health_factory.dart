part of health;

extension RemoveDuplicates on Iterable<HealthDataPoint> {
  /// Given an array of [HealthDataPoint]s, this method will return the array
  /// without any duplicates.
  List<HealthDataPoint> removeDuplicates()
    => LinkedHashSet.of(this).toList();
}


/// Main class for the Plugin.
///
/// The plugin supports:
///
///  * handling permissions to access health data using the [hasPermissions],
///    [requestAuthorization], [revokePermissions] methods.
///  * reading health data using the [getHealthDataFromTypes] method.
///  * writing health data using the [writeHealthData] method.
///  * accessing total step counts using the [getTotalStepsInInterval] method.
///  * cleaning up dublicate data points via the [removeDuplicates] method.
class HealthFactory {
  static const MethodChannel _channel = MethodChannel('flutter_health');

  static PlatformType _platformType =
      Platform.isAndroid ? PlatformType.ANDROID : PlatformType.IOS;

  /// Check if a given data type is available on the platform
  bool isDataTypeAvailable(final HealthDataType dataType) {
    if (Platform.isAndroid) return dataTypeKeysAndroid.contains(dataType);
    if (Platform.isIOS) return dataTypeKeysIOS.contains(dataType);
    throw UnimplementedError('Unsupported platform ${Platform.operatingSystem}');
  }

  List<HealthDataType> getAvailableDataTypes() {
    if (Platform.isAndroid) return dataTypeKeysAndroidList;
    if (Platform.isIOS) return dataTypeKeysIOSList;
    throw UnimplementedError('Unsupported platform ${Platform.operatingSystem}');
  }

  /// Determines if the data types have been granted with the specified access rights.
  ///
  /// Returns:
  ///
  /// * true - if all of the data types have been granted with the specfied access rights.
  /// * false - if any of the data types has not been granted with the specified access right(s)
  /// * null - if it can not be determined if the data types have been granted with the specified access right(s).
  ///
  /// Parameters:
  ///
  /// * [types]  - List of [HealthDataType] whose permissions are to be checked.
  /// * [permissions] - Optional.
  ///   + If unspecified, this method checks if each HealthDataType in [types] has been granted READ access.
  ///   + If specified, this method checks if each [HealthDataType] in [types] has been granted with the access specified in its
  ///   corresponding entry in this list. The length of this list must be equal to that of [types].
  ///
  ///  Caveat:
  ///
  ///   As Apple HealthKit will not disclose if READ access has been granted for a data type due to privacy concern,
  ///   this method can only return null to represent an undertermined status, if it is called on iOS
  ///   with a READ or READ_WRITE access.
  ///
  ///   On Android, this function returns true or false, depending on whether the specified access right has been granted.
  static Future<bool?> hasPermissions(
    final List<HealthDataType> types, {
    final List<HealthDataAccess>? permissions,
  }) async {
    if (permissions != null && permissions.length != types.length) {
      throw ArgumentError('The lists of types and permissions must be of same length.');
    }

    final copiedTypes = types.toList();
    final permissionsInt = permissions?.map((e) => e.index).toList()
      ?? List<int>.filled(types.length, HealthDataAccess.READ.index, growable: true);

    // these values cannot be changed on iOS and will always return null
    if (Platform.isIOS) {
      for (var idx = 0; idx < copiedTypes.length; ) {
        if (copiedTypes[idx] == HealthDataType.GENDER || copiedTypes[idx] == HealthDataType.DATE_OF_BIRTH) {
          copiedTypes.removeAt(idx);
          permissionsInt.removeAt(idx);
        } else {
          idx++;
        }
      }
    }

    return await _channel.invokeMethod('hasPermissions', {
      'types': copiedTypes.map((type) => type.typeToString()).toList(growable: false),
      'permissions': permissionsInt
    });
  }

  /// Revoke permissions obtained earlier.
  ///
  /// Not supported on iOS and method does nothing.
  static Future<void> revokePermissions() async {
    return await _channel.invokeMethod('revokePermissions');
  }

  /// Requests permissions to access data types in Apple Health or Google Fit.
  ///
  /// Returns true if successful, false otherwise
  ///
  /// Parameters:
  ///
  /// * [types] - a list of [HealthDataType] which the permissions are requested for.
  /// * [permissions] - Optional.
  ///   + If unspecified, each [HealthDataType] in [types] is requested for READ [HealthDataAccess].
  ///   + If specified, each [HealthDataAccess] in this list is requested for its corresponding indexed
  ///   entry in [types]. In addition, the length of this list must be equal to that of [types].
  ///
  ///  Caveat:
  ///
  ///   As Apple HealthKit will not disclose if READ access has been granted for a data type due to privacy concern,
  ///   this method will return **true if the window asking for permission was showed to the user without errors**
  ///   if it is called on iOS with a READ or READ_WRITE access.
  Future<bool?> requestAuthorization(
    final List<HealthDataType> types, {
    final List<HealthDataAccess>? permissions,
  }) async {
    if (permissions != null && permissions.length != types.length) {
      throw ArgumentError('The length of [types] must be same as that of [permissions].');
    }

    if (Platform.isIOS) {
      final sampleTypes = <HealthDataType>[];
      final samplePermissions = <HealthDataAccess>[];
      final objectTypes = <HealthDataType>[];
      for (var idx = 0; idx < types.length; idx++) {
        final type = types[idx];
        if (type == HealthDataType.GENDER || type == HealthDataType.DATE_OF_BIRTH) {
          objectTypes.add(type);
        } else {
          sampleTypes.add(type);
          samplePermissions.add(permissions?[idx] ?? HealthDataAccess.READ);
        }
      }

      final bool? isAuthorized = await _channel.invokeMethod('requestAuthorization', {
        'types': sampleTypes.map((e) => e.name).toList(growable: false),
        'objectTypes': objectTypes.map((e) => e.name).toList(growable: false),
        'permissions': samplePermissions.map((e) => e.index).toList(growable: false)
      });
      return isAuthorized;
    } else {
      final bool? isAuthorized = await _channel.invokeMethod('requestAuthorization', {
        'types': types.map((e) => e.name).toList(growable: false),
        'permissions': permissions == null
          ? List<int>.filled(types.length, HealthDataAccess.READ.index,
              growable: true)
          : permissions.map((permission) => permission.index).toList(growable: false),
      });
      return isAuthorized;
    }
  }

  /// Saves health data into Apple Health or Google Fit.
  ///
  /// Returns true if successful, false otherwise.
  ///
  /// Parameters:
  /// * [value] - the health data's value in double
  /// * [type] - the value's HealthDataType
  /// * [startTime] - the start time when this [value] is measured.
  ///   + It must be equal to or earlier than [endTime].
  /// * [endTime] - the end time when this [value] is measured.
  ///   + It must be equal to or later than [startTime].
  ///   + Simply set [endTime] equal to [startTime] if the [value] is measured only at a specific point in time.
  ///
  /// Values for Sleep and Headache are ignored and will be automatically assigned the coresponding value.
  Future<bool?> writeHealthData(
    final double value,
    final HealthDataType type,
    final DateTime startTime,
    final DateTime endTime, {
    final HealthDataUnit? unit,
  }) async {
    if (type == HealthDataType.WORKOUT) {
      throw ArgumentError('Adding workouts should be done using the writeWorkoutData method.');
    }
    if (startTime.isAfter(endTime)) {
      throw ArgumentError('startTime must be equal or earlier than endTime');
    }

    if (const [
      HealthDataType.HIGH_HEART_RATE_EVENT,
      HealthDataType.LOW_HEART_RATE_EVENT,
      HealthDataType.IRREGULAR_HEART_RATE_EVENT
    ].contains(type)) {
      throw ArgumentError('$type - iOS doesnt support writing this data type in HealthKit');
    }

    // Assign default unit if not specified
    return await _channel.invokeMethod('writeData', <String, dynamic>{
      'value': value,
      'dataTypeKey': type.typeToString(),
      'dataUnitKey': (unit ?? type.unit).typeToString(),
      'startTime': startTime.millisecondsSinceEpoch,
      'endTime': endTime.millisecondsSinceEpoch
    });
  }

  /// Saves audiogram into Apple Health.
  ///
  /// Returns true if successful, false otherwise.
  ///
  /// Parameters:
  /// * [frequencies] - array of frequencies of the test
  /// * [leftEarSensitivities] threshold in decibel for the left ear
  /// * [rightEarSensitivities] threshold in decibel for the left ear
  /// * [startTime] - the start time when the audiogram is measured.
  ///   + It must be equal to or earlier than [endTime].
  /// * [endTime] - the end time when the audiogram is measured.
  ///   + It must be equal to or later than [startTime].
  ///   + Simply set [endTime] equal to [startTime] if the audiogram is measured only at a specific point in time.
  /// * [metadata] - optional map of keys, both HKMetadataKeyExternalUUID and HKMetadataKeyDeviceName are required
  Future<bool?> writeAudiogram(
    final List<double> frequencies,
    final List<double> leftEarSensitivities,
    final List<double> rightEarSensitivities,
    final DateTime startTime,
    final DateTime endTime, {
    final Map<String, dynamic>? metadata,
  }) async {
    if (frequencies.isEmpty || leftEarSensitivities.isEmpty || rightEarSensitivities.isEmpty) {
      throw ArgumentError('frequencies, leftEarSensitivities and rightEarSensitivities can\'t be empty');
    }
    if (frequencies.length != leftEarSensitivities.length ||
        rightEarSensitivities.length != leftEarSensitivities.length) {
      throw ArgumentError('frequencies, leftEarSensitivities and rightEarSensitivities need to be of the same length');
    }
    if (startTime.isAfter(endTime)) {
      throw ArgumentError('startTime must be equal or earlier than endTime');
    }
    if (_platformType == PlatformType.ANDROID) {
      throw UnsupportedError('writeAudiogram is not supported on Android');
    }
    bool? success = await _channel.invokeMethod('writeAudiogram', {
      'frequencies': frequencies,
      'leftEarSensitivities': leftEarSensitivities,
      'rightEarSensitivities': rightEarSensitivities,
      'dataTypeKey': HealthDataType.AUDIOGRAM.typeToString(),
      'startTime': startTime.millisecondsSinceEpoch,
      'endTime': endTime.millisecondsSinceEpoch,
      'metadata': metadata,
    });
    return success;
  }

  /// Fetch a list of health data points based on [types].
  Future<List<HealthDataPoint>> getHealthDataFromTypes(
    final DateTime startTime,
    final DateTime endTime,
    final List<HealthDataType> types, {
    final bool deduplicates = true,
    final bool? threaded
  }) async {
    final data = await _prepareQuery(startTime, endTime, types, deduplicates, threaded);
    return await _parseHealthPointsFromRaw(data, threaded ?? false);
  }

  Future<List<HealthDataPoint>> getBatchHealthDataFromTypes(
    final DateTime startTime,
    final DateTime endTime,
    final List<HealthDataType> types, {
    final bool deduplicates = true,
    final bool? threaded,
    final int? limit,
  }) async {
    final result = await _batchDataQuery(startTime, endTime, types, deduplicates, threaded, limit);
    return await _parseHealthPointsFromRaw(result, threaded);
  }

  Future<List<HealthDevice>> getDevices() async {
    final devices = await _channel.invokeMethod('getDevices');
    return (devices as List).map((e) => HealthDevice.fromMap(e)).toList();
  }

  /// Prepares a query, i.e. checks if the types are available, etc.
  Future<List<Map<String, dynamic>>> _prepareQuery(
    final DateTime startTime,
    final DateTime endTime,
    final List<HealthDataType> dataType,
    final bool deduplicate,
    final bool? threaded,
  ) async {
    // If not implemented on platform, throw an exception
    validateQuery(dataType);
    return await _dataQuery(startTime, endTime, dataType, deduplicate, threaded);
  }
  

  void validateQuery(final List<HealthDataType> dataType) {
    // If not implemented on platform, throw an exception
    for (var type in dataType) {
      if (!isDataTypeAvailable(type)) {
        throw HealthException(dataType, 'Not available on platform $_platformType');
      }
    }
  }

  /// Runs a default data query by querying each type individually.
  Future<List<Map<String, dynamic>>> _dataQuery(
    final DateTime startTime,
    final DateTime endTime,
    final List<HealthDataType> dataType,
    final bool deduplicate,
    final bool? threaded,
  ) async {
    return await Future.wait<Map<String, dynamic>>(dataType.map((e) async {
      final fetchedDataPoints = await _channel.invokeMethod('getData', <String, dynamic>{
        'dataTypeKey': e.typeToString(),
        'dataUnitKey': e.unit.typeToString(),
        'startTime': startTime.millisecondsSinceEpoch,
        'endTime': endTime.millisecondsSinceEpoch,
      });

      assert(fetchedDataPoints is List, 'Fetched data is not a list: ${fetchedDataPoints.runtimeType}');
      assert((fetchedDataPoints as List).every((element) => element is Map), 'Not all elements are maps: ${fetchedDataPoints.map((e) => e.runtimeType)}');

      return <String, dynamic>{
        'dataType': e,
        'dataPoints': (fetchedDataPoints as List?)?.cast<Map>() ?? const <Map>[],
        'deduplicate': deduplicate,
      };
    }).toList(growable: false));
  }

  /// Runs a batch data query by querying each type individually.
  /// 
  Future<List<Map<String, dynamic>>> _batchDataQuery(
    final DateTime startTime,
    final DateTime endTime,
    final List<HealthDataType> queries,
    final bool deduplicate,
    final bool? threaded,
    final int? limit,
  ) async {
    final rawResults = await _channel.invokeMethod('getBatchData', <String, dynamic>{
      'dataTypes': queries.map((e) => {
        'type': e.typeToString(),
        'unit': e.unit.typeToString(),
      }).toList(growable: false),
      'startTime': startTime.millisecondsSinceEpoch,
      'endTime': endTime.millisecondsSinceEpoch,
      if (limit != null) 'limit': limit,
    });

    assert(rawResults is List, 'Results is not a list of maps: ${rawResults.runtimeType}');
    assert((rawResults as List).every((element) => element is Map), 'Not all elements are maps: ${rawResults.map((e) => e.runtimeType)}');

    return (rawResults as List)
      .map((final data) => <String, dynamic>{
        'dataType': HealthDataType.fromTypeString(data['dataType'] as String),
        'dataPoints': data['dataPoints'],
        'deduplicate': deduplicate,
      })
      .toList(growable: false);
  }

  static _parseHealthPointsFromRaw(
    final List<Map<String, dynamic>> results,
    final bool? threaded,
  ) async {
    final totalSize = results.fold<int>(0, (p, v) => p + v.length);
    const threshold = 100;

    // If the no. of data points are larger than the threshold,
    // call the compute method to spawn an Isolate to do the parsing in a separate thread.
    return threaded ?? totalSize >= threshold ? await compute(_parseHealthPoints, results) : _parseHealthPoints(results);
  }

  static List<HealthDataPoint> _parseHealthPoints(
    final List<Map<String, dynamic>> messages,
  ) {
    final results = <HealthDataPoint>[];

    for (final message in messages) {
      final dataType = message['dataType'] as HealthDataType;
      final dataPoints = message['dataPoints'] as List;
      final deduplicate = message['deduplicate'] as bool;
      final unit = dataType.unit;
  
      Iterable<HealthDataPoint> list = dataPoints
        .map<HealthDataPoint>((final e) {
          // Handling different [HealthValue] types
          return HealthDataPoint(
            switch (dataType) {
              HealthDataType.AUDIOGRAM => AudiogramHealthValue.fromJson(e),
              HealthDataType.WORKOUT => WorkoutHealthValue.fromJson(e),
              _ => NumericHealthValue(e['value']),
            },
            dataType,
            unit,
            DateTime.fromMillisecondsSinceEpoch(e['date_from']),
            DateTime.fromMillisecondsSinceEpoch(e['date_to']),
            _platformType,
            e['source_id'],
            e['source_name'],
            e['timezone'],
          );
        });

      if (deduplicate) {
        list = list.removeDuplicates();
      }

      results.addAll(list);
    }
    return results;
  }

  static Future<List<HealthDataPoint>> removeDuplicatesCompute(
    final List<HealthDataPoint> points,
    {final int threshold = 100}
  ) async => points.length > threshold ? await compute(_removeDuplicates, points) : _removeDuplicates(points);

  static List<HealthDataPoint> _removeDuplicates(final List<HealthDataPoint> points) => points.removeDuplicates();

  /// Get the total numbner of steps within a specific time period.
  /// Returns null if not successful.
  ///
  /// Is a fix according to https://stackoverflow.com/questions/29414386/step-count-retrieved-through-google-fit-api-does-not-match-step-count-displayed/29415091#29415091
  Future<int?> getTotalStepsInInterval(
    final DateTime startTime,
    final DateTime endTime,
  ) async {
    final stepsCount = await _channel.invokeMethod<int?>(
      'getTotalStepsInInterval',
      <String, dynamic>{
      'startTime': startTime.millisecondsSinceEpoch,
      'endTime': endTime.millisecondsSinceEpoch
      },
    );
    return stepsCount;
  }

  Future<DateTime?> getDateOfBirth() async {
    if (Platform.isIOS) {
      final dob = await _channel.invokeMethod<String?>('getDateOfBirth');
      return dob == null ? null : DateTime.parse(dob).toLocal();
    } else {
      return null;
    }
  }

  Future<DeviceGender?> getBiologicalGender() async {
    if (Platform.isIOS) {
      final gender = await _channel.invokeMethod<String?>('getBiologicalGender');
      return DeviceGender.values.firstWhere((e) => e.appleValue == gender, orElse: () => DeviceGender.unknown);
    } else {
      return null;
    }
  }

  /// Write workout data to Apple Health
  ///
  /// Returns true if successfully added workout data.
  ///
  /// Parameters:
  /// - [activityType] The type of activity performed
  /// - [start] The start time of the workout
  /// - [end] The end time of the workout
  /// - [totalEnergyBurned] The total energy burned during the workout
  /// - [totalEnergyBurnedUnit] The UNIT used to measure [totalEnergyBurned] *ONLY FOR IOS* Default value is KILOCALORIE.
  /// - [totalDistance] The total distance traveled during the workout
  /// - [totalDistanceUnit] The UNIT used to measure [totalDistance] *ONLY FOR IOS* Default value is METER.
  Future<bool> writeWorkoutData(
    final HealthWorkoutActivityType activityType,
    final DateTime start,
    final DateTime end, {
    final int? totalEnergyBurned,
    final HealthDataUnit totalEnergyBurnedUnit = HealthDataUnit.KILOCALORIE,
    final int? totalDistance,
    final HealthDataUnit totalDistanceUnit = HealthDataUnit.METER,
  }) async {
    // Check that value is on the current Platform
    if (_platformType == PlatformType.IOS && !_isOnIOS(activityType)) {
      throw HealthException(activityType, 'Workout activity type $activityType is not supported on iOS');
    } else if (!_isOnAndroid(activityType)) {
      throw HealthException(activityType, 'Workout activity type $activityType is not supported on Android');
    }
    final success = await _channel.invokeMethod('writeWorkoutData', <String, dynamic>{
      'activityType': activityType.typeToString(),
      'startTime': start.millisecondsSinceEpoch,
      'endTime': end.millisecondsSinceEpoch,
      'totalEnergyBurned': totalEnergyBurned,
      'totalEnergyBurnedUnit': totalEnergyBurnedUnit.name,
      'totalDistance': totalDistance,
      'totalDistanceUnit': totalDistanceUnit.name,
    });
    return success ?? false;
  }

  /// Check if the given [HealthWorkoutActivityType] is supported on the iOS platform
  bool _isOnIOS(final HealthWorkoutActivityType type) {
    // Returns true if the type is part of the iOS set
    return activityTypesiOS.contains(type);
  }

  /// Check if the given [HealthWorkoutActivityType] is supported on the Android platform
  bool _isOnAndroid(final HealthWorkoutActivityType type) {
    // Returns true if the type is part of the Android set
    return activityTypesAndroid.contains(type);
  }
}
