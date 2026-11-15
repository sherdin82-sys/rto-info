import '../../domain/models/vehicle_entity.dart';

/// VehicleDataSource abstracts data retrieval for Indian vehicle details.
/// Can be backed by mock data or an official enterprise API endpoint.
abstract class VehicleDataSource {
  Future<VehicleEntity?> getVehicleDetails(String registrationNumber);
}
