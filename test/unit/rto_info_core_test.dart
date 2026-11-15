import 'dart:io';
import '../../lib/core/constants/app_constants.dart';
import '../../lib/core/utils/vehicle_number_validator.dart';
import '../../lib/app/localization/app_strings.dart';

void main() {
  print('=====================================================');
  print('🚗 RTO INFO - Core Architecture & Unit Test Suite');
  print('=====================================================\n');

  int totalPassed = 0;

  void test(String name, void Function() fn) {
    try {
      fn();
      print('✓ PASS: $name');
      totalPassed++;
    } catch (e) {
      print('✗ FAIL: $name');
      print('  Error: $e');
      exitCode = 1;
    }
  }

  // 1. Vehicle Number Formatting & Validation
  test('VehicleNumberValidator: cleanPlate sanitizes user input', () {
    assert(VehicleNumberValidator.cleanPlate(' dl 01-ab-1234 ') == 'DL01AB1234');
    assert(VehicleNumberValidator.cleanPlate('hr-26 dq 5551') == 'HR26DQ5551');
    assert(VehicleNumberValidator.cleanPlate('ka 05 mj 5005') == 'KA05MJ5005');
  });

  test('VehicleNumberValidator: formatForDisplay formats Indian plates', () {
    assert(VehicleNumberValidator.formatForDisplay('DL01AB1234') == 'DL 01 AB 1234');
    assert(VehicleNumberValidator.formatForDisplay('MH12DE1433') == 'MH 12 DE 1433');
    assert(VehicleNumberValidator.formatForDisplay('KA05MJ5005') == 'KA 05 MJ 5005');
    assert(VehicleNumberValidator.formatForDisplay('HR26DQ5551') == 'HR 26 DQ 5551');
  });

  test('VehicleNumberValidator: isValid identifies valid Indian number plates', () {
    assert(VehicleNumberValidator.isValid('DL01AB1234') == true);
    assert(VehicleNumberValidator.isValid('MH12DE1433') == true);
    assert(VehicleNumberValidator.isValid('KA05MJ5005') == true);
    assert(VehicleNumberValidator.isValid('HR26DQ5551') == true);
    assert(VehicleNumberValidator.isValid('UP32AZ0001') == true);
  });

  test('VehicleNumberValidator: isValid rejects invalid strings', () {
    assert(VehicleNumberValidator.isValid('') == false);
    assert(VehicleNumberValidator.isValid('1234') == false);
    assert(VehicleNumberValidator.isValid('INVALIDNUMBERPLATE') == false);
    assert(VehicleNumberValidator.isValid('12AB34CD') == false);
  });

  // 2. Android Configuration & App Constants
  test('AppConstants: Android package name is configured as com.rtoinfo.app', () {
    assert(AppConstants.androidPackageName == 'com.rtoinfo.app');
    assert(AppConstants.appName == 'RTO Info');
    assert(AppConstants.sampleVehicles.length >= 4);
  });

  // 3. Localization Dictionary (English & Hindi)
  test('AppStrings: English and Hindi translations are complete', () {
    assert(AppStrings.get('appName', 'en') == 'RTO Info');
    assert(AppStrings.get('appName', 'hi') == 'आरटीओ इन्फो');

    assert(AppStrings.get('navHome', 'en') == 'Home');
    assert(AppStrings.get('navHome', 'hi') == 'होम');

    assert(AppStrings.get('navHistory', 'en') == 'History');
    assert(AppStrings.get('navHistory', 'hi') == 'इतिहास');

    assert(AppStrings.get('navFavourites', 'en') == 'Favourites');
    assert(AppStrings.get('navFavourites', 'hi') == 'पसंदीदा');

    assert(AppStrings.get('navSettings', 'en') == 'Settings');
    assert(AppStrings.get('navSettings', 'hi') == 'सेटिंग्स');
  });

  // 4. Strict Zero-Authentication Verification
  test('Strict Rule: No authentication files, login, or signup screens exist', () {
    final libDir = Directory('lib');
    final allFiles = libDir.listSync(recursive: true);

    for (final entity in allFiles) {
      if (entity is File) {
        final path = entity.path.toLowerCase();
        assert(!path.contains('login'), 'Found prohibited login file: $path');
        assert(!path.contains('signup'), 'Found prohibited signup file: $path');
        assert(!path.contains('auth_guard'), 'Found prohibited auth guard file: $path');
        assert(!path.contains('firebase_auth'), 'Found prohibited firebase_auth file: $path');
      }
    }
  });

  // 5. Android Manifest package verification
  test('AndroidManifest.xml contains package com.rtoinfo.app and INTERNET permission', () {
    final manifest = File('android/app/src/main/AndroidManifest.xml');
    assert(manifest.existsSync(), 'AndroidManifest.xml must exist');
    final content = manifest.readAsStringSync();
    assert(content.contains('package="com.rtoinfo.app"'), 'Manifest must declare package com.rtoinfo.app');
    assert(content.contains('android.permission.INTERNET'), 'Manifest must have INTERNET permission');
  });

  // 6. build.gradle namespace and applicationId verification
  test('android/app/build.gradle declares namespace and applicationId com.rtoinfo.app', () {
    final gradle = File('android/app/build.gradle');
    assert(gradle.existsSync(), 'build.gradle must exist');
    final content = gradle.readAsStringSync();
    assert(content.contains('namespace = "com.rtoinfo.app"'), 'Namespace must be com.rtoinfo.app');
    assert(content.contains('applicationId = "com.rtoinfo.app"'), 'ApplicationId must be com.rtoinfo.app');
  });

  // 7. Flutter CI Workflow configuration
  test('GitHub Actions build-apk.yml exists and targets JDK 17', () {
    final ci = File('.github/workflows/build-apk.yml');
    assert(ci.existsSync(), 'build-apk.yml must exist');
    final content = ci.readAsStringSync();
    assert(content.contains("java-version: '17'"), 'CI must use JDK 17');
    assert(content.contains('flutter build apk --release'), 'CI must build release APK');
  });

  print('\n-----------------------------------------------------');
  print('Result: $totalPassed/10 Test Suites Passed Successfully! ✓');
  print('=====================================================');
}
