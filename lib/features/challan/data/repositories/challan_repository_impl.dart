import '../../domain/models/challan_entity.dart';
import '../datasources/challan_mock_datasource.dart';

abstract class ChallanRepository {
  Future<List<ChallanEntity>> getChallansForVehicle(String registrationNumber);
}

class ChallanRepositoryImpl implements ChallanRepository {
  final ChallanDataSource _dataSource;

  ChallanRepositoryImpl({required ChallanDataSource dataSource})
    : _dataSource = dataSource;

  @override
  Future<List<ChallanEntity>> getChallansForVehicle(String registrationNumber) {
    return _dataSource.getChallansForVehicle(registrationNumber);
  }
}
