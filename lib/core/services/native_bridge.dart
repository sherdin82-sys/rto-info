import 'package:flutter/services.dart';

import '../constants/app_constants.dart';

/// NativeBridge provides type-safe Dart bindings to the native Android
/// Kotlin MethodChannel (`com.rtoinfo.app/native`) following NoteFlow architecture.
class NativeBridge {
  static const MethodChannel _channel = MethodChannel('com.rtoinfo.app/native');

  /// Get application version from Android native runtime
  static Future<String> getAppVersion() async {
    try {
      final String? version = await _channel.invokeMethod<String>(
        'getAppVersion',
      );
      return version ?? AppConstants.appVersion;
    } catch (_) {
      return AppConstants.appVersion;
    }
  }

  /// Get native device specifications (manufacturer, model, SDK level)
  static Future<Map<String, dynamic>> getDeviceInfo() async {
    try {
      final Map<dynamic, dynamic>? info = await _channel
          .invokeMethod<Map<dynamic, dynamic>>('getDeviceInfo');
      if (info != null) {
        return info.cast<String, dynamic>();
      }
    } catch (_) {}
    return {
      'manufacturer': 'Android Device',
      'model': 'Generic',
      'sdk': 34,
      'release': '14',
    };
  }

  /// Get current device battery percentage
  static Future<int> getBatteryLevel() async {
    try {
      final int? battery = await _channel.invokeMethod<int>('getBatteryLevel');
      return battery ?? -1;
    } catch (_) {
      return -1;
    }
  }

  /// Check active network internet capability natively
  static Future<bool> isNetworkAvailable() async {
    try {
      final bool? isConnected = await _channel.invokeMethod<bool>(
        'isNetworkAvailable',
      );
      return isConnected ?? true;
    } catch (_) {
      return true;
    }
  }

  /// Open native Android share sheet with vehicle RC or challan details
  static Future<bool> shareVehicleDetails(
    String text, {
    String subject = 'RTO Vehicle Details',
  }) async {
    try {
      final bool? success = await _channel.invokeMethod<bool>(
        'shareVehicleDetails',
        {'text': text, 'subject': subject},
      );
      return success ?? false;
    } catch (_) {
      return false;
    }
  }
}
