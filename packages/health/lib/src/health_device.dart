part of health;

class HealthDevice {
  final String sourceId;
  final DateTime lastSynced;
  final List<String> sourceNames;

  HealthDevice(this.sourceId, this.lastSynced, this.sourceNames);

  HealthDevice.fromMap(Map<String, dynamic> map)
      : sourceId = map['sourceId'],
        lastSynced = DateTime.fromMillisecondsSinceEpoch(map['lastSynced']),
        sourceNames = List<String>.from(map['sourceNames']);
}