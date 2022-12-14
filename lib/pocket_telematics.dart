library pocket_telematics;

import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pocket_telematics/Methods/periodic.dart';
import 'package:pocket_telematics/Methods/position_update.dart';
import 'package:pocket_telematics/global_values.dart';
import 'package:flutter_background/flutter_background.dart';

class PocketTelematics {
  Future<bool> requestService() async => Permission.locationWhenInUse.request().then(
        (locWhenInUse) => Permission.locationAlways.request().then((locAlways) {
          return locAlways.isGranted ? _startBackgroundService() : checkPermissions();
        }),
      );

  terminateService() async {
    FlutterBackground.disableBackgroundExecution();
    try {
      positionStream.cancel();
    } catch (e) {}
  }

  Future<bool> checkPermissions() async =>
      Permission.locationAlways.isGranted.then((locationPermission) => locationPermission && FlutterBackground.isBackgroundExecutionEnabled);

  Future<bool> _startBackgroundService() {
    //initial notification status + request permission
    return FlutterBackground.initialize(
      androidConfig: const FlutterBackgroundAndroidConfig(
        notificationTitle: "Not driving",
        notificationText: "Driving tracking",
        notificationImportance: AndroidNotificationImportance.Default,
        enableWifiLock: true,
      ),
    ).then((flutterBackInitialized) {
      return flutterBackInitialized
          ? FlutterBackground.enableBackgroundExecution().then(
              (pass) {
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

                return true;
              },
            )
          : checkPermissions();
    });
  }
}
