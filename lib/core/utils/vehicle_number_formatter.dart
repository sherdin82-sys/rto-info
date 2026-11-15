import 'package:flutter/services.dart';
import 'vehicle_number_validator.dart';

/// VehicleNumberFormatter delegates input filtering and sanitization to VehicleNumberValidator.
class VehicleNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final sanitized = VehicleNumberValidator.cleanPlate(newValue.text);
    return TextEditingValue(
      text: sanitized,
      selection: TextSelection.collapsed(offset: sanitized.length),
    );
  }

  static String cleanPlate(String input) => VehicleNumberValidator.cleanPlate(input);
  static String formatForDisplay(String plate) => VehicleNumberValidator.formatForDisplay(plate);
  static bool isValid(String plate) => VehicleNumberValidator.isValid(plate);
}
