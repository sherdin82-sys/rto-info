import '../constants/app_constants.dart';

/// VehicleNumberValidator provides pure-Dart parsing, sanitization, validation,
/// and uppercase formatting for Indian vehicle registration plates.
class VehicleNumberValidator {
  VehicleNumberValidator._();

  /// Removes whitespace, dashes, and forces uppercase alphanumeric characters only
  static String cleanPlate(String input) {
    return input.toUpperCase().replaceAll(RegExp(r'[^A-Z0-9]'), '');
  }

  /// Formats a raw plate into spaced display format e.g. "DL 01 AB 1234"
  static String formatForDisplay(String plate) {
    final clean = cleanPlate(plate);
    if (clean.length < 5) return clean;

    final state = clean.substring(0, 2);
    final remaining = clean.substring(2);
    final match = RegExp(r'^([0-9]{1,2})([A-Z]{0,3})([0-9]{1,4})$').firstMatch(remaining);

    if (match != null) {
      final rtoCode = match.group(1) ?? '';
      final series = match.group(2) ?? '';
      final number = match.group(3) ?? '';

      final parts = [state, rtoCode];
      if (series.isNotEmpty) parts.add(series);
      if (number.isNotEmpty) parts.add(number);
      return parts.join(' ');
    }

    return clean;
  }

  /// Validates whether a given plate matches standard Indian format
  static bool isValid(String plate) {
    final clean = cleanPlate(plate);
    if (clean.length < 5 || clean.length > 12) return false;
    return AppConstants.registrationPlateRegex.hasMatch(clean);
  }
}
