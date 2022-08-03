import 'dart:developer';

import 'package:flutter_background/flutter_background.dart';
import 'package:pocket_telematics/Data/save_model.dart';
import 'package:pocket_telematics/Methods/reset_function.dart';

import '../global_values.dart';
import 'caclulations.dart';
import 'update_driving_summary.dart';

//this code is responsible for updating the UI, make estimations that depend on time and manage data storage

void periodic() {
  timer += 10;
  //as long as the velocity is lower than what should be considered for certain amount of time
  //the program will update the not-driving data
  if (velocity < minimumConsideredSpeed) {
    notDrivingTime += 0.1;
    if (notDrivingTime >= 1) updateDrivingSummaryNotDriving();
    if (notDrivingTime == 0.1) {
      bottomInfoText = "";
      bottomInfoText += 'Highest Speed: ${highestVelocity.toStringAsFixed(2)} km/h\n';
      bottomInfoText += 'Time Passed: ${time.toStringAsFixed(2)} m\n';
      bottomInfoText += 'Distance: ${distance.toStringAsFixed(2)} m\n';
      bottomInfoText += 'Average Velocity: ${averageVelocity.toStringAsFixed(2)} km/h\n';
      bottomInfoText += 'Peak Average Velocity: ${peakAverageVelocity.toStringAsFixed(2)} km/h';

      //every time the vehicle is considered to have stopped a save model is created
      //if the stopping time reaches two minutes (as per now) that save model will be stored
      //and the two minute stopping data is not going to be included
      saveModel = SaveModel(
        velocityData: listDoubleToString(velocityList.map((e) => e[1]).toList()),
        angleList: listDoubleToString(angleList),
        accelerationList: listDoubleToString(accelerationList),
        polylineList: latlngListToString(polylineList),
        drivingSummary: directionContent.join(","),
        bottomInfoText: bottomInfoText,
        grade: (grade / 10).toString(),
      );
      recordEndTime = DateTime.now();
    }

    //once driving is not detected for two minutes - the driving data is stored
    else if (notDrivingTime > 120 && recordingStarted) {
      database.then((db) async {
        await db.transaction((txn) async {
          String date = "${recordStartTime.toString().substring(0, 16)} - ${recordEndTime.toString().substring(0, 16)}";
          await txn.rawInsert(
              'INSERT INTO data (date, velocityData, angleList, accelerationList, polylineList, drivingSummary, bottomInfo, grade) VALUES ("$date", "${saveModel.velocityData}", "${saveModel.angleList}", "${saveModel.accelerationList}", "${saveModel.polylineList}", "${saveModel.drivingSummary}", "${saveModel.bottomInfoText}", "${saveModel.grade}")');
        });
        //the periodic interval is set back to once a day to maintain ram
        activePeriodic = false;
      });

      log(saveModel.drivingSummary);
      log(saveModel.bottomInfoText);
      log(saveModel.grade);

      //initialize the background task notification to new condition
      FlutterBackground.initialize(
        androidConfig: const FlutterBackgroundAndroidConfig(
          notificationTitle: "Not driving",
          notificationText: "Driving tracking",
          notificationImportance: AndroidNotificationImportance.Default,
        ),
      ).then(
        (value) => FlutterBackground.enableBackgroundExecution(),
      );

      //every time new data is store all the variables are being reset to default values
      resetFunction();
    }
  }
  if (recordingStarted) time += 0.00166667;
  if (velocity >= minimumConsideredSpeed) {
    averageVelocity = calculateAverageVelocity(distance, time);
  }
  if (averageVelocity > peakAverageVelocity) {
    peakAverageVelocity = averageVelocity;
  }
}
