import 'package:flutter/material.dart';

/// AppColors defines the automotive & Parivahan design palette for RTO Info,
/// structured according to NoteFlow architectural standards.
class AppColors {
  AppColors._();

  // Primary Brand Colors (Deep Navy / Cobalt)
  static const Color primary = Color(0xFF0B1B3D);
  static const Color primaryNavy = Color(0xFF0B1B3D);
  static const Color primaryNavyDark = Color(0xFF070F22);
  static const Color primaryNavyLight = Color(0xFF162B55);
  static const Color primaryLight = Color(0xFF0066FF);
  static const Color primaryDark = Color(0xFF070F22);

  // Secondary & Accents (Electric Blue & Saffron)
  static const Color electricBlue = Color(0xFF0066FF);
  static const Color electricBlueLight = Color(0xFF388BFF);
  static const Color electricBlueDark = Color(0xFF004ECC);
  static const Color accent = Color(
    0xFFFF9933,
  ); // Indian Transport / Parivahan Saffron
  static const Color saffron = Color(0xFFFF9933);
  static const Color saffronDark = Color(0xFFE68019);

  // Status & Utility Colors
  static const Color success = Color(0xFF10B981);
  static const Color successDark = Color(0xFF059669);
  static const Color successLight = Color(0xFFD1FAE5);

  static const Color warning = Color(0xFFF59E0B);
  static const Color warningLight = Color(0xFFFEF3C7);

  static const Color error = Color(0xFFEF4444);
  static const Color danger = Color(0xFFEF4444);
  static const Color errorLight = Color(0xFFFEE2E2);

  // Light Theme Palette
  static const Color lightBackground = Color(0xFFF8FAFC);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightSurfaceAlt = Color(0xFFF1F5F9);
  static const Color lightSurfaceVariant = Color(0xFFF1F5F9);
  static const Color lightBorder = Color(0xFFE2E8F0);
  static const Color lightBorderSubtle = Color(0x66CBD5E1);
  static const Color lightTextPrimary = Color(0xFF0F172A);
  static const Color lightTextSecondary = Color(0xFF64748B);
  static const Color lightTextTertiary = Color(0xFF94A3B8);
  static const Color lightTextMuted = Color(0xFF94A3B8);

  // Dark Theme Palette (Obsidian & Navy)
  static const Color darkBackground = Color(0xFF0B132B);
  static const Color darkSurface = Color(0xFF131E3A);
  static const Color darkSurfaceAlt = Color(0xFF1C2B4E);
  static const Color darkSurfaceVariant = Color(0xFF1C2B4E);
  static const Color darkBorder = Color(0xFF22355F);
  static const Color darkBorderSubtle = Color(0x33475569);
  static const Color darkTextPrimary = Color(0xFFF8FAFC);
  static const Color darkTextSecondary = Color(0xFF94A3B8);
  static const Color darkTextTertiary = Color(0xFF64748B);
  static const Color darkTextMuted = Color(0xFF64748B);

  // High-Security Registration Plate (HSRP) Colors
  static const Color hsrpBlueStrip = Color(0xFF0052CC);
  static const Color hsrpYellowEv = Color(0xFF00A86B);
}
