import '../../domain/models/dl_entity.dart';
import '../datasources/dl_mock_datasource.dart';

abstract class DlRepository {
  Future<DlEntity?> getDlDetails(String dlNumber);
}

class DlRepositoryImpl implements DlRepository {
  final DlMockDataSource _dataSource;

  DlRepositoryImpl({DlMockDataSource? dataSource})
      : _dataSource = dataSource ?? DlMockDataSource();

  @override
  Future<DlEntity?> getDlDetails(String dlNumber) {
    return _dataSource.getDlDetails(dlNumber);
  }
}
