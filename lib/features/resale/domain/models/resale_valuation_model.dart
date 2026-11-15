import 'dart:math';

/// Resale valuation calculator based on standard Indian automotive market depreciation curves.
class ResaleValuationCalculator {
  static ResaleValuationResult estimate({
    required double originalPrice,
    required int purchaseYear,
    required double kmDriven,
    required String condition, // 'Excellent', 'Good', 'Fair'
    required String
    vehicleType, // 'Two Wheeler', 'Hatchback', 'Sedan', 'SUV', 'Electric'
  }) {
    if (originalPrice <= 0) {
      return const ResaleValuationResult(
        originalPrice: 0,
        estimatedValue: 0,
        rangeLow: 0,
        rangeHigh: 0,
        depreciationPercentage: 0,
      );
    }

    final currentYear = DateTime.now().year;
    final age = max(0, currentYear - purchaseYear);

    // Baseline age depreciation table for Indian market
    double baseDepreciation;
    if (age == 0) {
      baseDepreciation = 0.08;
    } else if (age == 1) {
      baseDepreciation = 0.18;
    } else if (age == 2) {
      baseDepreciation = 0.28;
    } else if (age == 3) {
      baseDepreciation = 0.38;
    } else if (age == 4) {
      baseDepreciation = 0.46;
    } else if (age == 5) {
      baseDepreciation = 0.54;
    } else if (age == 6) {
      baseDepreciation = 0.60;
    } else if (age == 7) {
      baseDepreciation = 0.66;
    } else {
      baseDepreciation = min(0.80, 0.66 + (age - 7) * 0.03);
    }

    // Mileage impact (standard usage ~ 10,000 km/year)
    final expectedKm = max(1, age) * 10000;
    final kmDiffRatio = (kmDriven - expectedKm) / expectedKm;
    final kmAdjustment = kmDiffRatio.clamp(-0.15, 0.15) * 0.05;

    // Condition multiplier
    double conditionMultiplier = 1.0;
    if (condition == 'Excellent') conditionMultiplier = 1.05;
    if (condition == 'Fair') conditionMultiplier = 0.92;

    final totalDepreciation = (baseDepreciation + kmAdjustment).clamp(
      0.05,
      0.85,
    );
    final depreciatedValue =
        originalPrice * (1.0 - totalDepreciation) * conditionMultiplier;

    final estimatedValue = depreciatedValue.clamp(
      10000.0,
      originalPrice * 0.95,
    );
    final rangeLow = estimatedValue * 0.93;
    final rangeHigh = estimatedValue * 1.07;
    final actualDepreciationPct =
        ((originalPrice - estimatedValue) / originalPrice) * 100;

    return ResaleValuationResult(
      originalPrice: originalPrice,
      estimatedValue: estimatedValue,
      rangeLow: rangeLow,
      rangeHigh: rangeHigh,
      depreciationPercentage: actualDepreciationPct.clamp(5.0, 95.0),
    );
  }
}

class ResaleValuationResult {
  final double originalPrice;
  final double estimatedValue;
  final double rangeLow;
  final double rangeHigh;
  final double depreciationPercentage;

  const ResaleValuationResult({
    required this.originalPrice,
    required this.estimatedValue,
    required this.rangeLow,
    required this.rangeHigh,
    required this.depreciationPercentage,
  });
}
