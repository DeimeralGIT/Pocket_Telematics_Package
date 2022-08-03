import '../global_values.dart';

bool isStraightDriving() {
  double averageAngle = 0.0;
  double angleDifference = 0.0;
  //check if vehicle was driving straight for $directionSequenceLength times of GPS updates
  if (angleList.length <= directionSequenceLength) return true;
  for (int i = angleList.length - directionSequenceLength; i < angleList.length; i++) {
    angleDifference = (angleList[i - 1] - angleList[i]).abs();

    //since angles return a number 0-360, and a 2 degree turn can be calculated as 358 degree turn
    //the code makes sure it takes the smaller degree
    if (angleDifference > 180) {
      angleDifference = 360 - angleDifference;
    }
    averageAngle += angleDifference;
  }
  //checks if the angel of current update is small enough to consider the driving straight
  if (averageAngle < minimumConsideredAngle) {
    return true;
  }
  //otherwise the cornering data collection will begin
  else if (corneringStartAngle == 0) {
    corneringStartAngle = angleList[angleList.length - directionSequenceLength + 1];
  }
  return false;
}
