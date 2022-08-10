import 'package:flutter_background/flutter_background.dart';
import 'package:geolocator/geolocator.dart';
import 'package:pocket_telematics/Methods/caclulations.dart';
import 'package:pocket_telematics/Methods/reset_function.dart';
import '../global_values.dart';
import 'data_processing.dart';

void positionUpdate(Position newPosition) {
  position = newPosition;
  if (!initialPositionAvailable) {
    Geolocator.getCurrentPosition().then((value) {
      initialPosition = value;
      initialPositionAvailable = true;
    });
  } else if (position.accuracy < 50) {
    difference = Geolocator.distanceBetween(initialPosition.latitude, initialPosition.longitude, position.latitude, position.longitude);
    newVelocity = convertVelocity(position.speed);
    initialPosition = position;
    if (!recordingStarted) {
      if (newVelocity < 20) {
        resetFunction();
      } else {
        velocityChain.add(newVelocity);
        if (velocityChain.length == 5) {
          //here the periodic function is triggered
          activePeriodic = true;
          recordStartTime = DateTime.now();
          recordingStarted = true;

          //Setting notification status
          FlutterBackground.initialize(
            androidConfig: const FlutterBackgroundAndroidConfig(
              notificationTitle: "Driving detected",
              notificationText: "Driving tracking",
              notificationImportance: AndroidNotificationImportance.Default,
              enableWifiLock: true,
            ),
          ).then(
            (value) => FlutterBackground.enableBackgroundExecution(),
          );
        }
      }
    } else if (newVelocity < 435.3 && recordingStarted) {
      accelerationList.add(calculateAcceleration(velocity, newVelocity, timer - position.speedAccuracy));
      if (accelerationList.last > 3.8 || accelerationList.last < -2.91) grade--;
      timer = position.speedAccuracy;
      velocity = newVelocity;
      if (velocity > highestVelocity) {
        highestVelocity = velocity;
      }
      dataProcessing();
    }
  }
}
