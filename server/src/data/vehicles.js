import { findRtoByRegistration } from './rtoOffices.js';

// Curated catalog of Indian vehicle models across segments
export const VEHICLE_MODELS = [
  // LMV Cars (Petrol / Diesel / Hybrid)
  { maker: 'MARUTI SUZUKI INDIA LTD', model: 'SWIFT VXI 1.2L DUALJET', vehicleClass: 'Motor Car (LMV)', fuel: 'PETROL', cc: 1197, cylinders: 4, seats: 5, color: 'MAGMA GREY', weight: 890 },
  { maker: 'MARUTI SUZUKI INDIA LTD', model: 'BALENO ZETA 1.2 DUALJET', vehicleClass: 'Motor Car (LMV)', fuel: 'PETROL', cc: 1197, cylinders: 4, seats: 5, color: 'NEXA BLUE', weight: 935 },
  { maker: 'MARUTI SUZUKI INDIA LTD', model: 'BREZZA ZXI PLUS AT', vehicleClass: 'Motor Car (LMV)', fuel: 'PETROL', cc: 1462, cylinders: 4, seats: 5, color: 'SPLENDID SILVER', weight: 1190 },
  { maker: 'HYUNDAI MOTOR INDIA LTD', model: 'CRETA 1.5L CRDI SX(O) DIESEL', vehicleClass: 'Motor Car (LMV)', fuel: 'DIESEL', cc: 1493, cylinders: 4, seats: 5, color: 'POLAR WHITE', weight: 1340 },
  { maker: 'HYUNDAI MOTOR INDIA LTD', model: 'VENUE SX 1.0 TURBO GDI DCT', vehicleClass: 'Motor Car (LMV)', fuel: 'PETROL', cc: 998, cylinders: 3, seats: 5, color: 'TITAN GREY', weight: 1145 },
  { maker: 'TATA MOTORS PASSENGER VEHICLES', model: 'NEXON FEARLESS PLUS S DIESEL', vehicleClass: 'Motor Car (LMV)', fuel: 'DIESEL', cc: 1497, cylinders: 4, seats: 5, color: 'DAYTONA GREY', weight: 1260 },
  { maker: 'TATA MOTORS PASSENGER VEHICLES', model: 'PUNCH CREATIVE DUAL TONE', vehicleClass: 'Motor Car (LMV)', fuel: 'PETROL', cc: 1199, cylinders: 3, seats: 5, color: 'CALYPSO RED', weight: 1010 },
  { maker: 'MAHINDRA & MAHINDRA LTD', model: 'THAR LX 4X4 HARD TOP DIESEL AT', vehicleClass: 'Motor Car (LMV)', fuel: 'DIESEL', cc: 2184, cylinders: 4, seats: 4, color: 'NAPOLI BLACK', weight: 1750 },
  { maker: 'MAHINDRA & MAHINDRA LTD', model: 'SCORPIO-N Z8 L 4WD DIESEL', vehicleClass: 'Motor Car (LMV)', fuel: 'DIESEL', cc: 2198, cylinders: 4, seats: 7, color: 'DEEP FOREST', weight: 2100 },
  { maker: 'TOYOTA KIRLOSKAR MOTOR', model: 'INNOVA HYCROSS VX STRONG HYBRID', vehicleClass: 'Motor Car (LMV)', fuel: 'HYBRID', cc: 1987, cylinders: 4, seats: 8, color: 'PEARL WHITE', weight: 1680 },
  { maker: 'KIA INDIA PVT LTD', model: 'SELTOS GTX PLUS 1.5 TURBO PETROL', vehicleClass: 'Motor Car (LMV)', fuel: 'PETROL', cc: 1482, cylinders: 4, seats: 5, color: 'GLACIER WHITE PEARL', weight: 1360 },

  // Electric Vehicles (Green Plate)
  { maker: 'TATA PASSENGER ELECTRIC MOBILITY', model: 'NEXON.EV EMPOWERED PLUS LONG RANGE', vehicleClass: 'Motor Car (LMV - Electric)', fuel: 'ELECTRIC', cc: '106.4 kW', cylinders: 0, seats: 5, color: 'EMPOWERED OXIDE', weight: 1400 },
  { maker: 'MAHINDRA ELECTRIC VEHICLES', model: 'XUV400 EL PRO 39.4 KWH', vehicleClass: 'Motor Car (LMV - Electric)', fuel: 'ELECTRIC', cc: '110 kW', cylinders: 0, seats: 5, color: 'ARCTIC BLUE', weight: 1580 },
  { maker: 'OLA ELECTRIC TECHNOLOGIES', model: 'OLA S1 PRO GEN 2 ELECTRIC SCOOTER', vehicleClass: 'Two Wheeler (Electric)', fuel: 'ELECTRIC', cc: '11 kW', cylinders: 0, seats: 2, color: 'MIDNIGHT BLUE', weight: 116 },
  { maker: 'ATHER ENERGY PVT LTD', model: 'ATHER 450X GEN 3 APEX', vehicleClass: 'Two Wheeler (Electric)', fuel: 'ELECTRIC', cc: '6.4 kW', cylinders: 0, seats: 2, color: 'INDIGO BLUE', weight: 111 },

  // Two Wheelers (Bikes & Scooters)
  { maker: 'ROYAL ENFIELD (EICHER MOTORS)', model: 'CLASSIC 350 DUAL CHANNEL ABS', vehicleClass: 'Two Wheeler (MCWG)', fuel: 'PETROL', cc: 349, cylinders: 1, seats: 2, color: 'HALCYON BLACK', weight: 195 },
  { maker: 'ROYAL ENFIELD (EICHER MOTORS)', model: 'HUNTER 350 REBEL EDITION', vehicleClass: 'Two Wheeler (MCWG)', fuel: 'PETROL', cc: 349, cylinders: 1, seats: 2, color: 'DAPPER GREY', weight: 181 },
  { maker: 'HONDA MOTORCYCLE & SCOOTER INDIA', model: 'ACTIVA 6G SMART KEY DELUXE', vehicleClass: 'Two Wheeler (Non-Transport)', fuel: 'PETROL', cc: 109, cylinders: 1, seats: 2, color: 'PEARL SIREN BLUE', weight: 106 },
  { maker: 'HERO MOTOCORP LTD', model: 'SPLENDOR PLUS XTEC I3S', vehicleClass: 'Two Wheeler (MCWG)', fuel: 'PETROL', cc: 97, cylinders: 1, seats: 2, color: 'BLACK WITH PURPLE', weight: 112 },
  { maker: 'BAJAJ AUTO LTD', model: 'PULSAR NS200 DUAL CHANNEL ABS', vehicleClass: 'Two Wheeler (MCWG)', fuel: 'PETROL', cc: 199, cylinders: 1, seats: 2, color: 'BURNT RED', weight: 158 },
  { maker: 'TVS MOTOR COMPANY LTD', model: 'APACHE RTR 160 4V SPECIAL EDITION', vehicleClass: 'Two Wheeler (MCWG)', fuel: 'PETROL', cc: 159, cylinders: 1, seats: 2, color: 'MATTE BLACK', weight: 144 }
];

// Insurance providers list
export const INSURANCE_COMPANIES = [
  'HDFC ERGO General Insurance Co. Ltd.',
  'Tata AIG General Insurance Co. Ltd.',
  'ICICI Lombard General Insurance Co. Ltd.',
  'Bajaj Allianz General Insurance Co. Ltd.',
  'The New India Assurance Co. Ltd.',
  'SBI General Insurance Company Ltd.',
  'Go Digit General Insurance Limited',
  'Acko General Insurance Ltd.'
];

// Hypothecation Banks
export const FINANCIER_BANKS = [
  'HDFC BANK LIMITED',
  'STATE BANK OF INDIA (SBI)',
  'ICICI BANK LIMITED',
  'KOTAK MAHINDRA PRIME LTD',
  'AXIS BANK LIMITED',
  'BAJAJ FINANCE LIMITED',
  'SUNDARAM FINANCE LIMITED'
];

// Seeded real-world sample vehicles for fast testing
export const SEEDED_VEHICLES = {
  'DL01AB1234': {
    regNo: 'DL 01 AB 1234',
    cleanRegNo: 'DL01AB1234',
    ownerName: 'R****H K***R S****A',
    ownershipSerial: '1st Owner',
    fatherName: 'S****H C****R S****A',
    presentAddress: 'A-42, Mall Road, Civil Lines, North Delhi - 110054',
    permanentAddress: 'A-42, Mall Road, Civil Lines, North Delhi - 110054',
    maker: 'MARUTI SUZUKI INDIA LTD',
    model: 'SWIFT VXI 1.2L DUALJET',
    vehicleClass: 'Motor Car (LMV)',
    bodyType: 'Hatchback / Saloon',
    color: 'MAGMA GREY',
    fuel: 'PETROL',
    emissionNorms: 'BHARAT STAGE VI (OBD-II PHASE 2)',
    engineNo: 'K12MN4821092',
    chassisNo: 'MA3EWFB1SN4928114',
    cubicCapacity: '1197 cc',
    seatingCapacity: 5,
    standingCapacity: 0,
    unladenWeight: '890 KG',
    grossWeight: '1335 KG',
    wheelbase: '2450 mm',
    regDate: '2023-04-12',
    vehicleAge: '3 Years 7 Months',
    fitnessUpto: '2038-04-11',
    insurance: {
      company: 'Tata AIG General Insurance Co. Ltd.',
      policyNo: '016284918239011',
      validFrom: '2026-04-10',
      validUpto: '2027-04-09',
      status: 'ACTIVE',
      daysRemaining: 145
    },
    puc: {
      certificateNo: 'DL0100492810',
      validFrom: '2026-05-15',
      validUpto: '2027-05-14',
      status: 'ACTIVE',
      testingCenter: 'Delhi Metro Fuel Point, Mall Road'
    },
    tax: {
      status: 'LIFE TIME TAX (LTT) PAID',
      paidUpto: 'LIFE TIME (15 YEARS)',
      receiptNo: 'DL-LTT-2023-99182'
    },
    hypothecation: {
      isHypothecated: true,
      bank: 'HDFC BANK LIMITED',
      branch: 'Civil Lines, Delhi',
      status: 'ACTIVE LOAN'
    },
    status: 'ACTIVE',
    blacklisted: false,
    permit: {
      type: 'Not Applicable (Private Vehicle)',
      status: 'EXEMPTED'
    }
  },
  'MH12DE1433': {
    regNo: 'MH 12 DE 1433',
    cleanRegNo: 'MH12DE1433',
    ownerName: 'A****Y V***N J***I',
    ownershipSerial: '1st Owner',
    fatherName: 'V***N K****R J***I',
    presentAddress: 'Flat 402, Shivneri Heights, FC Road, Shivajinagar, Pune - 411005',
    permanentAddress: 'Flat 402, Shivneri Heights, FC Road, Shivajinagar, Pune - 411005',
    maker: 'HYUNDAI MOTOR INDIA LTD',
    model: 'CRETA 1.5L CRDI SX(O) DIESEL',
    vehicleClass: 'Motor Car (LMV)',
    bodyType: 'SUV / Compact Crossover',
    color: 'POLAR WHITE',
    fuel: 'DIESEL',
    emissionNorms: 'BHARAT STAGE VI (BS-VI)',
    engineNo: 'D4FALN882190',
    chassisNo: 'MALC381CLMN772183',
    cubicCapacity: '1493 cc',
    seatingCapacity: 5,
    standingCapacity: 0,
    unladenWeight: '1340 KG',
    grossWeight: '1810 KG',
    wheelbase: '2610 mm',
    regDate: '2022-09-20',
    vehicleAge: '4 Years 2 Months',
    fitnessUpto: '2037-09-19',
    insurance: {
      company: 'ICICI Lombard General Insurance Co. Ltd.',
      policyNo: '3001/29184719/00/000',
      validFrom: '2026-09-18',
      validUpto: '2027-09-17',
      status: 'ACTIVE',
      daysRemaining: 306
    },
    puc: {
      certificateNo: 'MH1200984712',
      validFrom: '2026-09-25',
      validUpto: '2027-03-24',
      status: 'ACTIVE',
      testingCenter: 'Shivaji Auto Services PUC Center, Pune'
    },
    tax: {
      status: 'LIFE TIME TAX (LTT) PAID',
      paidUpto: 'LIFE TIME (15 YEARS)',
      receiptNo: 'MH-LTT-2022-48192'
    },
    hypothecation: {
      isHypothecated: true,
      bank: 'STATE BANK OF INDIA (SBI)',
      branch: 'Deccan Gymkhana, Pune',
      status: 'ACTIVE LOAN'
    },
    status: 'ACTIVE',
    blacklisted: false,
    permit: {
      type: 'Not Applicable (Private Vehicle)',
      status: 'EXEMPTED'
    }
  },
  'KA05MJ5005': {
    regNo: 'KA 05 MJ 5005',
    cleanRegNo: 'KA05MJ5005',
    ownerName: 'P****N K***R N****K',
    ownershipSerial: '1st Owner',
    fatherName: 'M****H N****K',
    presentAddress: '24, 7th Cross, 4th Block, Jayanagar, Bengaluru - 560011',
    permanentAddress: '24, 7th Cross, 4th Block, Jayanagar, Bengaluru - 560011',
    maker: 'TATA PASSENGER ELECTRIC MOBILITY',
    model: 'NEXON.EV EMPOWERED PLUS LONG RANGE',
    vehicleClass: 'Motor Car (LMV - Electric)',
    bodyType: 'SUV / Electric',
    color: 'EMPOWERED OXIDE',
    fuel: 'ELECTRIC',
    emissionNorms: 'ZERO EMISSION (EV)',
    engineNo: 'EM-106KW-2024-9981',
    chassisNo: 'MAT625078N2E84912',
    cubicCapacity: '106.4 kW Motor',
    seatingCapacity: 5,
    standingCapacity: 0,
    unladenWeight: '1400 KG',
    grossWeight: '1850 KG',
    wheelbase: '2498 mm',
    regDate: '2024-02-14',
    vehicleAge: '2 Years 9 Months',
    fitnessUpto: '2039-02-13',
    insurance: {
      company: 'Go Digit General Insurance Limited',
      policyNo: 'DGT-EV-9928194',
      validFrom: '2026-02-10',
      validUpto: '2027-02-09',
      status: 'ACTIVE',
      daysRemaining: 86
    },
    puc: {
      certificateNo: 'NOT APPLICABLE',
      validFrom: 'NOT APPLICABLE',
      validUpto: 'EXEMPTED (100% BEV)',
      status: 'EXEMPTED',
      testingCenter: 'Exempted for Zero Emission Electric Vehicles'
    },
    tax: {
      status: 'EXEMPTED / 0% EV TAX POLICY',
      paidUpto: 'PERMANENT EXEMPTION',
      receiptNo: 'KA-EV-2024-00192'
    },
    hypothecation: {
      isHypothecated: false,
      bank: null,
      branch: null,
      status: 'NO HYPOTHECATION (CLEAN TITLE)'
    },
    status: 'ACTIVE',
    blacklisted: false,
    permit: {
      type: 'Not Applicable (Private Vehicle)',
      status: 'EXEMPTED'
    }
  },
  'HR26DQ5551': {
    regNo: 'HR 26 DQ 5551',
    cleanRegNo: 'HR26DQ5551',
    ownerName: 'V***M S****H C******N',
    ownershipSerial: '2nd Owner',
    fatherName: 'B****R S****H C******N',
    presentAddress: 'Plot 104, Sector 54, Golf Course Road, Gurugram - 122002',
    permanentAddress: 'Plot 104, Sector 54, Golf Course Road, Gurugram - 122002',
    maker: 'ROYAL ENFIELD (EICHER MOTORS)',
    model: 'CLASSIC 350 DUAL CHANNEL ABS',
    vehicleClass: 'Two Wheeler (MCWG)',
    bodyType: 'Motorcycle',
    color: 'HALCYON BLACK',
    fuel: 'PETROL',
    emissionNorms: 'BHARAT STAGE VI (BS-VI)',
    engineNo: 'J350-EN-849182',
    chassisNo: 'ME3J350FGN4819201',
    cubicCapacity: '349 cc',
    seatingCapacity: 2,
    standingCapacity: 0,
    unladenWeight: '195 KG',
    grossWeight: '375 KG',
    wheelbase: '1390 mm',
    regDate: '2023-08-19',
    vehicleAge: '3 Years 3 Months',
    fitnessUpto: '2038-08-18',
    insurance: {
      company: 'HDFC ERGO General Insurance Co. Ltd.',
      policyNo: '2311/20048192/01/000',
      validFrom: '2025-08-15',
      validUpto: '2026-08-14',
      status: 'EXPIRED',
      daysRemaining: -93
    },
    puc: {
      certificateNo: 'HR2600819201',
      validFrom: '2026-08-10',
      validUpto: '2026-11-09',
      status: 'EXPIRED',
      testingCenter: 'IFFCO Chowk Fuel Station, Gurugram'
    },
    tax: {
      status: 'LIFE TIME TAX (LTT) PAID',
      paidUpto: 'LIFE TIME (15 YEARS)',
      receiptNo: 'HR-LTT-2023-88129'
    },
    hypothecation: {
      isHypothecated: false,
      bank: null,
      branch: null,
      status: 'NO HYPOTHECATION (CLEAN TITLE)'
    },
    status: 'ACTIVE',
    blacklisted: false,
    permit: {
      type: 'Not Applicable (Two Wheeler)',
      status: 'EXEMPTED'
    }
  }
};

// Generates realistic, fully consistent Parivahan data for ANY Indian number plate
export function lookupVehicle(regNo) {
  if (!regNo) return null;
  const clean = regNo.toUpperCase().replace(/[^A-Z0-9]/g, '');

  if (clean.length < 5 || clean.length > 12) {
    return null;
  }

  // Check seeded database first
  if (SEEDED_VEHICLES[clean]) {
    const v = { ...SEEDED_VEHICLES[clean] };
    const rto = findRtoByRegistration(clean);
    v.rto = rto;
    return v;
  }

  // Format the plate nicely: e.g. "DL 01 AB 1234"
  const stateCode = clean.substring(0, 2);
  const rtoNum = clean.substring(2, 4);
  const remaining = clean.substring(4);

  // Extract letters and digits from remaining
  const letters = remaining.replace(/[0-9]/g, '');
  const digits = remaining.replace(/[^0-9]/g, '');

  const formattedPlate = `${stateCode} ${rtoNum} ${letters ? letters + ' ' : ''}${digits}`;
  const rto = findRtoByRegistration(clean);

  // Deterministic seed generation based on registration number characters
  const hash = clean.split('').reduce((acc, char, idx) => acc + char.charCodeAt(0) * (idx + 1), 0);

  // Select model deterministically
  const model = VEHICLE_MODELS[hash % VEHICLE_MODELS.length];
  const insuranceCompany = INSURANCE_COMPANIES[hash % INSURANCE_COMPANIES.length];
  const isHypo = (hash % 2 === 0);
  const bank = isHypo ? FINANCIER_BANKS[hash % FINANCIER_BANKS.length] : null;

  // Realistic registration year between 2018 and 2025
  const regYear = 2018 + (hash % 8);
  const regMonth = String((hash % 12) + 1).padStart(2, '0');
  const regDay = String((hash % 28) + 1).padStart(2, '0');
  const regDate = `${regYear}-${regMonth}-${regDay}`;

  const fitnessYear = regYear + 15;
  const fitnessUpto = `${fitnessYear}-${regMonth}-${regDay}`;

  const currentYear = 2026;
  const ageYears = currentYear - regYear;
  const vehicleAge = `${ageYears} Years ${Math.abs(11 - parseInt(regMonth, 10))} Months`;

  // Insurance status
  const insValidUptoYear = (hash % 5 === 0) ? 2026 : 2027; // some expired
  const insValidMonth = String(((hash + 4) % 12) + 1).padStart(2, '0');
  const insValidDay = String(((hash + 7) % 28) + 1).padStart(2, '0');
  const insUpto = `${insValidUptoYear}-${insValidMonth}-${insValidDay}`;
  const isInsExpired = insValidUptoYear === 2026 && parseInt(insValidMonth, 10) < 11;

  // Masked names
  const firstNames = ['A****H', 'R****H', 'S****T', 'V****M', 'P****K', 'N****N', 'M****H', 'K****L', 'D****K', 'G****V'];
  const lastNames = ['S****A', 'K***R', 'P***L', 'V***A', 'G***A', 'S****H', 'M****A', 'J***I', 'Y***V', 'C******N'];
  const maskedOwner = `${firstNames[hash % firstNames.length]} ${lastNames[(hash + 3) % lastNames.length]}`;
  const maskedFather = `${firstNames[(hash + 5) % firstNames.length]} ${lastNames[(hash + 3) % lastNames.length]}`;

  return {
    regNo: formattedPlate,
    cleanRegNo: clean,
    ownerName: maskedOwner,
    ownershipSerial: (hash % 3 === 0) ? '2nd Owner' : '1st Owner',
    fatherName: maskedFather,
    presentAddress: `${(hash * 17) % 500 + 1}, Sector ${(hash % 20) + 1}, ${rto ? rto.city : stateCode}`,
    permanentAddress: `${(hash * 17) % 500 + 1}, Sector ${(hash % 20) + 1}, ${rto ? rto.city : stateCode}`,
    maker: model.maker,
    model: model.model,
    vehicleClass: model.vehicleClass,
    bodyType: model.vehicleClass.includes('Two') ? 'Motorcycle / Scooter' : (model.fuel === 'ELECTRIC' ? 'SUV / Electric' : 'Hatchback / Sedan / SUV'),
    color: model.color,
    fuel: model.fuel,
    emissionNorms: model.fuel === 'ELECTRIC' ? 'ZERO EMISSION (EV)' : (regYear >= 2020 ? 'BHARAT STAGE VI (BS-VI)' : 'BHARAT STAGE IV (BS-IV)'),
    engineNo: `${model.fuel.substring(0, 2)}${(hash * 31 % 900000) + 100000}`,
    chassisNo: `MA3${stateCode}${regYear}${String((hash * 97 % 900000) + 100000)}`,
    cubicCapacity: typeof model.cc === 'number' ? `${model.cc} cc` : model.cc,
    seatingCapacity: model.seats,
    standingCapacity: 0,
    unladenWeight: `${model.weight} KG`,
    grossWeight: `${Math.round(model.weight * 1.45)} KG`,
    wheelbase: '2460 mm',
    regDate: regDate,
    vehicleAge: vehicleAge,
    fitnessUpto: fitnessUpto,
    insurance: {
      company: insuranceCompany,
      policyNo: `POL${hash}00${regYear}9`,
      validFrom: `${insValidUptoYear - 1}-${insValidMonth}-${insValidDay}`,
      validUpto: insUpto,
      status: isInsExpired ? 'EXPIRED' : 'ACTIVE',
      daysRemaining: isInsExpired ? -45 : 120
    },
    puc: {
      certificateNo: model.fuel === 'ELECTRIC' ? 'NOT APPLICABLE' : `PUC-${stateCode}-${hash % 90000 + 10000}`,
      validFrom: model.fuel === 'ELECTRIC' ? 'NOT APPLICABLE' : '2026-06-01',
      validUpto: model.fuel === 'ELECTRIC' ? 'EXEMPTED (BEV)' : '2027-05-31',
      status: model.fuel === 'ELECTRIC' ? 'EXEMPTED' : 'ACTIVE',
      testingCenter: `Authorized Govt PUC Testing Station #${(hash % 40) + 1}, ${rto ? rto.city : stateCode}`
    },
    tax: {
      status: model.fuel === 'ELECTRIC' ? '0% CONCESSIONAL EV TAX' : 'LIFE TIME TAX (LTT) PAID',
      paidUpto: 'LIFE TIME (15 YEARS)',
      receiptNo: `${stateCode}-TAX-${regYear}-${hash % 90000 + 10000}`
    },
    hypothecation: {
      isHypothecated: isHypo,
      bank: bank,
      branch: bank ? `${rto ? rto.city : stateCode} Main Branch` : null,
      status: isHypo ? 'ACTIVE FINANCING LOAN' : 'NO HYPOTHECATION (CLEAN TITLE)'
    },
    status: 'ACTIVE',
    blacklisted: false,
    rto: rto,
    permit: {
      type: model.vehicleClass.includes('Commercial') ? 'All India Tourist Permit' : 'Not Applicable (Private Vehicle)',
      status: 'EXEMPTED'
    }
  };
}
