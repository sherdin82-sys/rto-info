import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/dl_entity.dart';
import '../../data/repositories/dl_repository_impl.dart';

final dlRepositoryProvider = Provider<DlRepository>((ref) {
  return DlRepositoryImpl();
});

final dlDetailsProvider = FutureProvider.family<DlEntity?, String>((
  ref,
  dlNumber,
) async {
  if (dlNumber.trim().isEmpty) return null;
  final repo = ref.watch(dlRepositoryProvider);
  return repo.getDlDetails(dlNumber);
});
