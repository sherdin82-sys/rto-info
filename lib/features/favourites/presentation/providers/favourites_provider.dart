import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/storage/local_storage_service.dart';
import '../../domain/models/favourite_vehicle_entity.dart';
import '../../../vehicle_details/domain/models/vehicle_entity.dart';
import '../../../history/presentation/providers/history_provider.dart';

class FavouritesNotifier extends StateNotifier<List<FavouriteVehicleEntity>> {
  final LocalStorageService _storage;

  FavouritesNotifier(this._storage) : super([]) {
    loadFavourites();
  }

  Future<void> loadFavourites() async {
    final list = await _storage.getFavourites();
    state = list;
  }

  bool isFavourite(String cleanPlate) {
    return state.any((f) => f.registrationNumber == cleanPlate);
  }

  Future<void> toggleFavourite(VehicleEntity vehicle) async {
    final clean = vehicle.cleanRegistrationNumber;
    if (isFavourite(clean)) {
      await _storage.removeFavourite(clean);
    } else {
      final entity = FavouriteVehicleEntity(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        registrationNumber: clean,
        formattedPlate: vehicle.registrationNumber,
        makerModel: '${vehicle.maker} ${vehicle.model}',
        vehicleClass: vehicle.vehicleClass,
        fuelType: vehicle.fuelType,
        insuranceValidity: vehicle.insuranceValidity,
        insuranceStatus: vehicle.insuranceStatus,
        fitnessValidity: vehicle.fitnessValidity,
        savedAt: DateTime.now(),
      );
      await _storage.addFavourite(entity);
    }
    await loadFavourites();
  }

  Future<void> removeFavourite(String cleanPlate) async {
    await _storage.removeFavourite(cleanPlate);
    await loadFavourites();
  }

  Future<void> clearAll() async {
    await _storage.clearAllData();
    state = [];
  }
}

final favouritesProvider =
    StateNotifierProvider<FavouritesNotifier, List<FavouriteVehicleEntity>>((
      ref,
    ) {
      final storage = ref.watch(localStorageServiceProvider);
      return FavouritesNotifier(storage);
    });
