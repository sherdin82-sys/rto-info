/// Domain model for daily fuel prices across Indian cities.
class FuelPriceEntity {
  final String city;
  final String state;
  final double petrolPrice;
  final double petrolChange;
  final double dieselPrice;
  final double dieselChange;
  final double cngPrice;
  final double cngChange;
  final String lastUpdated;

  const FuelPriceEntity({
    required this.city,
    required this.state,
    required this.petrolPrice,
    required this.petrolChange,
    required this.dieselPrice,
    required this.dieselChange,
    required this.cngPrice,
    required this.cngChange,
    required this.lastUpdated,
  });

  Map<String, dynamic> toMap() => {
    'city': city,
    'state': state,
    'petrolPrice': petrolPrice,
    'petrolChange': petrolChange,
    'dieselPrice': dieselPrice,
    'dieselChange': dieselChange,
    'cngPrice': cngPrice,
    'cngChange': cngChange,
    'lastUpdated': lastUpdated,
  };

  factory FuelPriceEntity.fromMap(Map<String, dynamic> map) => FuelPriceEntity(
    city: map['city'] ?? '',
    state: map['state'] ?? '',
    petrolPrice: (map['petrolPrice'] as num?)?.toDouble() ?? 0.0,
    petrolChange: (map['petrolChange'] as num?)?.toDouble() ?? 0.0,
    dieselPrice: (map['dieselPrice'] as num?)?.toDouble() ?? 0.0,
    dieselChange: (map['dieselChange'] as num?)?.toDouble() ?? 0.0,
    cngPrice: (map['cngPrice'] as num?)?.toDouble() ?? 0.0,
    cngChange: (map['cngChange'] as num?)?.toDouble() ?? 0.0,
    lastUpdated: map['lastUpdated'] ?? 'Today, 6:00 AM',
  );
}

/// Trip Cost Calculator domain logic
class TripCostResult {
  final double distanceKm;
  final double mileageKmpl;
  final double fuelPrice;
  final double litersRequired;
  final double totalCost;
  final double costPerKm;

  const TripCostResult({
    required this.distanceKm,
    required this.mileageKmpl,
    required this.fuelPrice,
    required this.litersRequired,
    required this.totalCost,
    required this.costPerKm,
  });

  static TripCostResult calculate({
    required double distanceKm,
    required double mileageKmpl,
    required double fuelPrice,
  }) {
    if (distanceKm <= 0 || mileageKmpl <= 0 || fuelPrice <= 0) {
      return const TripCostResult(
        distanceKm: 0,
        mileageKmpl: 0,
        fuelPrice: 0,
        litersRequired: 0,
        totalCost: 0,
        costPerKm: 0,
      );
    }
    final liters = distanceKm / mileageKmpl;
    final cost = liters * fuelPrice;
    final perKm = cost / distanceKm;
    return TripCostResult(
      distanceKm: distanceKm,
      mileageKmpl: mileageKmpl,
      fuelPrice: fuelPrice,
      litersRequired: liters,
      totalCost: cost,
      costPerKm: perKm,
    );
  }
}
