// Database table schema definitions for Drift and SQLite
//
// RTO Info defines structured database schemas for Drift and SQLite persistence,
// matching NoteFlow's database architecture.

class SearchHistoryTableDefinition {
  static const String tableName = 'search_history';

  static const String colId = 'id';
  static const String colRegistrationNumber = 'registration_number';
  static const String colFormattedPlate = 'formatted_plate';
  static const String colMakerModel = 'maker_model';
  static const String colVehicleClass = 'vehicle_class';
  static const String colSearchedAt = 'searched_at';

  static const String createTableSql =
      '''
    CREATE TABLE IF NOT EXISTS $tableName (
      $colId TEXT PRIMARY KEY NOT NULL,
      $colRegistrationNumber TEXT NOT NULL,
      $colFormattedPlate TEXT NOT NULL,
      $colMakerModel TEXT NOT NULL,
      $colVehicleClass TEXT NOT NULL,
      $colSearchedAt TEXT NOT NULL
    );
  ''';
}

class FavouritesTableDefinition {
  static const String tableName = 'favourite_vehicles';

  static const String colId = 'id';
  static const String colRegistrationNumber = 'registration_number';
  static const String colFormattedPlate = 'formatted_plate';
  static const String colMakerModel = 'maker_model';
  static const String colVehicleClass = 'vehicle_class';
  static const String colFuelType = 'fuel_type';
  static const String colInsuranceValidity = 'insurance_validity';
  static const String colInsuranceStatus = 'insurance_status';
  static const String colFitnessValidity = 'fitness_validity';
  static const String colSavedAt = 'saved_at';

  static const String createTableSql =
      '''
    CREATE TABLE IF NOT EXISTS $tableName (
      $colId TEXT PRIMARY KEY NOT NULL,
      $colRegistrationNumber TEXT NOT NULL,
      $colFormattedPlate TEXT NOT NULL,
      $colMakerModel TEXT NOT NULL,
      $colVehicleClass TEXT NOT NULL,
      $colFuelType TEXT NOT NULL,
      $colInsuranceValidity TEXT NOT NULL,
      $colInsuranceStatus TEXT NOT NULL,
      $colFitnessValidity TEXT NOT NULL,
      $colSavedAt TEXT NOT NULL
    );
  ''';
}

class CachedVehiclesTableDefinition {
  static const String tableName = 'cached_vehicles';

  static const String colCleanPlate = 'clean_plate';
  static const String colJsonData = 'json_data';
  static const String colCachedAt = 'cached_at';

  static const String createTableSql =
      '''
    CREATE TABLE IF NOT EXISTS $tableName (
      $colCleanPlate TEXT PRIMARY KEY NOT NULL,
      $colJsonData TEXT NOT NULL,
      $colCachedAt TEXT NOT NULL
    );
  ''';
}

class AppSettingsTableDefinition {
  static const String tableName = 'app_settings';

  static const String colKey = 'key';
  static const String colValue = 'value';

  static const String createTableSql =
      '''
    CREATE TABLE IF NOT EXISTS $tableName (
      $colKey TEXT PRIMARY KEY NOT NULL,
      $colValue TEXT NOT NULL
    );
  ''';
}
