import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'rto_repository.dart';
import 'local_rto_repository.dart';
import '../../shared/models/search_history_entity.dart';
import '../../shared/models/favourite_vehicle_entity.dart';

/// Provider for the singleton RtoRepository (following NoteFlow architecture)
final rtoRepositoryProvider = Provider<RtoRepository>((ref) {
  final repo = LocalRtoRepository(seedDemoData: true);
  ref.onDispose(() {
    (repo as dynamic).dispose?.call();
  });
  return repo;
});

/// Reactive stream of user search history
final searchHistoryStreamProvider = StreamProvider<List<SearchHistoryEntity>>((
  ref,
) {
  final repo = ref.watch(rtoRepositoryProvider);
  return repo.watchSearchHistory();
});

/// Reactive stream of user bookmarked/favourite vehicles
final favouritesStreamProvider = StreamProvider<List<FavouriteVehicleEntity>>((
  ref,
) {
  final repo = ref.watch(rtoRepositoryProvider);
  return repo.watchFavourites();
});
