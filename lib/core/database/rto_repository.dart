import '../../shared/models/vehicle_entity.dart';
import '../../shared/models/search_history_entity.dart';
import '../../shared/models/favourite_vehicle_entity.dart';

/// RtoRepository is the core repository interface contract for RTO Info,
/// structured according to NoteFlow architectural standards.
abstract class RtoRepository {
  /// Stream of user search history
  Stream<List<SearchHistoryEntity>> watchSearchHistory();

  /// Get current list of search history
  Future<List<SearchHistoryEntity>> getSearchHistory();

  /// Add entry to search history
  Future<void> addSearchHistory(SearchHistoryEntity item);

  /// Delete specific search history entry
  Future<void> deleteSearchHistory(String plate);

  /// Clear all search history
  Future<void> clearSearchHistory();

  /// Stream of user bookmarked/favourite vehicles
  Stream<List<FavouriteVehicleEntity>> watchFavourites();

  /// Get current list of favourite vehicles
  Future<List<FavouriteVehicleEntity>> getFavourites();

  /// Check if vehicle plate is bookmarked
  Future<bool> isFavourite(String plate);

  /// Toggle bookmark status of a vehicle
  Future<void> toggleFavourite(FavouriteVehicleEntity item);

  /// Remove vehicle from favourites
  Future<void> removeFavourite(String plate);

  /// Get cached vehicle from offline storage
  Future<VehicleEntity?> getCachedVehicle(String cleanPlate);

  /// Cache vehicle record for offline access
  Future<void> cacheVehicle(VehicleEntity vehicle);
}
