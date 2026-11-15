import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/app_constants.dart';
import '../../features/history/domain/models/search_history_entity.dart';
import '../../features/favourites/domain/models/favourite_vehicle_entity.dart';
import 'storage_service.dart';

/// LocalStorageService handles persistent caching of search history and favourites.
class LocalStorageService implements StorageService {
  SharedPreferences? _prefs;

  // In-memory fallback if SharedPreferences is not yet initialized (e.g. during standalone tests)
  final List<SearchHistoryEntity> _inMemoryHistory = [];
  final List<FavouriteVehicleEntity> _inMemoryFavourites = [];

  Future<void> init() async {
    try {
      _prefs = await SharedPreferences.getInstance();
    } catch (_) {
      // Graceful fallback to memory store
    }
  }

  // --- Search History ---

  Future<List<SearchHistoryEntity>> getHistory() async {
    if (_prefs == null) await init();

    if (_prefs != null) {
      final jsonList = _prefs!.getStringList(AppConstants.keySearchHistory);
      if (jsonList != null) {
        return jsonList
            .map((s) => SearchHistoryEntity.fromMap(jsonDecode(s) as Map<String, dynamic>))
            .toList();
      }
    }
    return List.unmodifiable(_inMemoryHistory);
  }

  Future<void> addHistory(SearchHistoryEntity item) async {
    if (_prefs == null) await init();

    final current = await getHistory();
    // Deduplicate existing entry for same plate
    final filtered = current.where((h) => h.registrationNumber != item.registrationNumber).toList();
    final updated = [item, ...filtered];

    if (_prefs != null) {
      final jsonList = updated.map((h) => jsonEncode(h.toMap())).toList();
      await _prefs!.setStringList(AppConstants.keySearchHistory, jsonList);
    } else {
      _inMemoryHistory.clear();
      _inMemoryHistory.addAll(updated);
    }
  }

  Future<void> deleteHistoryItem(String id) async {
    if (_prefs == null) await init();

    final current = await getHistory();
    final updated = current.where((h) => h.id != id).toList();

    if (_prefs != null) {
      final jsonList = updated.map((h) => jsonEncode(h.toMap())).toList();
      await _prefs!.setStringList(AppConstants.keySearchHistory, jsonList);
    } else {
      _inMemoryHistory.clear();
      _inMemoryHistory.addAll(updated);
    }
  }

  Future<void> clearHistory() async {
    if (_prefs == null) await init();
    if (_prefs != null) {
      await _prefs!.remove(AppConstants.keySearchHistory);
    }
    _inMemoryHistory.clear();
  }

  // --- Favourites ---

  Future<List<FavouriteVehicleEntity>> getFavourites() async {
    if (_prefs == null) await init();

    if (_prefs != null) {
      final jsonList = _prefs!.getStringList(AppConstants.keyFavourites);
      if (jsonList != null) {
        return jsonList
            .map((s) => FavouriteVehicleEntity.fromMap(jsonDecode(s) as Map<String, dynamic>))
            .toList();
      }
    }
    return List.unmodifiable(_inMemoryFavourites);
  }

  Future<bool> isFavourite(String cleanPlate) async {
    final list = await getFavourites();
    return list.any((f) => f.registrationNumber == cleanPlate);
  }

  Future<void> addFavourite(FavouriteVehicleEntity item) async {
    if (_prefs == null) await init();

    final current = await getFavourites();
    final filtered = current.where((f) => f.registrationNumber != item.registrationNumber).toList();
    final updated = [item, ...filtered];

    if (_prefs != null) {
      final jsonList = updated.map((f) => jsonEncode(f.toMap())).toList();
      await _prefs!.setStringList(AppConstants.keyFavourites, jsonList);
    } else {
      _inMemoryFavourites.clear();
      _inMemoryFavourites.addAll(updated);
    }
  }

  Future<void> removeFavourite(String cleanPlate) async {
    if (_prefs == null) await init();

    final current = await getFavourites();
    final updated = current.where((f) => f.registrationNumber != cleanPlate).toList();

    if (_prefs != null) {
      final jsonList = updated.map((f) => jsonEncode(f.toMap())).toList();
      await _prefs!.setStringList(AppConstants.keyFavourites, jsonList);
    } else {
      _inMemoryFavourites.clear();
      _inMemoryFavourites.addAll(updated);
    }
  }

  Future<void> clearAllData() async {
    await clearHistory();
    if (_prefs == null) await init();
    if (_prefs != null) {
      await _prefs!.remove(AppConstants.keyFavourites);
    }
    _inMemoryFavourites.clear();
  }
}
