import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/api_exceptions.dart';
import '../../domain/models/vehicle_entity.dart';
import 'vehicle_data_source.dart';

/// VehicleRemoteDataSource prepares integration interfaces for future authorized
/// government Parivahan API access.
///
/// NOTE: Accessing production Parivahan Vahan databases requires Ministry authorization,
/// static IP registration, and enterprise SSL client certificates.
class VehicleRemoteDataSource implements VehicleDataSource {
  final ApiClient apiClient;

  VehicleRemoteDataSource({required this.apiClient});

  @override
  Future<VehicleEntity?> getVehicleDetails(String registrationNumber) async {
    try {
      final response = await apiClient.get<Map<String, dynamic>>(
        ApiEndpoints.pathRcDetails,
        queryParameters: {'regn_no': registrationNumber},
      );

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data!;
        return VehicleEntity.fromMap({
          ...data,
          'isDemoData': false,
          'dataSourceLabel': 'Verified Parivahan Gateway',
        });
      }
      return null;
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(message: 'Remote gateway connection failed: $e');
    }
  }
}
