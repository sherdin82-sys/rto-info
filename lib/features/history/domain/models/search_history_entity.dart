/// SearchHistoryEntity stores previous vehicle searches locally.
class SearchHistoryEntity {
  final String id;
  final String registrationNumber;
  final String formattedPlate;
  final String makerModel;
  final String vehicleClass;
  final DateTime searchedAt;

  const SearchHistoryEntity({
    required this.id,
    required this.registrationNumber,
    required this.formattedPlate,
    required this.makerModel,
    required this.vehicleClass,
    required this.searchedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'registrationNumber': registrationNumber,
      'formattedPlate': formattedPlate,
      'makerModel': makerModel,
      'vehicleClass': vehicleClass,
      'searchedAt': searchedAt.toIso8601String(),
    };
  }

  factory SearchHistoryEntity.fromMap(Map<String, dynamic> map) {
    return SearchHistoryEntity(
      id: map['id'] ?? '',
      registrationNumber: map['registrationNumber'] ?? '',
      formattedPlate: map['formattedPlate'] ?? '',
      makerModel: map['makerModel'] ?? '',
      vehicleClass: map['vehicleClass'] ?? '',
      searchedAt: DateTime.tryParse(map['searchedAt'] ?? '') ?? DateTime.now(),
    );
  }
}
