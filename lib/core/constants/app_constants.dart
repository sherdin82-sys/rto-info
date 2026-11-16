/// AppConstants defines core application constants for RTO Info.
class AppConstants {
  AppConstants._();

  static const String appName = 'RTO Info';
  static const String appVersion = '0.2.7';
  static const int buildNumber = 9;
  static const String androidPackageName = 'com.rtoinfo.app';

  // NoteFlow Design System Spacing & Radius
  static const double radiusSmall = 8.0;
  static const double radiusMedium = 14.0;
  static const double radiusLarge = 20.0;
  static const double radiusXLarge = 28.0;

  static const double paddingSmall = 8.0;
  static const double paddingMedium = 16.0;
  static const double paddingLarge = 24.0;

  static const Duration defaultAnimationDuration = Duration(milliseconds: 250);
  static const Duration fastAnimationDuration = Duration(milliseconds: 150);

  // Indian Vehicle Registration Plate Regex Pattern
  // Matches standard format: DL01AB1234, HR26DQ5551, KA05MJ5005, UP32AZ0001, etc.
  static final RegExp registrationPlateRegex = RegExp(
    r'^[A-Z]{2}[0-9]{1,2}[A-Z]{0,3}[0-9]{1,4}$',
  );

  // Curated demo vehicles for initial testing
  static const List<Map<String, String>> sampleVehicles = [
    {
      'plate': 'DL01AB1234',
      'label': 'DL 01 AB 1234',
      'desc': 'Maruti Suzuki Swift (Delhi)',
      'class': 'Motor Car (LMV)',
    },
    {
      'plate': 'MH12DE1433',
      'label': 'MH 12 DE 1433',
      'desc': 'Hyundai Creta (Pune)',
      'class': 'Motor Car (LMV)',
    },
    {
      'plate': 'KA05MJ5005',
      'label': 'KA 05 MJ 5005',
      'desc': 'Tata Nexon EV (Bengaluru)',
      'class': 'Electric Car (BEV)',
    },
    {
      'plate': 'HR26DQ5551',
      'label': 'HR 26 DQ 5551',
      'desc': 'Royal Enfield Classic 350 (Gurugram)',
      'class': 'Two Wheeler (MCWG)',
    },
  ];

  // Storage keys
  static const String keySearchHistory = 'rto_search_history';
  static const String keyFavourites = 'rto_favourite_vehicles';
  static const String keyAppLocale = 'rto_app_locale';
  static const String keyAppTheme = 'rto_app_theme';
}
