/// FavouriteVehicleEntity stores bookmarked vehicles with compliance timestamps.
class FavouriteVehicleEntity {
  final String id;
  final String registrationNumber;
  final String formattedPlate;
  final String makerModel;
  final String vehicleClass;
  final String fuelType;
  final String insuranceValidity;
  final String insuranceStatus;
  final String fitnessValidity;
  final DateTime savedAt;

  const FavouriteVehicleEntity({
    required this.id,
    required this.registrationNumber,
    required this.formattedPlate,
    required this.makerModel,
    required this.vehicleClass,
    required this.fuelType,
    required this.insuranceValidity,
    required this.insuranceStatus,
    required this.fitnessValidity,
    required this.savedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'registrationNumber': registrationNumber,
      'formattedPlate': formattedPlate,
      'makerModel': makerModel,
      'vehicleClass': vehicleClass,
      'fuelType': fuelType,
      'insuranceValidity': insuranceValidity,
      'insuranceStatus': insuranceStatus,
      'fitnessValidity': fitnessValidity,
      'savedAt': savedAt.toIso8601String(),
    };
  }

  factory FavouriteVehicleEntity.fromMap(Map<String, dynamic> map) {
    return FavouriteVehicleEntity(
      id: map['id'] ?? '',
      registrationNumber: map['registrationNumber'] ?? '',
      formattedPlate: map['formattedPlate'] ?? '',
      makerModel: map['makerModel'] ?? '',
      vehicleClass: map['vehicleClass'] ?? '',
      fuelType: map['fuelType'] ?? '',
      insuranceValidity: map['insuranceValidity'] ?? '',
      insuranceStatus: map['insuranceStatus'] ?? 'ACTIVE',
      fitnessValidity: map['fitnessValidity'] ?? '',
      savedAt: DateTime.tryParse(map['savedAt'] ?? '') ?? DateTime.now(),
    );
  }
}
