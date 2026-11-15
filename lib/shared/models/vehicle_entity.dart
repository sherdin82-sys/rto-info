/// VehicleEntity represents the complete domain model for an Indian vehicle registration.
/// Strictly conforms to Parivahan Vahan standards and MV Act compliance rules.
class VehicleEntity {
  // Registration Details
  final String registrationNumber;
  final String cleanRegistrationNumber;
  final String registrationDate;
  final String registrationAuthority;
  final String rtoCode;
  final String state;
  final String vehicleClass;
  final String registrationValidity;
  final String registrationStatus; // Active / Suspended / Expired

  // Vehicle Details
  final String maker;
  final String model;
  final String vehicleCategory;
  final String fuelType;
  final String bodyType;
  final String engineCapacity;
  final int seatingCapacity;
  final String manufacturingYear;
  final String emissionStandard;
  final String color;
  final String maskedChassisNumber;
  final String maskedEngineNumber;

  // Owner Details (Protected under privacy guidelines)
  final String maskedOwnerName;
  final String maskedFatherName;
  final String ownershipSerial;
  final String maskedAddress;

  // Compliance Details
  final String insuranceCompany;
  final String insurancePolicyNumber;
  final String insuranceValidity;
  final String insuranceStatus; // ACTIVE / EXPIRED / EXPIRING_SOON
  final int insuranceDaysRemaining;

  final String pucCertificateNumber;
  final String pucValidity;
  final String pucStatus; // ACTIVE / EXPIRED / EXEMPTED
  final String pucTestingCenter;

  final String fitnessValidity;
  final String permitValidity;
  final String roadTaxStatus;
  final String roadTaxPaidUpto;

  final bool isHypothecated;
  final String? hypothecationBank;
  final String? hypothecationStatus;

  final bool isBlacklisted;
  final bool isDemoData;
  final String dataSourceLabel;

  const VehicleEntity({
    required this.registrationNumber,
    required this.cleanRegistrationNumber,
    required this.registrationDate,
    required this.registrationAuthority,
    required this.rtoCode,
    required this.state,
    required this.vehicleClass,
    required this.registrationValidity,
    required this.registrationStatus,
    required this.maker,
    required this.model,
    required this.vehicleCategory,
    required this.fuelType,
    required this.bodyType,
    required this.engineCapacity,
    required this.seatingCapacity,
    required this.manufacturingYear,
    required this.emissionStandard,
    required this.color,
    required this.maskedChassisNumber,
    required this.maskedEngineNumber,
    required this.maskedOwnerName,
    required this.maskedFatherName,
    required this.ownershipSerial,
    required this.maskedAddress,
    required this.insuranceCompany,
    required this.insurancePolicyNumber,
    required this.insuranceValidity,
    required this.insuranceStatus,
    required this.insuranceDaysRemaining,
    required this.pucCertificateNumber,
    required this.pucValidity,
    required this.pucStatus,
    required this.pucTestingCenter,
    required this.fitnessValidity,
    required this.permitValidity,
    required this.roadTaxStatus,
    required this.roadTaxPaidUpto,
    required this.isHypothecated,
    this.hypothecationBank,
    this.hypothecationStatus,
    this.isBlacklisted = false,
    this.isDemoData = true,
    this.dataSourceLabel = 'Demonstration Record (Mock Parivahan)',
  });

  Map<String, dynamic> toMap() {
    return {
      'registrationNumber': registrationNumber,
      'cleanRegistrationNumber': cleanRegistrationNumber,
      'registrationDate': registrationDate,
      'registrationAuthority': registrationAuthority,
      'rtoCode': rtoCode,
      'state': state,
      'vehicleClass': vehicleClass,
      'registrationValidity': registrationValidity,
      'registrationStatus': registrationStatus,
      'maker': maker,
      'model': model,
      'vehicleCategory': vehicleCategory,
      'fuelType': fuelType,
      'bodyType': bodyType,
      'engineCapacity': engineCapacity,
      'seatingCapacity': seatingCapacity,
      'manufacturingYear': manufacturingYear,
      'emissionStandard': emissionStandard,
      'color': color,
      'maskedChassisNumber': maskedChassisNumber,
      'maskedEngineNumber': maskedEngineNumber,
      'maskedOwnerName': maskedOwnerName,
      'maskedFatherName': maskedFatherName,
      'ownershipSerial': ownershipSerial,
      'maskedAddress': maskedAddress,
      'insuranceCompany': insuranceCompany,
      'insurancePolicyNumber': insurancePolicyNumber,
      'insuranceValidity': insuranceValidity,
      'insuranceStatus': insuranceStatus,
      'insuranceDaysRemaining': insuranceDaysRemaining,
      'pucCertificateNumber': pucCertificateNumber,
      'pucValidity': pucValidity,
      'pucStatus': pucStatus,
      'pucTestingCenter': pucTestingCenter,
      'fitnessValidity': fitnessValidity,
      'permitValidity': permitValidity,
      'roadTaxStatus': roadTaxStatus,
      'roadTaxPaidUpto': roadTaxPaidUpto,
      'isHypothecated': isHypothecated,
      'hypothecationBank': hypothecationBank,
      'hypothecationStatus': hypothecationStatus,
      'isBlacklisted': isBlacklisted,
      'isDemoData': isDemoData,
      'dataSourceLabel': dataSourceLabel,
    };
  }

  factory VehicleEntity.fromMap(Map<String, dynamic> map) {
    return VehicleEntity(
      registrationNumber: map['registrationNumber'] ?? '',
      cleanRegistrationNumber: map['cleanRegistrationNumber'] ?? '',
      registrationDate: map['registrationDate'] ?? '',
      registrationAuthority: map['registrationAuthority'] ?? '',
      rtoCode: map['rtoCode'] ?? '',
      state: map['state'] ?? '',
      vehicleClass: map['vehicleClass'] ?? '',
      registrationValidity: map['registrationValidity'] ?? '',
      registrationStatus: map['registrationStatus'] ?? 'ACTIVE',
      maker: map['maker'] ?? '',
      model: map['model'] ?? '',
      vehicleCategory: map['vehicleCategory'] ?? '',
      fuelType: map['fuelType'] ?? '',
      bodyType: map['bodyType'] ?? '',
      engineCapacity: map['engineCapacity'] ?? '',
      seatingCapacity: map['seatingCapacity'] is int
          ? map['seatingCapacity']
          : 5,
      manufacturingYear: map['manufacturingYear'] ?? '',
      emissionStandard: map['emissionStandard'] ?? '',
      color: map['color'] ?? '',
      maskedChassisNumber: map['maskedChassisNumber'] ?? '',
      maskedEngineNumber: map['maskedEngineNumber'] ?? '',
      maskedOwnerName: map['maskedOwnerName'] ?? '',
      maskedFatherName: map['maskedFatherName'] ?? '',
      ownershipSerial: map['ownershipSerial'] ?? '1st Owner',
      maskedAddress: map['maskedAddress'] ?? '',
      insuranceCompany: map['insuranceCompany'] ?? '',
      insurancePolicyNumber: map['insurancePolicyNumber'] ?? '',
      insuranceValidity: map['insuranceValidity'] ?? '',
      insuranceStatus: map['insuranceStatus'] ?? 'ACTIVE',
      insuranceDaysRemaining: map['insuranceDaysRemaining'] is int
          ? map['insuranceDaysRemaining']
          : 180,
      pucCertificateNumber: map['pucCertificateNumber'] ?? '',
      pucValidity: map['pucValidity'] ?? '',
      pucStatus: map['pucStatus'] ?? 'ACTIVE',
      pucTestingCenter: map['pucTestingCenter'] ?? '',
      fitnessValidity: map['fitnessValidity'] ?? '',
      permitValidity: map['permitValidity'] ?? 'Exempted (Private Vehicle)',
      roadTaxStatus: map['roadTaxStatus'] ?? 'LTT Paid',
      roadTaxPaidUpto: map['roadTaxPaidUpto'] ?? 'Life Time',
      isHypothecated: map['isHypothecated'] == true,
      hypothecationBank: map['hypothecationBank'],
      hypothecationStatus: map['hypothecationStatus'],
      isBlacklisted: map['isBlacklisted'] == true,
      isDemoData: map['isDemoData'] != false,
      dataSourceLabel:
          map['dataSourceLabel'] ?? 'Demonstration Record (Mock Parivahan)',
    );
  }

  /// Displays unavailable information as 'Not Available' instead of inventing values.
  static String safeValue(String? value, {String fallback = 'Not Available'}) {
    if (value == null || value.trim().isEmpty) return fallback;
    return value.trim();
  }
}
