import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/vehicle_entity.dart';
import '../../data/datasources/vehicle_mock_datasource.dart';
import '../../data/repositories/vehicle_repository_impl.dart';

final vehicleRepositoryProvider = Provider<VehicleRepository>((ref) {
  return VehicleRepositoryImpl(dataSource: VehicleMockDataSource());
});

/// Async state for vehicle lookup
final vehicleLookupProvider = FutureProvider.family<VehicleEntity?, String>((ref, plate) async {
  final repo = ref.watch(vehicleRepositoryProvider);
  return repo.getVehicleDetails(plate);
});
