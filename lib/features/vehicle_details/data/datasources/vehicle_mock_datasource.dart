import '../../domain/models/vehicle_entity.dart';
import 'vehicle_data_source.dart';
import '../../../../core/utils/vehicle_number_validator.dart';

/// VehicleMockDataSource provides realistic Parivahan Vahan compliant vehicle profiles.
/// Includes curated sample vehicles and a deterministic generator for any valid Indian plate.
class VehicleMockDataSource implements VehicleDataSource {
  static const Map<String, Map<String, dynamic>> _seededVehicles = {
    'DL01AB1234': {
      'registrationNumber': 'DL 01 AB 1234',
      'cleanRegistrationNumber': 'DL01AB1234',
      'registrationDate': '12-Apr-2023',
      'registrationAuthority':
          'Regional Transport Office, Mall Road, Civil Lines',
      'rtoCode': 'DL-01',
      'state': 'Delhi',
      'vehicleClass': 'Motor Car (LMV)',
      'registrationValidity': '11-Apr-2038',
      'registrationStatus': 'ACTIVE',
      'maker': 'MARUTI SUZUKI INDIA LTD',
      'model': 'SWIFT VXI 1.2L DUALJET',
      'vehicleCategory': 'Passenger Car',
      'fuelType': 'PETROL',
      'bodyType': 'Hatchback',
      'engineCapacity': '1197 cc',
      'seatingCapacity': 5,
      'manufacturingYear': '2023',
      'emissionStandard': 'BHARAT STAGE VI (OBD-II PHASE 2)',
      'color': 'MAGMA GREY',
      'maskedChassisNumber': 'MA3EWFB1S***28114',
      'maskedEngineNumber': 'K12MN***1092',
      'maskedOwnerName': 'R****H K***R S****A',
      'maskedFatherName': 'S****H C****R S****A',
      'ownershipSerial': '1st Owner',
      'maskedAddress': 'Civil Lines, North Delhi, Delhi - 110054',
      'insuranceCompany': 'Tata AIG General Insurance Co. Ltd.',
      'insurancePolicyNumber': '016284918239011',
      'insuranceValidity': '09-Apr-2027',
      'insuranceStatus': 'ACTIVE',
      'insuranceDaysRemaining': 145,
      'pucCertificateNumber': 'DL0100492810',
      'pucValidity': '14-May-2027',
      'pucStatus': 'ACTIVE',
      'pucTestingCenter': 'Authorized PUC Center #44, Mall Road',
      'fitnessValidity': '11-Apr-2038',
      'permitValidity': 'Not Applicable (Private Vehicle)',
      'roadTaxStatus': 'LIFE TIME TAX (LTT) PAID',
      'roadTaxPaidUpto': 'Life Time (15 Years)',
      'isHypothecated': true,
      'hypothecationBank': 'HDFC Bank Limited',
      'hypothecationStatus': 'ACTIVE LOAN',
      'isBlacklisted': false,
    },
    'MH12DE1433': {
      'registrationNumber': 'MH 12 DE 1433',
      'cleanRegistrationNumber': 'MH12DE1433',
      'registrationDate': '20-Sep-2022',
      'registrationAuthority': 'Regional Transport Office, Sangam Bridge, Pune',
      'rtoCode': 'MH-12',
      'state': 'Maharashtra',
      'vehicleClass': 'Motor Car (LMV)',
      'registrationValidity': '19-Sep-2037',
      'registrationStatus': 'ACTIVE',
      'maker': 'HYUNDAI MOTOR INDIA LTD',
      'model': 'CRETA 1.5L CRDI SX(O)',
      'vehicleCategory': 'Compact SUV',
      'fuelType': 'DIESEL',
      'bodyType': 'SUV',
      'engineCapacity': '1493 cc',
      'seatingCapacity': 5,
      'manufacturingYear': '2022',
      'emissionStandard': 'BHARAT STAGE VI (BS-VI)',
      'color': 'POLAR WHITE',
      'maskedChassisNumber': 'MALC381CL***72183',
      'maskedEngineNumber': 'D4FALN***2190',
      'maskedOwnerName': 'A****Y V***N J***I',
      'maskedFatherName': 'V***N K****R J***I',
      'ownershipSerial': '1st Owner',
      'maskedAddress': 'Shivajinagar, Pune, Maharashtra - 411005',
      'insuranceCompany': 'ICICI Lombard General Insurance Co. Ltd.',
      'insurancePolicyNumber': '3001/29184719/00/000',
      'insuranceValidity': '17-Sep-2027',
      'insuranceStatus': 'ACTIVE',
      'insuranceDaysRemaining': 306,
      'pucCertificateNumber': 'MH1200984712',
      'pucValidity': '24-Mar-2027',
      'pucStatus': 'ACTIVE',
      'pucTestingCenter': 'Pune Station Auto PUC Station',
      'fitnessValidity': '19-Sep-2037',
      'permitValidity': 'Not Applicable (Private Vehicle)',
      'roadTaxStatus': 'LIFE TIME TAX (LTT) PAID',
      'roadTaxPaidUpto': 'Life Time (15 Years)',
      'isHypothecated': true,
      'hypothecationBank': 'State Bank of India (SBI)',
      'hypothecationStatus': 'ACTIVE LOAN',
      'isBlacklisted': false,
    },
    'KA05MJ5005': {
      'registrationNumber': 'KA 05 MJ 5005',
      'cleanRegistrationNumber': 'KA05MJ5005',
      'registrationDate': '14-Feb-2024',
      'registrationAuthority': 'RTO Bengaluru South, Jayanagar',
      'rtoCode': 'KA-05',
      'state': 'Karnataka',
      'vehicleClass': 'Motor Car (Electric - BEV)',
      'registrationValidity': '13-Feb-2039',
      'registrationStatus': 'ACTIVE',
      'maker': 'TATA PASSENGER ELECTRIC MOBILITY',
      'model': 'NEXON.EV EMPOWERED PLUS LONG RANGE',
      'vehicleCategory': 'Electric SUV',
      'fuelType': 'ELECTRIC',
      'bodyType': 'SUV',
      'engineCapacity': '106.4 kW Motor',
      'seatingCapacity': 5,
      'manufacturingYear': '2024',
      'emissionStandard': 'ZERO EMISSION (EV)',
      'color': 'EMPOWERED OXIDE',
      'maskedChassisNumber': 'MAT625078***84912',
      'maskedEngineNumber': 'EM106KW***9981',
      'maskedOwnerName': 'P****N K***R N****K',
      'maskedFatherName': 'M****H N****K',
      'ownershipSerial': '1st Owner',
      'maskedAddress': 'Jayanagar, Bengaluru, Karnataka - 560011',
      'insuranceCompany': 'Go Digit General Insurance Ltd.',
      'insurancePolicyNumber': 'DGT-EV-9928194',
      'insuranceValidity': '09-Feb-2027',
      'insuranceStatus': 'ACTIVE',
      'insuranceDaysRemaining': 86,
      'pucCertificateNumber': 'EXEMPTED (BEV)',
      'pucValidity': 'Permanent Exemption',
      'pucStatus': 'EXEMPTED',
      'pucTestingCenter': 'Exempted for 100% Battery Electric Vehicles',
      'fitnessValidity': '13-Feb-2039',
      'permitValidity': 'Not Applicable (Private Vehicle)',
      'roadTaxStatus': 'CONCESSIONAL EV TAX (0%)',
      'roadTaxPaidUpto': 'Life Time Exemption',
      'isHypothecated': false,
      'hypothecationBank': null,
      'hypothecationStatus': 'NO HYPOTHECATION (CLEAN TITLE)',
      'isBlacklisted': false,
    },
    'HR26DQ5551': {
      'registrationNumber': 'HR 26 DQ 5551',
      'cleanRegistrationNumber': 'HR26DQ5551',
      'registrationDate': '19-Aug-2023',
      'registrationAuthority': 'RTO Gurugram North',
      'rtoCode': 'HR-26',
      'state': 'Haryana',
      'vehicleClass': 'Two Wheeler (MCWG)',
      'registrationValidity': '18-Aug-2038',
      'registrationStatus': 'ACTIVE',
      'maker': 'ROYAL ENFIELD (EICHER MOTORS)',
      'model': 'CLASSIC 350 DUAL CHANNEL ABS',
      'vehicleCategory': 'Motorcycle',
      'fuelType': 'PETROL',
      'bodyType': 'Motorcycle',
      'engineCapacity': '349 cc',
      'seatingCapacity': 2,
      'manufacturingYear': '2023',
      'emissionStandard': 'BHARAT STAGE VI (BS-VI)',
      'color': 'HALCYON BLACK',
      'maskedChassisNumber': 'ME3J350FG***19201',
      'maskedEngineNumber': 'J350EN***8491',
      'maskedOwnerName': 'V***M S****H C******N',
      'maskedFatherName': 'B****R S****H C******N',
      'ownershipSerial': '1st Owner',
      'maskedAddress': 'Sector 54, Gurugram, Haryana - 122002',
      'insuranceCompany': 'HDFC ERGO General Insurance Co. Ltd.',
      'insurancePolicyNumber': '2311/20048192/01/000',
      'insuranceValidity': '14-Aug-2026',
      'insuranceStatus': 'EXPIRED',
      'insuranceDaysRemaining': -93,
      'pucCertificateNumber': 'HR2600819201',
      'pucValidity': '09-Nov-2026',
      'pucStatus': 'EXPIRED',
      'pucTestingCenter': 'IFFCO Chowk Fuel Station, Gurugram',
      'fitnessValidity': '18-Aug-2038',
      'permitValidity': 'Not Applicable (Two Wheeler)',
      'roadTaxStatus': 'LIFE TIME TAX (LTT) PAID',
      'roadTaxPaidUpto': 'Life Time (15 Years)',
      'isHypothecated': false,
      'hypothecationBank': null,
      'hypothecationStatus': 'NO HYPOTHECATION (CLEAN TITLE)',
      'isBlacklisted': false,
    },
  };

  @override
  Future<VehicleEntity?> getVehicleDetails(String registrationNumber) async {
    // Artificial small delay to mimic async network retrieval
    await Future.delayed(const Duration(milliseconds: 350));

    final clean = VehicleNumberValidator.cleanPlate(registrationNumber);
    if (!VehicleNumberValidator.isValid(clean)) {
      return null;
    }

    // Return seeded record if present
    if (_seededVehicles.containsKey(clean)) {
      return VehicleEntity.fromMap(_seededVehicles[clean]!);
    }

    // Dynamic deterministic generator for any other valid Indian plate
    return _generateRealisticVehicle(clean);
  }

  VehicleEntity _generateRealisticVehicle(String clean) {
    final state = clean.substring(0, 2);
    final rtoNum = clean.substring(2, 4);
    final formatted = VehicleNumberValidator.formatForDisplay(clean);

    final hash = clean.codeUnits.reduce((a, b) => a + b);
    final isTwoWheeler = hash % 3 == 0;
    final isEv = hash % 7 == 0;

    final maker = isEv
        ? 'TATA PASSENGER ELECTRIC'
        : (isTwoWheeler ? 'BAJAJ AUTO LTD' : 'MARUTI SUZUKI INDIA LTD');

    final model = isEv
        ? 'PUNCH.EV SMART PLUS'
        : (isTwoWheeler ? 'PULSAR NS200 ABS' : 'BALENO ZETA 1.2L');

    final regYear = 2020 + (hash % 5);

    return VehicleEntity(
      registrationNumber: formatted,
      cleanRegistrationNumber: clean,
      registrationDate: '15-May-$regYear',
      registrationAuthority: 'Regional Transport Office ($state-$rtoNum)',
      rtoCode: '$state-$rtoNum',
      state: state,
      vehicleClass: isTwoWheeler
          ? 'Two Wheeler (MCWG)'
          : (isEv ? 'Motor Car (Electric)' : 'Motor Car (LMV)'),
      registrationValidity: '14-May-${regYear + 15}',
      registrationStatus: 'ACTIVE',
      maker: maker,
      model: model,
      vehicleCategory: isTwoWheeler ? 'Two Wheeler' : 'Passenger Car',
      fuelType: isEv ? 'ELECTRIC' : 'PETROL',
      bodyType: isTwoWheeler ? 'Motorcycle' : 'Hatchback / Sedan',
      engineCapacity: isEv
          ? '60 kW Motor'
          : (isTwoWheeler ? '199 cc' : '1197 cc'),
      seatingCapacity: isTwoWheeler ? 2 : 5,
      manufacturingYear: '$regYear',
      emissionStandard: isEv ? 'ZERO EMISSION (EV)' : 'BHARAT STAGE VI (BS-VI)',
      color: 'GLACIER WHITE',
      maskedChassisNumber: 'MA3${state}X***${hash % 90000 + 10000}',
      maskedEngineNumber: 'ENG***${hash % 90000 + 10000}',
      maskedOwnerName: 'A****K S****A',
      maskedFatherName: 'R****H S****A',
      ownershipSerial: '1st Owner',
      maskedAddress: 'District Transport Jurisdiction, $state',
      insuranceCompany: 'HDFC ERGO General Insurance Co. Ltd.',
      insurancePolicyNumber: 'POL-${hash * 31 % 9000000}',
      insuranceValidity: '14-May-2027',
      insuranceStatus: 'ACTIVE',
      insuranceDaysRemaining: 180,
      pucCertificateNumber: isEv
          ? 'EXEMPTED (BEV)'
          : 'PUC-$state-${hash % 90000}',
      pucValidity: isEv ? 'Permanent Exemption' : '14-May-2027',
      pucStatus: isEv ? 'EXEMPTED' : 'ACTIVE',
      pucTestingCenter: 'Government Authorized Testing Station',
      fitnessValidity: '14-May-${regYear + 15}',
      permitValidity: 'Not Applicable (Private Vehicle)',
      roadTaxStatus: 'LIFE TIME TAX (LTT) PAID',
      roadTaxPaidUpto: 'Life Time',
      isHypothecated: hash % 2 == 0,
      hypothecationBank: hash % 2 == 0 ? 'State Bank of India' : null,
      hypothecationStatus: hash % 2 == 0
          ? 'ACTIVE LOAN'
          : 'NO HYPOTHECATION (CLEAN TITLE)',
      isBlacklisted: false,
    );
  }
}
