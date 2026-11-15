import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';

import 'core/database/database_provider.dart';
import 'core/database/local_rto_repository.dart';
import 'app/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final repo = LocalRtoRepository(
    directoryProvider: () async {
      final dir = await getApplicationDocumentsDirectory();
      return dir.path;
    },
  );
  await repo.init();

  runApp(
    ProviderScope(
      overrides: [rtoRepositoryProvider.overrideWithValue(repo)],
      child: const RTOInfoApp(),
    ),
  );
}
