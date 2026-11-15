import '../../domain/models/challan_entity.dart';

abstract class ChallanDataSource {
  Future<List<ChallanEntity>> getChallansForVehicle(String registrationNumber);
}

class ChallanMockDataSource implements ChallanDataSource {
  static final Map<String, List<ChallanEntity>> _seededChallans = {
    'DL01AB1234': [
      const ChallanEntity(
        challanNumber: 'DL240819004291',
        registrationNumber: 'DL 01 AB 1234',
        violationDescription: 'Over Speeding (LMV/Two Wheeler)',
        legalSection: 'Section 183(1) MV Act',
        challanDate: '14-Oct-2026, 11:24 AM',
        challanAmount: 2000.0,
        paymentStatus: 'PENDING',
        location: 'Ring Road near Kashmere Gate ISBT, North Delhi',
        trafficPoliceUnit: 'Delhi Traffic Police (Northern Range)',
        cameraCode: 'CCTV-KG-N44',
      ),
      const ChallanEntity(
        challanNumber: 'DL240702008819',
        registrationNumber: 'DL 01 AB 1234',
        violationDescription: 'Zebra Crossing / Stop Line Violation',
        legalSection: 'Section 177 MV Act',
        challanDate: '05-Aug-2026, 09:12 AM',
        challanAmount: 500.0,
        paymentStatus: 'PAID',
        location: 'ITO Junction Signal, New Delhi',
        trafficPoliceUnit: 'Delhi Traffic Police (Central Range)',
        cameraCode: 'RLVD-ITO-02',
        paymentReceiptNumber: 'RCP-2026-DL-8819',
        paidAt: '09-Aug-2026',
      ),
    ],
    'MH12DE1433': [
      const ChallanEntity(
        challanNumber: 'MH241101007812',
        registrationNumber: 'MH 12 DE 1433',
        violationDescription: 'Dangerous / Rash Driving & Red Light Jump',
        legalSection: 'Section 184 MV Act',
        challanDate: '28-Oct-2026, 05:45 PM',
        challanAmount: 1000.0,
        paymentStatus: 'PENDING',
        location: 'FC Road Good Luck Chowk, Pune',
        trafficPoliceUnit: 'Pune City Traffic Police (Deccan Division)',
        cameraCode: 'ITMS-PUN-GL01',
      ),
    ],
  };

  @override
  Future<List<ChallanEntity>> getChallansForVehicle(
    String registrationNumber,
  ) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final clean = registrationNumber.toUpperCase().replaceAll(
      RegExp(r'[^A-Z0-9]'),
      '',
    );

    if (_seededChallans.containsKey(clean)) {
      return _seededChallans[clean]!;
    }

    // Deterministic generation
    final hash = clean.codeUnits.reduce((a, b) => a + b);
    if (hash % 3 == 0) {
      return [];
    }

    return [
      ChallanEntity(
        challanNumber: '${clean.substring(0, 4)}26${hash % 900000 + 100000}',
        registrationNumber: registrationNumber,
        violationDescription: 'Driving / Riding without BIS Helmet',
        legalSection: 'Section 129 / 194D MV Act',
        challanDate: '18-Sep-2026, 10:15 AM',
        challanAmount: 1000.0,
        paymentStatus: (hash % 2 == 0) ? 'PENDING' : 'PAID',
        location:
            'Main Traffic Signal Corridor, ${clean.substring(0, 2)} State',
        trafficPoliceUnit: 'State Automated Traffic Enforcement Branch',
        cameraCode: 'ITMS-CAM-${hash % 90 + 10}',
        paymentReceiptNumber: (hash % 2 == 0) ? null : 'RCP-2026-${hash}',
        paidAt: (hash % 2 == 0) ? null : '20-Sep-2026',
      ),
    ];
  }
}
