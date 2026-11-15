import '../../domain/models/vehicle_entity.dart';
import 'vehicle_data_source.dart';
import 'vehicle_mock_datasource.dart';

/// MockVehicleDataProvider implements VehicleDataSource with realistic sample Indian vehicle records.
/// Explicitly identifies demonstration data for transparency and compliance.
class MockVehicleDataProvider implements VehicleDataSource {
  final VehicleMockDataSource _mockDataSource;

  MockVehicleDataProvider({VehicleMockDataSource? mockDataSource})
    : _mockDataSource = mockDataSource ?? VehicleMockDataSource();

  @override
  Future<VehicleEntity?> getVehicleDetails(String registrationNumber) {
    return _mockDataSource.getVehicleDetails(registrationNumber);
  }
}
