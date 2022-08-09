library pocket_telematics;

import 'dart:async';
import 'dart:developer';
import 'package:flutter/services.dart';
import 'package:flutter_background/flutter_background.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pocket_telematics/Methods/periodic.dart';
import 'package:pocket_telematics/Methods/position_update.dart';
import 'package:pocket_telematics/global_values.dart';

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
    return initialize(
      androidConfig: const FlutterBackgroundAndroidConfig(
        notificationTitle: "Not driving",
        notificationText: "Driving tracking",
        notificationImportance: AndroidNotificationImportance.Default,
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

  Future<bool> initialize({FlutterBackgroundAndroidConfig androidConfig = const FlutterBackgroundAndroidConfig()}) async =>
      const MethodChannel('flutter_background').invokeMethod<bool>('initialize', {
        'android.notificationTitle': androidConfig.notificationTitle,
        'android.notificationText': androidConfig.notificationText,
        'android.notificationImportance': _androidNotificationImportanceToInt(androidConfig.notificationImportance),
        'android.notificationIconName': androidConfig.notificationIcon.name,
        'android.notificationIconDefType': androidConfig.notificationIcon.defType,
        'android.enableWifiLock': androidConfig.enableWifiLock,
      }).then((value) {
        log("new way of doing it returns $value");
        return value == true;
      });

  int _androidNotificationImportanceToInt(AndroidNotificationImportance importance) {
    switch (importance) {
      case AndroidNotificationImportance.High:
        return 1;
      case AndroidNotificationImportance.Max:
        return 2;
      case AndroidNotificationImportance.Default:
      default:
        return 0;
    }
  }
}
