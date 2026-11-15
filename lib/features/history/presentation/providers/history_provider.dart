import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/storage/local_storage_service.dart';
import '../../domain/models/search_history_entity.dart';

final localStorageServiceProvider = Provider<LocalStorageService>((ref) {
  return LocalStorageService();
});

class HistoryNotifier extends StateNotifier<List<SearchHistoryEntity>> {
  final LocalStorageService _storage;

  HistoryNotifier(this._storage) : super([]) {
    loadHistory();
  }

  Future<void> loadHistory() async {
    final list = await _storage.getHistory();
    state = list;
  }

  Future<void> addSearch({
    required String registrationNumber,
    required String formattedPlate,
    required String makerModel,
    required String vehicleClass,
  }) async {
    final entity = SearchHistoryEntity(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      registrationNumber: registrationNumber,
      formattedPlate: formattedPlate,
      makerModel: makerModel,
      vehicleClass: vehicleClass,
      searchedAt: DateTime.now(),
    );

    await _storage.addHistory(entity);
    await loadHistory();
  }

  Future<void> removeSearch(String id) async {
    await _storage.deleteHistoryItem(id);
    await loadHistory();
  }

  Future<void> clearAll() async {
    await _storage.clearHistory();
    state = [];
  }
}

final historyProvider =
    StateNotifierProvider<HistoryNotifier, List<SearchHistoryEntity>>((ref) {
      final storage = ref.watch(localStorageServiceProvider);
      return HistoryNotifier(storage);
    });
