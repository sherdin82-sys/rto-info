import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../domain/models/fuel_price_entity.dart';
import '../data/fuel_mock_datasource.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fuel Rates & Trip Calculator'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.local_gas_station), text: 'Daily Fuel Rates'),
            Tab(icon: Icon(Icons.calculate_outlined), text: 'Trip Calculator'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [_buildFuelRatesTab(), _buildTripCalculatorTab()],
      ),
    );
  }

  Widget _buildFuelRatesTab() {
    return Column(
      children: [
        // Search bar
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
          child: TextField(
            controller: _searchController,
            onChanged: _filterCities,
            decoration: InputDecoration(
              hintText: 'Search city or state...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                        _filterCities('');
                      },
                    )
                  : null,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),

        // List of Cities
        Expanded(
          child: _filteredCities.isEmpty
              ? const Center(child: Text('No city found matching your search'))
              : ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: _filteredCities.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final item = _filteredCities[index];
                    return _buildCityFuelCard(item);
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildCityFuelCard(FuelPriceEntity item) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 1.5,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.city,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      item.state,
                      style: const TextStyle(fontSize: 11, color: Colors.grey),
                    ),
                  ],
                ),
                Text(
                  item.lastUpdated,
                  style: const TextStyle(fontSize: 10, color: Colors.grey),
                ),
              ],
            ),
            const Divider(height: 20),
            Row(
              children: [
                Expanded(
                  child: _fuelPill(
                    title: 'PETROL',
                    price: item.petrolPrice,
                    change: item.petrolChange,
                    accentColor: const Color(0xFFEA580C),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _fuelPill(
                    title: 'DIESEL',
                    price: item.dieselPrice,
                    change: item.dieselChange,
                    accentColor: AppColors.electricBlue,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _fuelPill(
                    title: 'CNG',
                    price: item.cngPrice,
                    change: item.cngChange,
                    accentColor: const Color(0xFF16A34A),
                    unit: '/kg',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _fuelPill({
    required String title,
    required double price,
    required double change,
    required Color accentColor,
    String unit = '/L',
  }) {
    final changeText = change == 0.0
        ? 'No change'
        : change > 0
        ? '+₹${change.toStringAsFixed(2)}'
        : '-₹${change.abs().toStringAsFixed(2)}';

    final changeColor = change > 0
        ? Colors.red
        : (change < 0 ? Colors.green : Colors.grey);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      decoration: BoxDecoration(
        color: accentColor.withOpacity(0.08),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: accentColor.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: accentColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '₹${price.toStringAsFixed(2)}',
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          Text(unit, style: const TextStyle(fontSize: 9, color: Colors.grey)),
          const SizedBox(height: 2),
          Text(
            changeText,
            style: TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w600,
              color: changeColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTripCalculatorTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Row(
                  children: [
                    Icon(Icons.route, color: AppColors.electricBlue),
                    SizedBox(width: 8),
                    Text(
                      'Trip Cost Estimator',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Text(
                  'TRIP DISTANCE (KM)',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 6),
                TextField(
                  controller: _distanceController,
                  keyboardType: TextInputType.number,
                  onChanged: (_) => _calculateTrip(),
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.straighten),
                    suffixText: 'km',
                  ),
                ),
                const SizedBox(height: 14),
                const Text(
                  'VEHICLE MILEAGE (KM/L)',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 6),
                TextField(
                  controller: _mileageController,
                  keyboardType: TextInputType.number,
                  onChanged: (_) => _calculateTrip(),
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.speed),
                    suffixText: 'km/L',
                  ),
                ),
                const SizedBox(height: 14),
                const Text(
                  'FUEL TYPE',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
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
        ),
        const SizedBox(height: 16),

        // Calculated Result Card
        if (_tripResult != null)
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.primaryNavy, Color(0xFF1E3A8A)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                const Text(
                  'ESTIMATED FUEL EXPENSE',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '₹${_tripResult!.totalCost.toStringAsFixed(0)}',
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                    color: Colors.amberAccent,
                  ),
                ),
                const SizedBox(height: 16),
                const Divider(color: Colors.white24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _calcStat(
                      'FUEL REQUIRED',
                      '${_tripResult!.litersRequired.toStringAsFixed(1)} L',
                    ),
                    _calcStat(
                      'EST. RUNNING COST',
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
          style: const TextStyle(color: Colors.white60, fontSize: 10),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
