import 'dart:async';

import 'package:flutter/services.dart';
import 'package:pocket_telematics/background_manager/android_config.dart';

class FlutterBackground {
  static const MethodChannel _channel = MethodChannel('flutter_background');

  static bool _isInitialized = false;
  static bool _isBackgroundExecutionEnabled = false;

  static Future<bool> initialize({FlutterBackgroundAndroidConfig androidConfig = const FlutterBackgroundAndroidConfig()}) async =>
      await _channel.invokeMethod<bool>('initialize', {
        'android.notificationTitle': androidConfig.notificationTitle,
        'android.notificationText': androidConfig.notificationText,
        'android.notificationImportance': _androidNotificationImportanceToInt(androidConfig.notificationImportance),
        'android.notificationIconName': androidConfig.notificationIcon.name,
        'android.notificationIconDefType': androidConfig.notificationIcon.defType,
        'android.enableWifiLock': androidConfig.enableWifiLock,
      }).then((value) {
        _isInitialized = value == true;
        return _isInitialized;
      });

  static Future<bool> get hasPermissions async {
    return await _channel.invokeMethod<bool>('hasPermissions') == true;
  }

  static Future<bool> enableBackgroundExecution() async {
    if (_isInitialized) {
      final success = await _channel.invokeMethod<bool>('enableBackgroundExecution');
      _isBackgroundExecutionEnabled = true;
      return success == true;
    } else {
      throw Exception('FlutterBackground plugin must be initialized before calling enableBackgroundExecution()');
    }
  }

  static Future<bool> disableBackgroundExecution() async {
    if (_isInitialized) {
      final success = await _channel.invokeMethod<bool>('disableBackgroundExecution');
      _isBackgroundExecutionEnabled = false;
      return success == true;
    } else {
      throw Exception('FlutterBackground plugin must be initialized before calling disableBackgroundExecution()');
    }
  }

  static bool get isBackgroundExecutionEnabled => _isBackgroundExecutionEnabled;

  static int _androidNotificationImportanceToInt(AndroidNotificationImportance importance) {
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
