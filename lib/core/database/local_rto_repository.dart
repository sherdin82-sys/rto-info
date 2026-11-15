import 'dart:async';
import 'dart:convert';
import 'dart:io';

import '../../shared/models/vehicle_entity.dart';
import '../../shared/models/search_history_entity.dart';
import '../../shared/models/favourite_vehicle_entity.dart';
import 'rto_repository.dart';

/// LocalRtoRepository provides durable, offline-first local persistence
/// using in-memory caching and JSON file storage, following NoteFlow's
/// repository architecture.
class LocalRtoRepository implements RtoRepository {
  final List<SearchHistoryEntity> _history = [];
  final List<FavouriteVehicleEntity> _favourites = [];
  final Map<String, VehicleEntity> _vehicleCache = {};

  final _historyStreamController =
      StreamController<List<SearchHistoryEntity>>.broadcast();
  final _favouritesStreamController =
      StreamController<List<FavouriteVehicleEntity>>.broadcast();

  final bool _seedDemoData;
  final bool _enableDiskPersistence;
  final String? _customStoragePath;
  final Future<String> Function()? _directoryProvider;
  File? _resolvedFile;
  bool _initialized = false;
  String _themeMode = 'system';
  String _locale = 'en';

  String get themeMode => _themeMode;
  String get locale => _locale;

  Future<void> setThemeMode(String mode) async {
    _themeMode = mode;
    await _saveToDisk();
  }

  Future<void> setLocale(String loc) async {
    _locale = loc;
    await _saveToDisk();
  }

  LocalRtoRepository({
    bool seedDemoData = true,
    bool enableDiskPersistence = true,
    String? customStoragePath,
    Future<String> Function()? directoryProvider,
  }) : _seedDemoData = seedDemoData,
       _enableDiskPersistence = enableDiskPersistence,
       _customStoragePath = customStoragePath,
       _directoryProvider = directoryProvider {
    if (_seedDemoData) {
      _seedInitialData();
    }
  }

  void _seedInitialData() {
    final now = DateTime.now();
    _history.addAll([
      SearchHistoryEntity(
        id: '1',
        registrationNumber: 'DL01AB1234',
        formattedPlate: 'DL 01 AB 1234',
        makerModel: 'Maruti Suzuki Swift',
        vehicleClass: 'Motor Car (LMV)',
        searchedAt: now.subtract(const Duration(minutes: 15)),
      ),
      SearchHistoryEntity(
        id: '2',
        registrationNumber: 'MH12DE1433',
        formattedPlate: 'MH 12 DE 1433',
        makerModel: 'Hyundai Creta',
        vehicleClass: 'Motor Car (LMV)',
        searchedAt: now.subtract(const Duration(hours: 3)),
      ),
      SearchHistoryEntity(
        id: '3',
        registrationNumber: 'KA05MJ5005',
        formattedPlate: 'KA 05 MJ 5005',
        makerModel: 'Tata Nexon EV',
        vehicleClass: 'Electric Car (BEV)',
        searchedAt: now.subtract(const Duration(days: 1)),
      ),
    ]);

    _favourites.addAll([
      FavouriteVehicleEntity(
        id: 'fav-1',
        registrationNumber: 'DL01AB1234',
        formattedPlate: 'DL 01 AB 1234',
        makerModel: 'Maruti Suzuki Swift',
        vehicleClass: 'Motor Car (LMV)',
        fuelType: 'PETROL',
        insuranceValidity: '14-Oct-2027',
        insuranceStatus: 'ACTIVE',
        fitnessValidity: '15-Mar-2035',
        savedAt: now.subtract(const Duration(days: 2)),
      ),
      FavouriteVehicleEntity(
        id: 'fav-2',
        registrationNumber: 'KA05MJ5005',
        formattedPlate: 'KA 05 MJ 5005',
        makerModel: 'Tata Nexon EV',
        vehicleClass: 'Electric Car (BEV)',
        fuelType: 'ELECTRIC',
        insuranceValidity: '12-May-2028',
        insuranceStatus: 'ACTIVE',
        fitnessValidity: '20-May-2038',
        savedAt: now.subtract(const Duration(days: 1)),
      ),
    ]);
  }

  Future<void> init() async {
    if (_initialized) return;
    if (!_enableDiskPersistence) {
      _initialized = true;
      _emitHistory();
      _emitFavourites();
      return;
    }

    try {
      final file = await _getStorageFile();
      if (file != null && await file.exists()) {
        final content = await file.readAsString();
        if (content.trim().isNotEmpty) {
          final data = jsonDecode(content) as Map<String, dynamic>;
          if (data.containsKey('theme_mode')) {
            _themeMode = data['theme_mode'] as String? ?? 'system';
          }
          if (data.containsKey('locale')) {
            _locale = data['locale'] as String? ?? 'en';
          }

          final rawHistory = data['history'] as List<dynamic>? ?? [];
          final rawFavs = data['favourites'] as List<dynamic>? ?? [];
          final rawCache =
              data['cached_vehicles'] as Map<String, dynamic>? ?? {};

          _history.clear();
          for (final h in rawHistory) {
            _history.add(
              SearchHistoryEntity.fromMap(Map<String, dynamic>.from(h as Map)),
            );
          }

          _favourites.clear();
          for (final f in rawFavs) {
            _favourites.add(
              FavouriteVehicleEntity.fromMap(
                Map<String, dynamic>.from(f as Map),
              ),
            );
          }

          _vehicleCache.clear();
          rawCache.forEach((key, val) {
            _vehicleCache[key] = VehicleEntity.fromMap(
              Map<String, dynamic>.from(val as Map),
            );
          });

          _initialized = true;
          _emitHistory();
          _emitFavourites();
          return;
        }
      }

      // If file doesn't exist, save initial seed data to disk
      await _saveToDisk();
      _initialized = true;
      _emitHistory();
      _emitFavourites();
    } catch (_) {
      // Graceful fallback to in-memory state
      _initialized = true;
      _emitHistory();
      _emitFavourites();
    }
  }

  Future<File?> _getStorageFile() async {
    if (_resolvedFile != null) return _resolvedFile;

    if (_customStoragePath != null) {
      _resolvedFile = File(_customStoragePath!);
      return _resolvedFile;
    }

    if (_directoryProvider != null) {
      final dirPath = await _directoryProvider!();
      _resolvedFile = File('$dirPath/rto_info_data.json');
      return _resolvedFile;
    }

    return null;
  }

  Future<void> _saveToDisk() async {
    if (!_enableDiskPersistence) return;
    try {
      final file = await _getStorageFile();
      if (file == null) return;

      final data = {
        'theme_mode': _themeMode,
        'locale': _locale,
        'history': _history.map((h) => h.toMap()).toList(),
        'favourites': _favourites.map((f) => f.toMap()).toList(),
        'cached_vehicles': _vehicleCache.map((k, v) => MapEntry(k, v.toMap())),
      };

      await file.parent.create(recursive: true);
      await file.writeAsString(jsonEncode(data));
    } catch (_) {
      // Ignore disk writing errors silently
    }
  }

  void _emitHistory() {
    if (!_historyStreamController.isClosed) {
      _historyStreamController.add(List.unmodifiable(_history));
    }
  }

  void _emitFavourites() {
    if (!_favouritesStreamController.isClosed) {
      _favouritesStreamController.add(List.unmodifiable(_favourites));
    }
  }

  // --- Search History API ---

  @override
  Stream<List<SearchHistoryEntity>> watchSearchHistory() async* {
    yield List.unmodifiable(_history);
    yield* _historyStreamController.stream;
  }

  @override
  Future<List<SearchHistoryEntity>> getSearchHistory() async {
    return List.unmodifiable(_history);
  }

  @override
  Future<void> addSearchHistory(SearchHistoryEntity item) async {
    _history.removeWhere(
      (h) => h.registrationNumber == item.registrationNumber,
    );
    _history.insert(0, item);
    if (_history.length > 30) {
      _history.removeLast();
    }
    _emitHistory();
    await _saveToDisk();
  }

  @override
  Future<void> deleteSearchHistory(String plate) async {
    _history.removeWhere((h) => h.registrationNumber == plate);
    _emitHistory();
    await _saveToDisk();
  }

  @override
  Future<void> clearSearchHistory() async {
    _history.clear();
    _emitHistory();
    await _saveToDisk();
  }

  // --- Favourites API ---

  @override
  Stream<List<FavouriteVehicleEntity>> watchFavourites() async* {
    yield List.unmodifiable(_favourites);
    yield* _favouritesStreamController.stream;
  }

  @override
  Future<List<FavouriteVehicleEntity>> getFavourites() async {
    return List.unmodifiable(_favourites);
  }

  @override
  Future<bool> isFavourite(String plate) async {
    return _favourites.any((f) => f.registrationNumber == plate);
  }

  @override
  Future<void> toggleFavourite(FavouriteVehicleEntity item) async {
    final index = _favourites.indexWhere(
      (f) => f.registrationNumber == item.registrationNumber,
    );
    if (index >= 0) {
      _favourites.removeAt(index);
    } else {
      _favourites.insert(0, item);
    }
    _emitFavourites();
    await _saveToDisk();
  }

  @override
  Future<void> removeFavourite(String plate) async {
    _favourites.removeWhere((f) => f.registrationNumber == plate);
    _emitFavourites();
    await _saveToDisk();
  }

  // --- Offline Vehicle Cache API ---

  @override
  Future<VehicleEntity?> getCachedVehicle(String cleanPlate) async {
    return _vehicleCache[cleanPlate];
  }

  @override
  Future<void> cacheVehicle(VehicleEntity vehicle) async {
    _vehicleCache[vehicle.cleanRegistrationNumber] = vehicle;
    await _saveToDisk();
  }

  void dispose() {
    _historyStreamController.close();
    _favouritesStreamController.close();
  }
}
