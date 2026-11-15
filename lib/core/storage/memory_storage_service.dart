import '../../features/history/domain/models/search_history_entity.dart';
import '../../features/favourites/domain/models/favourite_vehicle_entity.dart';
import 'storage_service.dart';

/// Pure-Dart in-memory implementation of StorageService for fast, isolated tests.
class MemoryStorageService implements StorageService {
  final List<SearchHistoryEntity> _history = [];
  final List<FavouriteVehicleEntity> _favourites = [];

  @override
  Future<List<SearchHistoryEntity>> getHistory() async {
    return List.unmodifiable(_history);
  }

  @override
  Future<void> addHistory(SearchHistoryEntity item) async {
    final filtered = _history
        .where((h) => h.registrationNumber != item.registrationNumber)
        .toList();
    _history.clear();
    _history.add(item);
    _history.addAll(filtered);
  }

  @override
  Future<void> deleteHistoryItem(String id) async {
    _history.removeWhere((h) => h.id == id);
  }

  @override
  Future<void> clearHistory() async {
    _history.clear();
  }

  @override
  Future<List<FavouriteVehicleEntity>> getFavourites() async {
    return List.unmodifiable(_favourites);
  }

  @override
  Future<bool> isFavourite(String cleanPlate) async {
    return _favourites.any((f) => f.registrationNumber == cleanPlate);
  }

  @override
  Future<void> addFavourite(FavouriteVehicleEntity item) async {
    final filtered = _favourites
        .where((f) => f.registrationNumber != item.registrationNumber)
        .toList();
    _favourites.clear();
    _favourites.add(item);
    _favourites.addAll(filtered);
  }

  @override
  Future<void> removeFavourite(String cleanPlate) async {
    _favourites.removeWhere((f) => f.registrationNumber == cleanPlate);
  }

  @override
  Future<void> clearAllData() async {
    _history.clear();
    _favourites.clear();
  }
}
