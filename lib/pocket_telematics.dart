library pocket_telematics;

import 'dart:async';

import 'package:flutter_background/flutter_background.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pocket_telematics/Methods/periodic.dart';
import 'package:pocket_telematics/Methods/position_update.dart';
import 'package:pocket_telematics/global_values.dart';

class PocketTelematics {
  requestService() {
    Permission.locationWhenInUse.request().then((value) {
      Permission.locationAlways.request().then((pass) {
        Permission.ignoreBatteryOptimizations.request().then((value) {
          //initial notification status + request permission
          FlutterBackground.initialize(
            androidConfig: const FlutterBackgroundAndroidConfig(
              notificationTitle: "Not driving",
              notificationText: "Driving tracking",
              notificationImportance: AndroidNotificationImportance.Default,
            ),
          ).then((result) {
            FlutterBackground.enableBackgroundExecution().then((pass) {
              //triggers on every GPS location update
              positionStream = Geolocator.getPositionStream(
                  locationSettings: const LocationSettings(
                accuracy: LocationAccuracy.bestForNavigation,
              )).listen((position) => positionUpdate(position));

              //Periodic function is for time-depending calculations
              Timer.periodic(const Duration(milliseconds: 100), (t) {
                //function is required only when driving is detected
                if (activePeriodic) {
                  periodic();
                }
              });
            });
          });
        });
      });
    });
  }

  terminateService() async {
    FlutterBackground.disableBackgroundExecution();
    try {
      positionStream.cancel();
    } catch (e) {}
  }
}
