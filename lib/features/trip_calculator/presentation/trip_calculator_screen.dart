import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/localization/app_locale.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/models/fuel_price_entity.dart';
import '../../../shared/widgets/app_app_bar.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_text_field.dart';
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
      setState(() {
        _result = TripCostResult.calculate(
          distanceKm: dist,
          mileageKmpl: mileage,
          fuelPrice: price,
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
      appBar: AppAppBar(
        title: isHindi ? 'यात्रा लागत कैलकुलेटर' : 'Trip Cost Calculator',
        subtitle: isHindi
            ? 'ईंधन खपत व अनुमानित खर्च'
            : 'Estimate fuel & travel budget',
      ),
      body: SingleChildScrollView(
        padding: AppSpacing.edgeInsetsL,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            PremiumCard(
              padding: AppSpacing.edgeInsetsL,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  AppTextField(
                    controller: _distanceController,
                    label: isHindi
                        ? 'दूरी (किलोमीटर में)'
                        : 'Trip Distance (km)',
                    hint: '120',
                    prefixIcon: const Icon(Icons.route, size: 20),
                    keyboardType: TextInputType.number,
                    onChanged: (_) => _calculate(),
                  ),
                  const SizedBox(height: AppSpacing.m),
                  AppTextField(
                    controller: _mileageController,
                    label: isHindi
                        ? 'वाहन माइलेज (किमी/लीटर)'
                        : 'Vehicle Mileage (km/L)',
                    hint: '18',
                    prefixIcon: const Icon(Icons.speed, size: 20),
                    keyboardType: TextInputType.number,
                    onChanged: (_) => _calculate(),
                  ),
                  const SizedBox(height: AppSpacing.m),
                  AppTextField(
                    controller: _fuelPriceController,
                    label: isHindi
                        ? 'ईंधन मूल्य (₹/लीटर)'
                        : 'Fuel Price (₹/Litre)',
                    hint: '94.72',
                    prefixIcon: const Icon(Icons.local_gas_station, size: 20),
                    keyboardType: TextInputType.number,
                    onChanged: (_) => _calculate(),
                  ),
                  const SizedBox(height: AppSpacing.l),
                  AppButton(
                    label: isHindi ? 'लागत गणना करें' : 'Calculate Fuel Cost',
                    variant: AppButtonVariant.primary,
                    onPressed: _calculate,
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xl),

            if (_result != null) ...[
              PremiumCard(
                accentColor: AppColors.warmOrange,
                padding: AppSpacing.edgeInsetsXl,
                child: Column(
                  children: [
                    Text(
                      isHindi
                          ? 'अनुमानित यात्रा लागत'
                          : 'Estimated Total Trip Cost',
                      style: AppTypography.labelLarge(
                        isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.lightTextSecondary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '₹${_result!.totalCost.toStringAsFixed(2)}',
                      style: AppTypography.currencyValue(
                        color: AppColors.electricBlue,
                        fontSize: 34,
                      ),
                    ),
                    const Divider(height: 28),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStat(
                          isHindi ? 'ईंधन की खपत' : 'Fuel Needed',
                          '${_result!.litersRequired.toStringAsFixed(1)} L',
                          isDark,
                        ),
                        Container(
                          width: 1,
                          height: 36,
                          color: isDark
                              ? AppColors.darkBorder
                              : AppColors.lightBorder,
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
          label,
          style: AppTypography.labelSmall(
            isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: isDark ? Colors.white : AppColors.primaryNavy,
          ),
        ),
      ],
    );
  }
}
