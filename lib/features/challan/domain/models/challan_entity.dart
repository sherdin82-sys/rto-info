/// ChallanEntity represents traffic violation details under Motor Vehicles Act.
class ChallanEntity {
  final String challanNumber;
  final String registrationNumber;
  final String violationDescription;
  final String legalSection;
  final String challanDate;
  final double challanAmount;
  final String paymentStatus; // PENDING / PAID
  final String location;
  final String trafficPoliceUnit;
  final String cameraCode;
  final String? paymentReceiptNumber;
  final String? paidAt;
  final String officialPaymentPortalUrl;

  const ChallanEntity({
    required this.challanNumber,
    required this.registrationNumber,
    required this.violationDescription,
    required this.legalSection,
    required this.challanDate,
    required this.challanAmount,
    required this.paymentStatus,
    required this.location,
    required this.trafficPoliceUnit,
    required this.cameraCode,
    this.paymentReceiptNumber,
    this.paidAt,
    this.officialPaymentPortalUrl = 'https://echallan.parivahan.gov.in/',
  });

  bool get isPaid => paymentStatus.toUpperCase() == 'PAID';
  bool get isPending => paymentStatus.toUpperCase() == 'PENDING';

  Map<String, dynamic> toMap() {
    return {
      'challanNumber': challanNumber,
      'registrationNumber': registrationNumber,
      'violationDescription': violationDescription,
      'legalSection': legalSection,
      'challanDate': challanDate,
      'challanAmount': challanAmount,
      'paymentStatus': paymentStatus,
      'location': location,
      'trafficPoliceUnit': trafficPoliceUnit,
      'cameraCode': cameraCode,
      'paymentReceiptNumber': paymentReceiptNumber,
      'paidAt': paidAt,
      'officialPaymentPortalUrl': officialPaymentPortalUrl,
    };
  }

  factory ChallanEntity.fromMap(Map<String, dynamic> map) {
    return ChallanEntity(
      challanNumber: map['challanNumber'] ?? '',
      registrationNumber: map['registrationNumber'] ?? '',
      violationDescription: map['violationDescription'] ?? '',
      legalSection: map['legalSection'] ?? '',
      challanDate: map['challanDate'] ?? '',
      challanAmount: (map['challanAmount'] is num)
          ? (map['challanAmount'] as num).toDouble()
          : 0.0,
      paymentStatus: map['paymentStatus'] ?? 'PENDING',
      location: map['location'] ?? '',
      trafficPoliceUnit: map['trafficPoliceUnit'] ?? '',
      cameraCode: map['cameraCode'] ?? '',
      paymentReceiptNumber: map['paymentReceiptNumber'],
      paidAt: map['paidAt'],
      officialPaymentPortalUrl:
          map['officialPaymentPortalUrl'] ??
          'https://echallan.parivahan.gov.in/',
    );
  }
}
