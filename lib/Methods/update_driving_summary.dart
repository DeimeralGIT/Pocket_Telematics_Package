import '../global_values.dart';
import 'caclulations.dart';

void updateDrivingSummaryStraight() {
  String result = "Straight Driving for ${straightDriveDistance.toStringAsFixed(2)} meters at ${getAverageVelocity(maneuverSpeed).toStringAsFixed(2)}";
  directionContent.last.startsWith("Straight") ? directionContent.last = result : directionContent.add(result);
}

void updateDrivingSummaryCornering(String coefficient) {
  directionContent.add("Made a ${corneringAngle.toStringAsFixed(2)}^ turn with coefficient of $coefficient");
  straightDriveDistance = 0.0;
}

void updateDrivingSummaryNotDriving() {
  if (directionContent.length > 1) {
    String result = "Not Driving for ${notDrivingTime.toStringAsFixed(1)} seconds";
    directionContent.last.startsWith("Not") ? directionContent.last = result : directionContent.add(result);
  }
}
