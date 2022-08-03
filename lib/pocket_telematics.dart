library pocket_telematics;

import 'dart:async';

import 'package:flutter_background/flutter_background.dart';
import 'package:geolocator/geolocator.dart';
import 'package:path/path.dart';
import 'package:pocket_telematics/Methods/periodic.dart';
import 'package:pocket_telematics/Methods/position_update.dart';
import 'package:pocket_telematics/global_values.dart';
import 'package:sqflite/sqflite.dart';

class PocketTelematics {
  requestService() async {
    await Geolocator.requestPermission();

    database = getDatabasesPath().then(
      (path) => openDatabase(join(path, 'data.db'), version: 1, onCreate: (db, version) {
        //DB helper "CREATE" is the equivalent of SQLite "CREATE IF NOT EXISTS"
        db.execute(
            "CREATE TABLE data (date TEXT, velocityData TEXT, angleList TEXT, accelerationList TEXT, polylineList TEXT, drivingSummary TEXT, bottomInfo TEXT, grade TEXT)");
      }),
    );

    //initial notification status
    FlutterBackground.initialize(
      androidConfig: const FlutterBackgroundAndroidConfig(
        notificationTitle: "Not driving",
        notificationText: "Driving tracking",
        notificationImportance: AndroidNotificationImportance.Default,
      ),
    ).then((result) => FlutterBackground.enableBackgroundExecution().then((pass) => backgroundService()));
  }

  backgroundService() {
    //function that triggers on every GPS location update
    Geolocator.getPositionStream(
        locationSettings: const LocationSettings(
      accuracy: LocationAccuracy.bestForNavigation,
    )).listen((_position) => positionUpdate(_position));

    //Periodic function is mainly for UI updates and will not be required for background usage
    Timer.periodic(const Duration(milliseconds: 100), (t) {
      if (activePeriodic) {
        periodic();
      }
    });
  }
}
