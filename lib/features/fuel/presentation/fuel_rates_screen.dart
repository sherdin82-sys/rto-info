import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../shared/widgets/app_app_bar.dart';
import '../../../shared/widgets/app_text_field.dart';
import '../../../shared/widgets/premium_card.dart';
import '../data/fuel_mock_datasource.dart';
import '../domain/models/fuel_price_entity.dart';

/// FuelRatesScreen provides real-time daily fuel rates across major Indian metro cities
/// alongside an integrated automotive trip fuel cost calculator.
class FuelRatesScreen extends StatefulWidget {
  const FuelRatesScreen({super.key});

  @override
  State<FuelRatesScreen> createState() => _FuelRatesScreenState();
}

class _FuelRatesScreenState extends State<FuelRatesScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _searchController = TextEditingController();
  List<FuelPriceEntity> _filteredCities = FuelMockDataSource.allCities;

  // Trip Calculator State
  final _distanceController = TextEditingController(text: '120');
  final _mileageController = TextEditingController(text: '18');
  String _selectedFuelType = 'Petrol';
  TripCostResult? _tripResult;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _calculateTrip();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    _distanceController.dispose();
    _mileageController.dispose();
    super.dispose();
  }

  void _filterCities(String query) {
    final q = query.toLowerCase().trim();
    setState(() {
      if (q.isEmpty) {
        _filteredCities = FuelMockDataSource.allCities;
      } else {
        _filteredCities = FuelMockDataSource.allCities.where((c) {
          return c.city.toLowerCase().contains(q) ||
              c.state.toLowerCase().contains(q);
        }).toList();
      }
    });
  }

  void _calculateTrip() {
    final dist = double.tryParse(_distanceController.text) ?? 0.0;
    final mileage = double.tryParse(_mileageController.text) ?? 0.0;

    double price = 94.72; // Default Delhi Petrol
    if (_selectedFuelType == 'Diesel') price = 87.62;
    if (_selectedFuelType == 'CNG') price = 75.09;

    setState(() {
      _tripResult = TripCostResult.calculate(
        distanceKm: dist,
        mileageKmpl: mileage,
        fuelPrice: price,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.darkBackground
          : AppColors.lightBackground,
      appBar: AppAppBar(
        title: 'Fuel Rates & Calculator',
        subtitle: 'Daily Indian Fuel Index & Estimator',
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.electricBlue,
          indicatorWeight: 3,
          labelColor: AppColors.electricBlue,
          unselectedLabelColor: isDark
              ? AppColors.darkTextSecondary
              : AppColors.lightTextSecondary,
          tabs: const [
            Tab(
              icon: Icon(Icons.local_gas_station_rounded),
              text: 'Daily Fuel Rates',
            ),
            Tab(icon: Icon(Icons.calculate_outlined), text: 'Trip Estimator'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [_buildFuelRatesTab(isDark), _buildTripCalculatorTab(isDark)],
      ),
    );
  }

  Widget _buildFuelRatesTab(bool isDark) {
    return Column(
      children: [
        // Search bar
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.l,
            AppSpacing.m,
            AppSpacing.l,
            AppSpacing.s,
          ),
          child: AppTextField(
            controller: _searchController,
            hintText: 'Search city or state...',
            prefixIcon: Icons.search_rounded,
            onChanged: _filterCities,
          ),
        ),

        // List of Cities
        Expanded(
          child: _filteredCities.isEmpty
              ? Center(
                  child: Text(
                    'No city found matching your search',
                    style: TextStyle(
                      color: isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.lightTextSecondary,
                    ),
                  ),
                )
              : ListView.separated(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  itemCount: _filteredCities.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final item = _filteredCities[index];
                    return _buildCityFuelCard(item, isDark);
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildCityFuelCard(FuelPriceEntity item, bool isDark) {
    return PremiumCard(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      borderRadius: 10,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: AppColors.electricBlue.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Icon(
                      Icons.location_city_rounded,
                      size: 16,
                      color: AppColors.electricBlue,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.city,
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 14,
                          color: isDark
                              ? Colors.white
                              : AppColors.lightTextPrimary,
                        ),
                      ),
                      Text(
                        item.state,
                        style: TextStyle(
                          fontSize: 10.5,
                          color: isDark
                              ? AppColors.darkTextMuted
                              : AppColors.lightTextMuted,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.darkSurfaceAlt
                      : AppColors.lightSurfaceAlt,
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                  border: Border.all(
                    color: isDark
                        ? AppColors.darkBorder
                        : AppColors.lightBorder,
                  ),
                ),
                child: Text(
                  item.lastUpdated,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: isDark
                        ? AppColors.darkTextMuted
                        : AppColors.lightTextMuted,
                  ),
                ),
              ),
            ],
          ),
          const Divider(height: AppSpacing.l),
          Row(
            children: [
              Expanded(
                child: _fuelPill(
                  title: 'PETROL',
                  price: item.petrolPrice,
                  change: item.petrolChange,
                  accentColor: const Color(0xFFEA580C), // Orange
                  isDark: isDark,
                ),
              ),
              const SizedBox(width: AppSpacing.s),
              Expanded(
                child: _fuelPill(
                  title: 'DIESEL',
                  price: item.dieselPrice,
                  change: item.dieselChange,
                  accentColor: AppColors.electricBlue,
                  isDark: isDark,
                ),
              ),
              const SizedBox(width: AppSpacing.s),
              Expanded(
                child: _fuelPill(
                  title: 'CNG',
                  price: item.cngPrice,
                  change: item.cngChange,
                  accentColor: const Color(0xFF16A34A), // Green
                  unit: '/kg',
                  isDark: isDark,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _fuelPill({
    required String title,
    required double price,
    required double change,
    required Color accentColor,
    required bool isDark,
    String unit = '/L',
  }) {
    final changeText = change == 0.0
        ? 'No change'
        : change > 0
        ? '+₹${change.toStringAsFixed(2)}'
        : '-₹${change.abs().toStringAsFixed(2)}';

    final changeColor = change > 0
        ? AppColors.error
        : (change < 0
              ? AppColors.success
              : (isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted));

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      decoration: BoxDecoration(
        color: accentColor.withOpacity(0.08),
        borderRadius: BorderRadius.circular(AppRadius.s),
        border: Border.all(color: accentColor.withOpacity(0.25)),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.6,
              color: accentColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '₹${price.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: isDark ? Colors.white : AppColors.lightTextPrimary,
            ),
          ),
          Text(
            unit,
            style: TextStyle(
              fontSize: 9,
              color: isDark
                  ? AppColors.darkTextMuted
                  : AppColors.lightTextMuted,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            changeText,
            style: TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w700,
              color: changeColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTripCalculatorTab(bool isDark) {
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.l),
      children: [
        PremiumCard(
          padding: const EdgeInsets.all(AppSpacing.l),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.electricBlue.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(AppRadius.xs),
                    ),
                    child: const Icon(
                      Icons.route_rounded,
                      color: AppColors.electricBlue,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.m),
                  Text(
                    'Trip Cost Estimator',
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 16,
                      color: isDark ? Colors.white : AppColors.lightTextPrimary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.l),
              Text(
                'TRIP DISTANCE (KM)',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.8,
                  color: isDark
                      ? AppColors.darkTextMuted
                      : AppColors.lightTextMuted,
                ),
              ),
              const SizedBox(height: 6),
              AppTextField(
                controller: _distanceController,
                keyboardType: TextInputType.number,
                prefixIcon: Icons.straighten_rounded,
                suffixText: 'km',
                onChanged: (_) => _calculateTrip(),
              ),
              const SizedBox(height: AppSpacing.m),
              Text(
                'VEHICLE MILEAGE (KM/L)',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.8,
                  color: isDark
                      ? AppColors.darkTextMuted
                      : AppColors.lightTextMuted,
                ),
              ),
              const SizedBox(height: 6),
              AppTextField(
                controller: _mileageController,
                keyboardType: TextInputType.number,
                prefixIcon: Icons.speed_rounded,
                suffixText: 'km/L',
                onChanged: (_) => _calculateTrip(),
              ),
              const SizedBox(height: AppSpacing.m),
              Text(
                'FUEL TYPE',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.8,
                  color: isDark
                      ? AppColors.darkTextMuted
                      : AppColors.lightTextMuted,
                ),
              ),
              const SizedBox(height: 8),
              SegmentedButton<String>(
                segments: const [
                  ButtonSegment(value: 'Petrol', label: Text('Petrol')),
                  ButtonSegment(value: 'Diesel', label: Text('Diesel')),
                  ButtonSegment(value: 'CNG', label: Text('CNG')),
                ],
                selected: {_selectedFuelType},
                onSelectionChanged: (val) {
                  setState(() {
                    _selectedFuelType = val.first;
                  });
                  _calculateTrip();
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.l),

        // Calculated Result Card
        if (_tripResult != null)
          Container(
            padding: const EdgeInsets.all(AppSpacing.xl),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF0F172A), Color(0xFF1E3A8A)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(AppRadius.xl),
              boxShadow: [
                BoxShadow(
                  color: AppColors.electricBlue.withOpacity(0.2),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              children: [
                const Text(
                  'ESTIMATED FUEL EXPENSE',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.8,
                  ),
                ),
                const SizedBox(height: AppSpacing.s),
                Text(
                  '₹${_tripResult!.totalCost.toStringAsFixed(0)}',
                  style: const TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.w900,
                    color: AppColors.metallicGold,
                  ),
                ),
                const SizedBox(height: AppSpacing.l),
                const Divider(color: Colors.white24),
                const SizedBox(height: AppSpacing.s),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _calcStat(
                      'FUEL REQUIRED',
                      '${_tripResult!.litersRequired.toStringAsFixed(1)} L',
                    ),
                    _calcStat(
                      'RUNNING COST',
                      '₹${_tripResult!.costPerKm.toStringAsFixed(2)} / km',
                    ),
                  ],
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _calcStat(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white60,
            fontSize: 10,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}
