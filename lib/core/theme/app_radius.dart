import 'package:flutter/material.dart';

/// AppRadius defines standardized border radius tokens for cards,
/// dialogs, input fields, and buttons.
class AppRadius {
  AppRadius._();

  static const double none = 0.0;
  static const double xs = 4.0;
  static const double s = 8.0;
  static const double m = 12.0;
  static const double card = 16.0;
  static const double l = 20.0;
  static const double xl = 24.0;
  static const double pill = 999.0;

  // Reusable BorderRadius
  static const BorderRadius radiusXs = BorderRadius.all(Radius.circular(xs));
  static const BorderRadius radiusS = BorderRadius.all(Radius.circular(s));
  static const BorderRadius radiusM = BorderRadius.all(Radius.circular(m));
  static const BorderRadius radiusCard = BorderRadius.all(
    Radius.circular(card),
  );
  static const BorderRadius radiusL = BorderRadius.all(Radius.circular(l));
  static const BorderRadius radiusXl = BorderRadius.all(Radius.circular(xl));
  static const BorderRadius radiusPill = BorderRadius.all(
    Radius.circular(pill),
  );

  // Top rounded (bottom sheets, headers)
  static const BorderRadius topCard = BorderRadius.vertical(
    top: Radius.circular(card),
  );
  static const BorderRadius topL = BorderRadius.vertical(
    top: Radius.circular(l),
  );
  static const BorderRadius topXl = BorderRadius.vertical(
    top: Radius.circular(xl),
  );
}
