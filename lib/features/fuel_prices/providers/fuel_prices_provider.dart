import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../fuel/data/fuel_mock_datasource.dart';
import '../../../shared/models/fuel_price_entity.dart';

final fuelPricesProvider = Provider<List<FuelPriceEntity>>((ref) {
  return FuelMockDataSource.allCities;
});
