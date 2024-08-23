part of motion_sleep;

enum MotionAuthorizationStatus {
    authorized,
    restricted,
    notDetermined,
    denied;

    static MotionAuthorizationStatus fromString(String value) {
      final lowerCaseValue = value.toLowerCase();
      return MotionAuthorizationStatus.values.firstWhere(
            (e) => e.name.toLowerCase() == lowerCaseValue,
            orElse: () => MotionAuthorizationStatus.notDetermined,
      );
    }
}