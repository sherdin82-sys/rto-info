import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/challan_entity.dart';
import '../../data/datasources/challan_mock_datasource.dart';
import '../../data/repositories/challan_repository_impl.dart';

final challanRepositoryProvider = Provider<ChallanRepository>((ref) {
  return ChallanRepositoryImpl(dataSource: ChallanMockDataSource());
});

final vehicleChallansProvider = FutureProvider.family<List<ChallanEntity>, String>((ref, plate) async {
  final repo = ref.watch(challanRepositoryProvider);
  return repo.getChallansForVehicle(plate);
});
