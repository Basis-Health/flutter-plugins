part of motion_sleep;

enum MotionAuthorizationStatus {
    authorized,
    restricted,
    notDetermined,
    denied;

    static MotionAuthorizationStatus fromString(String value) {
      return MotionAuthorizationStatus.values.firstWhere(
            (e) => e.name.toLowerCase() == value.toLowerCase(),
            orElse: () => MotionAuthorizationStatus.notDetermined,
      );
    }
}