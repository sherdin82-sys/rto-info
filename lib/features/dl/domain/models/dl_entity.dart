/// Represents an authorized vehicle class on a Driving Licence.
class DlVehicleClass {
  final String classCode; // e.g. MCWG, LMV, HMV, TRANS
  final String description; // e.g. Motor Cycle With Gear, Light Motor Vehicle
  final String issueDate;

  const DlVehicleClass({
    required this.classCode,
    required this.description,
    required this.issueDate,
  });

  Map<String, dynamic> toMap() => {
    'classCode': classCode,
    'description': description,
    'issueDate': issueDate,
  };

  factory DlVehicleClass.fromMap(Map<String, dynamic> map) => DlVehicleClass(
    classCode: map['classCode'] ?? '',
    description: map['description'] ?? '',
    issueDate: map['issueDate'] ?? '',
  );
}

/// Domain model for an Indian Driving Licence (Sarathi Parivahan).
class DlEntity {
  final String dlNumber;
  final String cleanDlNumber;
  final String holderName;
  final String maskedHolderName;
  final String fatherName;
  final String maskedFatherName;
  final String dob;
  final String bloodGroup;
  final String issueDate;
  final String validityNonTransport;
  final String validityTransport;
  final String issuingAuthority;
  final String state;
  final String status; // ACTIVE, EXPIRED, SUSPENDED
  final List<DlVehicleClass> vehicleClasses;
  final bool isCommercial;
  final String? badgeNumber;

  const DlEntity({
    required this.dlNumber,
    required this.cleanDlNumber,
    required this.holderName,
    required this.maskedHolderName,
    required this.fatherName,
    required this.maskedFatherName,
    required this.dob,
    required this.bloodGroup,
    required this.issueDate,
    required this.validityNonTransport,
    required this.validityTransport,
    required this.issuingAuthority,
    required this.state,
    required this.status,
    required this.vehicleClasses,
    this.isCommercial = false,
    this.badgeNumber,
  });

  bool get isValid => status.toUpperCase() == 'ACTIVE';

  Map<String, dynamic> toMap() => {
    'dlNumber': dlNumber,
    'cleanDlNumber': cleanDlNumber,
    'holderName': holderName,
    'maskedHolderName': maskedHolderName,
    'fatherName': fatherName,
    'maskedFatherName': maskedFatherName,
    'dob': dob,
    'bloodGroup': bloodGroup,
    'issueDate': issueDate,
    'validityNonTransport': validityNonTransport,
    'validityTransport': validityTransport,
    'issuingAuthority': issuingAuthority,
    'state': state,
    'status': status,
    'vehicleClasses': vehicleClasses.map((c) => c.toMap()).toList(),
    'isCommercial': isCommercial,
    'badgeNumber': badgeNumber,
  };

  factory DlEntity.fromMap(Map<String, dynamic> map) {
    return DlEntity(
      dlNumber: map['dlNumber'] ?? '',
      cleanDlNumber: map['cleanDlNumber'] ?? '',
      holderName: map['holderName'] ?? '',
      maskedHolderName: map['maskedHolderName'] ?? '',
      fatherName: map['fatherName'] ?? '',
      maskedFatherName: map['maskedFatherName'] ?? '',
      dob: map['dob'] ?? '',
      bloodGroup: map['bloodGroup'] ?? 'N/A',
      issueDate: map['issueDate'] ?? '',
      validityNonTransport: map['validityNonTransport'] ?? '',
      validityTransport: map['validityTransport'] ?? 'N/A',
      issuingAuthority: map['issuingAuthority'] ?? '',
      state: map['state'] ?? '',
      status: map['status'] ?? 'ACTIVE',
      vehicleClasses: (map['vehicleClasses'] as List<dynamic>?)
              ?.map((c) => DlVehicleClass.fromMap(c as Map<String, dynamic>))
              .toList() ??
          [],
      isCommercial: map['isCommercial'] == true,
      badgeNumber: map['badgeNumber'],
    );
  }
}
