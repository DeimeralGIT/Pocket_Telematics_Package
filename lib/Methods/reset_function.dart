import '../global_values.dart';

//code responsible for resetting all values to default
//is called when new data is stored, or if driving was falsely detected
void resetFunction() {
  highestVelocity = 0.0;
  time = 0.0;
  distance = 0.0;
  averageVelocity = 0.0;
  peakAverageVelocity = 0.0;
  highestAccuracy = 0.0;
  angleList.clear();
  velocityList.clear();
  polylineList.clear();
  corneringAngle = 0.0;
  corneringStartAngle = 0.0;
  cornerDriveDistance = 0.0;
  notDrivingTime = 0.0;
  directionContent = ["Driving Summary"];
  straightDriveDistance = 0.0;
  timer = 0.0;
  accelerationList.clear();
  velocityChain.clear();
  recordingStarted = false;
  maneuverSpeed.clear();
  grade = 100;
}
