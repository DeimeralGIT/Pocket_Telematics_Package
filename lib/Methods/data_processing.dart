import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pocket_telematics/Methods/caclulations.dart';

import '../global_values.dart';
import 'is_straight_driving.dart';
import 'update_driving_summary.dart';

void dataProcessing() {
  velocityList.add([time, velocity]);
  angleList.add(position.heading);

  //detecting possible driving by checking velocity
  if (velocity >= minimumConsideredSpeed) {
    notDrivingTime = 0.0;

    //checks if vehicle is driving straight
    if (isStraightDriving()) {
      distance += difference;
      maneuverSpeed.add(velocity);
      straightDriveDistance += difference;
      updateDrivingSummaryStraight();

      //assuming that a vehicle cannot do a 360 degree turn during one GPS update,
      //the event of turning will be dismissed
      if (corneringAngle < 360) {
        polylineList.add(LatLng(position.latitude, position.longitude));
      }

      //if vehicle starts driving straight after doing a corner,
      //the cornering details are calculated
      if (corneringAngle != 0) {
        double coefficient = (getAverageVelocity(maneuverSpeed) * getAverageVelocity(maneuverSpeed) * corneringAngle) / cornerDriveDistance;
        //the coefficient of turn depends on how rapid and careless the turn was conducted
        //the average should be 300-400 but higher than 1500 should be considered reckless
        if (coefficient > 1500) grade -= 2;
        updateDrivingSummaryCornering(coefficient.toStringAsFixed(2));
      }
      distance += cornerDriveDistance;

      //if device is driving straight after a turn, all turn variables are reset
      corneringAngle = 0.0;
      corneringStartAngle = 0.0;
      cornerDriveDistance = 0.0;
      maneuverSpeed = [];
    }

    //the cornering data is gathered until vehicle starts driving straight again
    else {
      if (corneringAngle < 360) {
        polylineList.add(LatLng(position.latitude, position.longitude));
        cornerDriveDistance += difference;
      }
      double angleDifference = (angleList[angleList.length - 2] - angleList.last).abs();
      if (angleDifference > 360 - angleDifference) {
        angleDifference = 360 - angleDifference;
      }
      if (corneringAngle == 0) maneuverSpeed = [];
      corneringAngle += angleDifference;
      maneuverSpeed.add(velocity);
    }
  }

  //Since the results might be false because of bad GPS signals, the overall accuracy
  //is stored as well as the highest accuracy. This way in the future the final data
  //accuracy can be estimated
  if (position.accuracy > highestAccuracy) {
    highestAccuracy = position.accuracy;
  }
}
