import '../../domain/models/vehicle_entity.dart';
import '../datasources/vehicle_data_source.dart';

abstract class VehicleRepository {
  Future<VehicleEntity?> getVehicleDetails(String registrationNumber);
}

class VehicleRepositoryImpl implements VehicleRepository {
  final VehicleDataSource _dataSource;

  VehicleRepositoryImpl({required VehicleDataSource dataSource})
      : _dataSource = dataSource;

  @override
  Future<VehicleEntity?> getVehicleDetails(String registrationNumber) {
    return _dataSource.getVehicleDetails(registrationNumber);
  }
}
