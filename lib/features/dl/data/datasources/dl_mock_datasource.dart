import '../../domain/models/dl_entity.dart';

/// DlMockDataSource provides mock and dynamically generated Sarathi Parivahan DL records.
class DlMockDataSource {
  static final Map<String, DlEntity> _seededLicences = {
    'DL0420110149632': const DlEntity(
      dlNumber: 'DL-0420110149632',
      cleanDlNumber: 'DL0420110149632',
      holderName: 'RAGHAV SHARMA',
      maskedHolderName: 'R****V S****A',
      fatherName: 'SURESH CHANDRA SHARMA',
      maskedFatherName: 'S****H C****A S****A',
      dob: '14-May-1990',
      bloodGroup: 'B+ POSITIVE',
      issueDate: '14-May-2011',
      validityNonTransport: '13-May-2031',
      validityTransport: 'Exempted (Non-Transport)',
      issuingAuthority: 'Janakpuri Zonal Office (DL-04)',
      state: 'Delhi',
      status: 'ACTIVE',
      isCommercial: false,
      vehicleClasses: [
        DlVehicleClass(
          classCode: 'MCWG',
          description: 'Motorcycle with Gear',
          issueDate: '14-May-2011',
        ),
        DlVehicleClass(
          classCode: 'LMV',
          description: 'Light Motor Vehicle (Car/Jeep)',
          issueDate: '14-May-2011',
        ),
      ],
    ),
    'MH1420180019284': const DlEntity(
      dlNumber: 'MH-1420180019284',
      cleanDlNumber: 'MH1420180019284',
      holderName: 'ADITYA DESHMUKH',
      maskedHolderName: 'A****A D****H',
      fatherName: 'RAMESH DESHMUKH',
      maskedFatherName: 'R****H D****H',
      dob: '22-Aug-1996',
      bloodGroup: 'O+ POSITIVE',
      issueDate: '05-Sep-2018',
      validityNonTransport: '21-Aug-2036',
      validityTransport: '04-Sep-2028',
      issuingAuthority: 'Pimpri-Chinchwad RTO (MH-14)',
      state: 'Maharashtra',
      status: 'ACTIVE',
      isCommercial: true,
      badgeNumber: 'BDG/MH14/2019/8412',
      vehicleClasses: [
        DlVehicleClass(
          classCode: 'MCWG',
          description: 'Motorcycle with Gear',
          issueDate: '05-Sep-2018',
        ),
        DlVehicleClass(
          classCode: 'LMV',
          description: 'Light Motor Vehicle (Car/Cab)',
          issueDate: '05-Sep-2018',
        ),
        DlVehicleClass(
          classCode: 'TRANS',
          description: 'Transport Vehicle (Commercial)',
          issueDate: '12-Nov-2019',
        ),
      ],
    ),
    'KA0120150038192': const DlEntity(
      dlNumber: 'KA-0120150038192',
      cleanDlNumber: 'KA0120150038192',
      holderName: 'PRIYA NAIR',
      maskedHolderName: 'P***A N**R',
      fatherName: 'K NAIR',
      maskedFatherName: 'K N**R',
      dob: '10-Nov-1993',
      bloodGroup: 'A+ POSITIVE',
      issueDate: '15-Dec-2015',
      validityNonTransport: '09-Nov-2033',
      validityTransport: 'Exempted (Non-Transport)',
      issuingAuthority: 'Koramangala RTO (KA-01)',
      state: 'Karnataka',
      status: 'ACTIVE',
      isCommercial: false,
      vehicleClasses: [
        DlVehicleClass(
          classCode: 'LMV',
          description: 'Light Motor Vehicle (Car)',
          issueDate: '15-Dec-2015',
        ),
      ],
    ),
  };

  /// Retrieves DL details by cleaned number e.g. "DL0420110149632"
  Future<DlEntity?> getDlDetails(String inputNumber) async {
    final clean = inputNumber.toUpperCase().replaceAll(
      RegExp(r'[^A-Z0-9]'),
      '',
    );
    if (clean.length < 10) return null;

    if (_seededLicences.containsKey(clean)) {
      return _seededLicences[clean];
    }

    // Dynamic fallback generation for any valid DL pattern
    return _generateDynamicDl(clean);
  }

  DlEntity _generateDynamicDl(String clean) {
    final stateCode = clean.substring(0, 2);
    final rtoNum = clean.length >= 4 ? clean.substring(2, 4) : '01';
    final formattedDl = '$stateCode-$rtoNum ${clean.substring(4)}';

    return DlEntity(
      dlNumber: formattedDl,
      cleanDlNumber: clean,
      holderName: 'PARIVAHAN LICENCE HOLDER',
      maskedHolderName: 'P*******N H****R',
      fatherName: 'LICENCE GUARDIAN',
      maskedFatherName: 'L*****E G******N',
      dob: '15-Aug-1992',
      bloodGroup: 'B+ POSITIVE',
      issueDate: '20-Oct-2016',
      validityNonTransport: '14-Aug-2036',
      validityTransport: 'Exempted (Non-Transport)',
      issuingAuthority: 'Regional Transport Office ($stateCode-$rtoNum)',
      state: stateCode,
      status: 'ACTIVE',
      isCommercial: false,
      vehicleClasses: const [
        DlVehicleClass(
          classCode: 'MCWG',
          description: 'Motorcycle with Gear',
          issueDate: '20-Oct-2016',
        ),
        DlVehicleClass(
          classCode: 'LMV',
          description: 'Light Motor Vehicle (Car/Jeep)',
          issueDate: '20-Oct-2016',
        ),
      ],
    );
  }
}
