import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/widgets/app_scaffold_with_nav_bar.dart';
import '../../features/home/presentation/home_screen.dart';
import '../../features/history/presentation/history_screen.dart';
import '../../features/favourites/presentation/favourites_screen.dart';
import '../../features/settings/presentation/settings_screen.dart';
import '../../features/vehicle_details/presentation/vehicle_details_screen.dart';
import '../../features/challan/presentation/challan_screen.dart';
import '../../features/dl/presentation/dl_screen.dart';
import '../../features/tools/presentation/tools_placeholder_screens.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorHome = GlobalKey<NavigatorState>(debugLabel: 'shellHome');
final _shellNavigatorHistory = GlobalKey<NavigatorState>(debugLabel: 'shellHistory');
final _shellNavigatorFavourites = GlobalKey<NavigatorState>(debugLabel: 'shellFavourites');
final _shellNavigatorSettings = GlobalKey<NavigatorState>(debugLabel: 'shellSettings');

/// AppRouter defines all GoRouter paths for RTO Info.
/// Launches directly into the Home Dashboard without any authentication guards.
final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/',
    debugLogDiagnostics: false,
    routes: [
      // Stateful Nested Bottom Navigation Shell
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return AppScaffoldWithNavBar(navigationShell: navigationShell);
        },
        branches: [
          // Branch 1: Home Dashboard
          StatefulShellBranch(
            navigatorKey: _shellNavigatorHome,
            routes: [
              GoRoute(
                path: '/',
                name: 'home',
                builder: (context, state) => const HomeScreen(),
              ),
            ],
          ),

          // Branch 2: Search History
          StatefulShellBranch(
            navigatorKey: _shellNavigatorHistory,
            routes: [
              GoRoute(
                path: '/history',
                name: 'history',
                builder: (context, state) => const HistoryScreen(),
              ),
            ],
          ),

          // Branch 3: Favourites / Bookmarks
          StatefulShellBranch(
            navigatorKey: _shellNavigatorFavourites,
            routes: [
              GoRoute(
                path: '/favourites',
                name: 'favourites',
                builder: (context, state) => const FavouritesScreen(),
              ),
            ],
          ),

          // Branch 4: Settings
          StatefulShellBranch(
            navigatorKey: _shellNavigatorSettings,
            routes: [
              GoRoute(
                path: '/settings',
                name: 'settings',
                builder: (context, state) => const SettingsScreen(),
              ),
            ],
          ),
        ],
      ),

      // Secondary Feature Screens (Pushed over root navigator)
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/rc',
        name: 'rc_details',
        builder: (context, state) {
          final plate = state.uri.queryParameters['plate'];
          return VehicleDetailsScreen(initialPlate: plate);
        },
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/challan',
        name: 'challan',
        builder: (context, state) {
          final plate = state.uri.queryParameters['plate'];
          return ChallanScreen(initialPlate: plate);
        },
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/dl',
        name: 'dl_verify',
        builder: (context, state) => const DlScreen(),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/fuel',
        name: 'fuel_rates',
        builder: (context, state) => const FuelRatesScreen(),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/resale',
        name: 'resale_calculator',
        builder: (context, state) => const ResaleScreen(),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/rto',
        name: 'rto_directory',
        builder: (context, state) => const RtoDirectoryScreen(),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/signs',
        name: 'traffic_signs',
        builder: (context, state) => const TrafficSignsScreen(),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/exam',
        name: 'mock_exam',
        builder: (context, state) => const MockExamScreen(),
      ),
    ],
  );
});
