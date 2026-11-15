import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/localization/app_locale.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/models/fuel_price_entity.dart';
import '../../../shared/widgets/premium_card.dart';

class TripCalculatorScreen extends ConsumerStatefulWidget {
  const TripCalculatorScreen({super.key});

  @override
  ConsumerState<TripCalculatorScreen> createState() =>
      _TripCalculatorScreenState();
}

class _TripCalculatorScreenState extends ConsumerState<TripCalculatorScreen> {
  final _distanceController = TextEditingController(text: '120');
  final _mileageController = TextEditingController(text: '18');
  final _fuelPriceController = TextEditingController(text: '94.72');
  String _fuelType = 'Petrol';
  TripCostResult? _result;

  @override
  void initState() {
    super.initState();
    _calculate();
  }

  @override
  void dispose() {
    _distanceController.dispose();
    _mileageController.dispose();
    _fuelPriceController.dispose();
    super.dispose();
  }

  void _calculate() {
    final dist = double.tryParse(_distanceController.text) ?? 0.0;
    final mileage = double.tryParse(_mileageController.text) ?? 0.0;
    final price = double.tryParse(_fuelPriceController.text) ?? 94.72;

    if (dist > 0 && mileage > 0 && price > 0) {
      final liters = dist / mileage;
      final cost = liters * price;
      setState(() {
        _result = TripCostResult(
          distanceKm: dist,
          mileageKmpl: mileage,
          fuelPricePerLiter: price,
          fuelConsumedLiters: liters,
          totalCost: cost,
          costPerKm: cost / dist,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final locale = ref.watch(localeProvider);
    final isHindi = locale.languageCode == 'hi';
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(isHindi ? 'यात्रा लागत कैलकुलेटर' : 'Trip Cost Calculator'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.paddingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            PremiumCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isHindi ? 'यात्रा का विवरण' : 'Trip Details',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: isDark
                          ? AppColors.darkTextPrimary
                          : AppColors.lightTextPrimary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _distanceController,
                    keyboardType: TextInputType.number,
                    onChanged: (_) => _calculate(),
                    decoration: InputDecoration(
                      labelText: isHindi ? 'दूरी (किमी)' : 'Distance (km)',
                      prefixIcon: const Icon(Icons.straighten),
                    ),
                  ),
                  const SizedBox(height: 14),
                  TextField(
                    controller: _mileageController,
                    keyboardType: TextInputType.number,
                    onChanged: (_) => _calculate(),
                    decoration: InputDecoration(
                      labelText: isHindi
                          ? 'माइलेज (किमी / ली)'
                          : 'Mileage (km / L)',
                      prefixIcon: const Icon(Icons.speed),
                    ),
                  ),
                  const SizedBox(height: 14),
                  TextField(
                    controller: _fuelPriceController,
                    keyboardType: TextInputType.number,
                    onChanged: (_) => _calculate(),
                    decoration: InputDecoration(
                      labelText: isHindi
                          ? 'ईंधन दर (₹ / ली)'
                          : 'Fuel Price (₹ / L)',
                      prefixIcon: const Icon(Icons.local_gas_station),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppConstants.paddingLarge),
            if (_result != null) ...[
              PremiumCard(
                backgroundColor: isDark
                    ? AppColors.darkSurfaceAlt
                    : AppColors.lightSurfaceVariant,
                borderColor: AppColors.electricBlue.withOpacity(0.4),
                child: Column(
                  children: [
                    Text(
                      isHindi
                          ? 'अनुमानित कुल लागत'
                          : 'Estimated Total Fuel Cost',
                      style: TextStyle(
                        fontSize: 13,
                        color: isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.lightTextSecondary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '₹${_result!.totalCost.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w800,
                        color: AppColors.electricBlue,
                      ),
                    ),
                    const Divider(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStat(
                          isHindi ? 'ईंधन की खपत' : 'Fuel Needed',
                          '${_result!.fuelConsumedLiters.toStringAsFixed(1)} L',
                          isDark,
                        ),
                        _buildStat(
                          isHindi ? 'लागत / किमी' : 'Cost / km',
                          '₹${_result!.costPerKm.toStringAsFixed(2)}',
                          isDark,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStat(String label, String value, bool isDark) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: isDark
                ? AppColors.darkTextPrimary
                : AppColors.lightTextPrimary,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
          ),
        ),
      ],
    );
  }
}
