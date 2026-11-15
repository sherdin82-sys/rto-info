import 'package:flutter/material.dart';

/// AppTypography defines consistent, professional automotive typography styles for RTO Info,
/// structured according to NoteFlow architectural standards.
class AppTypography {
  static const String fontFamily = 'sans-serif';
  static const String monospaceFont = 'monospace';

  // Display Styles
  static TextStyle displayLarge(Color color) => TextStyle(
    fontFamily: fontFamily,
    fontSize: 32,
    fontWeight: FontWeight.w800,
    letterSpacing: -0.8,
    height: 1.2,
    color: color,
  );

  static TextStyle displayMedium(Color color) => TextStyle(
    fontFamily: fontFamily,
    fontSize: 26,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.6,
    height: 1.25,
    color: color,
  );

  static TextStyle displaySmall(Color color) => TextStyle(
    fontFamily: fontFamily,
    fontSize: 22,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.4,
    height: 1.3,
    color: color,
  );

  // Title Styles
  static TextStyle titleLarge(Color color) => TextStyle(
    fontFamily: fontFamily,
    fontSize: 20,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.3,
    height: 1.3,
    color: color,
  );

  static TextStyle titleMedium(Color color) => TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.2,
    height: 1.35,
    color: color,
  );

  static TextStyle titleSmall(Color color) => TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.1,
    height: 1.4,
    color: color,
  );

  // Body Styles
  static TextStyle bodyLarge(Color color) => TextStyle(
    fontFamily: fontFamily,
    fontSize: 15,
    fontWeight: FontWeight.w400,
    letterSpacing: -0.1,
    height: 1.5,
    color: color,
  );

  static TextStyle bodyMedium(Color color) => TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
    height: 1.45,
    color: color,
  );

  static TextStyle bodySmall(Color color) => TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
    height: 1.4,
    color: color,
  );

  // Label & Badge Styles
  static TextStyle labelLarge(Color color) => TextStyle(
    fontFamily: fontFamily,
    fontSize: 13,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.1,
    color: color,
  );

  static TextStyle labelMedium(Color color) => TextStyle(
    fontFamily: fontFamily,
    fontSize: 11,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.3,
    color: color,
  );

  static TextStyle labelSmall(Color color) => TextStyle(
    fontFamily: fontFamily,
    fontSize: 10,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.5,
    color: color,
  );

  // Automotive Plate Monospace Styles
  static TextStyle hsrpPlate({
    required Color color,
    double fontSize = 20,
    FontWeight fontWeight = FontWeight.w900,
  }) => TextStyle(
    fontFamily: monospaceFont,
    fontSize: fontSize,
    fontWeight: fontWeight,
    letterSpacing: 2.2,
    color: color,
  );

  // Financial & Currency Styles
  static TextStyle currencyValue({
    required Color color,
    double fontSize = 24,
  }) => TextStyle(
    fontFamily: fontFamily,
    fontSize: fontSize,
    fontWeight: FontWeight.w800,
    letterSpacing: -0.5,
    color: color,
  );
}
