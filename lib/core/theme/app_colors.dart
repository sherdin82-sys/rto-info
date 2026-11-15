import 'package:flutter/material.dart';

/// AppColors defines the automotive & Parivahan design palette for RTO Info,
/// structured according to NoteFlow architectural standards.
class AppColors {
  AppColors._();

  // Primary Brand Colors (Deep Navy / Cobalt)
  static const Color primary = Color(0xFF0066FF); // Electric Blue Primary
  static const Color primaryNavy = Color(0xFF0A1128); // Deep Automotive Navy
  static const Color primaryNavyDark = Color(0xFF050B1A); // Deep Obsidian
  static const Color primaryNavyLight = Color(
    0xFF131F42,
  ); // Elevated Slate Navy
  static const Color primaryLight = Color(0xFF388BFF);
  static const Color primaryDark = Color(0xFF004ECC);

  // Secondary & Accents (Electric Blue & Warm Orange Highlights)
  static const Color electricBlue = Color(0xFF0066FF);
  static const Color electricBlueLight = Color(0xFF388BFF);
  static const Color electricBlueDark = Color(0xFF004ECC);
  static const Color accent = Color(
    0xFFFF9933,
  ); // Indian Transport / Parivahan Saffron
  static const Color saffron = Color(0xFFFF9933);
  static const Color saffronDark = Color(0xFFE68019);
  static const Color warmOrange = Color(0xFFFF7A00); // Warm Orange Highlight
  static const Color warmOrangeLight = Color(0xFFFF9433);
  static const Color warmOrangeGlow = Color(0x33FF7A00);

  // Status & Utility Colors
  static const Color success = Color(0xFF10B981);
  static const Color successDark = Color(0xFF059669);
  static const Color successLight = Color(0xFFD1FAE5);

  static const Color warning = Color(0xFFF59E0B);
  static const Color warningLight = Color(0xFFFEF3C7);

  static const Color error = Color(0xFFEF4444);
  static const Color danger = Color(0xFFEF4444);
  static const Color errorLight = Color(0xFFFEE2E2);

  // Light Theme Palette (Snow & Porcelain)
  static const Color lightBackground = Color(0xFFF6F8FC);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightSurfaceAlt = Color(0xFFEEF2F9);
  static const Color lightSurfaceVariant = Color(0xFFEEF2F9);
  static const Color lightBorder = Color(0xFFE2E8F0);
  static const Color lightBorderSubtle = Color(0x66CBD5E1);
  static const Color lightTextPrimary = Color(0xFF0A1128);
  static const Color lightTextSecondary = Color(0xFF5A6B87);
  static const Color lightTextTertiary = Color(0xFF8F9EB5);
  static const Color lightTextMuted = Color(0xFF8F9EB5);

  // Dark Theme Palette (Obsidian & Navy)
  static const Color darkBackground = Color(
    0xFF080D1A,
  ); // Ultra-deep navy obsidian
  static const Color darkSurface = Color(0xFF10192D); // Primary dark surface
  static const Color darkSurfaceAlt = Color(
    0xFF18233C,
  ); // Elevated card container
  static const Color darkSurfaceVariant = Color(0xFF1E2C4A);
  static const Color darkBorder = Color(0xFF223150); // Subtle glass outline
  static const Color darkBorderSubtle = Color(
    0x33388BFF,
  ); // Electric blue glass glow
  static const Color darkTextPrimary = Color(0xFFF8FAFC);
  static const Color darkTextSecondary = Color(0xFF94A3B8);
  static const Color darkTextTertiary = Color(0xFF64748B);
  static const Color darkTextMuted = Color(0xFF64748B);

  // High-Security Registration Plate (HSRP) Colors
  static const Color hsrpBlueStrip = Color(
    0xFF003399,
  ); // Authentic IND strip blue
  static const Color hsrpYellowEv = Color(0xFF00A86B); // Commercial EV green
  static const Color hsrpPlateWhite = Color(0xFFFFFFFF); // Private vehicles
  static const Color hsrpPlateYellow = Color(
    0xFFFACC15,
  ); // Commercial transport
  static const Color hsrpPlateGreen = Color(0xFF16A34A); // Electric vehicles

  // Smart Card Aesthetic
  static const Color metallicGold = Color(0xFFD4AF37); // EMV microchip gold
  static const Color metallicGoldLight = Color(0xFFFFE082);
  static const Color hologramTeal = Color(0xFF0D9488);
}
