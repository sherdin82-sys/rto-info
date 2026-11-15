import '../../features/history/domain/models/search_history_entity.dart';
import '../../features/favourites/domain/models/favourite_vehicle_entity.dart';

/// StorageService defines the contract for persistent caching of search history and favourites.
abstract class StorageService {
  Future<List<SearchHistoryEntity>> getHistory();
  Future<void> addHistory(SearchHistoryEntity item);
  Future<void> deleteHistoryItem(String id);
  Future<void> clearHistory();

  Future<List<FavouriteVehicleEntity>> getFavourites();
  Future<bool> isFavourite(String cleanPlate);
  Future<void> addFavourite(FavouriteVehicleEntity item);
  Future<void> removeFavourite(String cleanPlate);
  Future<void> clearAllData();
}
