// Realistic Indian e-Challan Database & Generator
// Violation categories according to Motor Vehicles Amendment Act

export const VIOLATION_TYPES = [
  { code: 'V01', section: 'Section 183(1) MV Act', name: 'Over Speeding (LMV/Two Wheeler)', fine: 2000, severity: 'High' },
  { code: 'V02', section: 'Section 184 MV Act', name: 'Dangerous / Rash Driving & Red Light Jumping', fine: 1000, severity: 'High' },
  { code: 'V03', section: 'Section 129 / 194D MV Act', name: 'Driving / Riding without BIS Helmet', fine: 1000, severity: 'Medium' },
  { code: 'V04', section: 'Section 194B(1) MV Act', name: 'Driving without Fastening Seatbelt', fine: 1000, severity: 'Medium' },
  { code: 'V05', section: 'Section 184(c) MV Act', name: 'Using Mobile Phone While Driving', fine: 1500, severity: 'High' },
  { code: 'V06', section: 'Section 177 MV Act', name: 'Zebra Crossing / Stop Line Violation', fine: 500, severity: 'Low' },
  { code: 'V07', section: 'Section 122/177 MV Act', name: 'Improper / Obstructionist Parking', fine: 500, severity: 'Low' },
  { code: 'V08', section: 'Section 196 MV Act', name: 'Driving without Valid Motor Insurance', fine: 2000, severity: 'High' },
  { code: 'V09', section: 'Section 190(2) MV Act', name: 'Pollution Under Control (PUC) Violation', fine: 10000, severity: 'Critical' },
  { code: 'V10', section: 'Section 100/177 MV Act', name: 'Defective / Fancy / Non-HSRP Number Plate', fine: 1000, severity: 'Medium' }
];

// In-memory challan store (allows paying challan in real-time)
let CHALLAN_STORE = [
  {
    challanNo: 'DL240819004291',
    regNo: 'DL01AB1234',
    date: '2026-10-14 11:24 AM',
    violation: 'Over Speeding (LMV/Two Wheeler)',
    section: 'Section 183(1) MV Act',
    amount: 2000,
    status: 'PENDING',
    location: 'Ring Road near Kashmere Gate ISBT, North Delhi',
    trafficPoliceUnit: 'Delhi Traffic Police (Northern Range)',
    cameraCode: 'CCTV-KG-N44',
    evidenceImageUrl: 'https://images.unsplash.com/photo-1549399542-7e3f8b79c341?auto=format&fit=crop&w=400&q=80',
    dueDate: '2026-12-14',
    paymentDetails: null
  },
  {
    challanNo: 'DL240702008819',
    regNo: 'DL01AB1234',
    date: '2026-08-05 09:12 AM',
    violation: 'Zebra Crossing / Stop Line Violation',
    section: 'Section 177 MV Act',
    amount: 500,
    status: 'PAID',
    location: 'ITO Junction Signal, New Delhi',
    trafficPoliceUnit: 'Delhi Traffic Police (Central Range)',
    cameraCode: 'RLVD-ITO-02',
    evidenceImageUrl: 'https://images.unsplash.com/photo-1568605117036-5fe5e7bab0b7?auto=format&fit=crop&w=400&q=80',
    dueDate: '2026-10-05',
    paymentDetails: {
      transactionId: 'TXN_DL_9921827461',
      paidAt: '2026-08-09 14:30 PM',
      paymentMode: 'UPI (Parivahan Grameen / SBI ePay)',
      receiptNo: 'RCP-2026-DL-8819'
    }
  },
  {
    challanNo: 'MH241101007812',
    regNo: 'MH12DE1433',
    date: '2026-10-28 17:45 PM',
    violation: 'Dangerous / Rash Driving & Red Light Jumping',
    section: 'Section 184 MV Act',
    amount: 1000,
    status: 'PENDING',
    location: 'FC Road Good Luck Chowk, Pune',
    trafficPoliceUnit: 'Pune City Traffic Police (Deccan Division)',
    cameraCode: 'ITMS-PUN-GL01',
    evidenceImageUrl: 'https://images.unsplash.com/photo-1503376780353-7e6692767b70?auto=format&fit=crop&w=400&q=80',
    dueDate: '2026-12-28',
    paymentDetails: null
  },
  {
    challanNo: 'KA240915003341',
    regNo: 'KA05MJ5005',
    date: '2026-09-18 10:30 AM',
    violation: 'Using Mobile Phone While Driving',
    section: 'Section 184(c) MV Act',
    amount: 1500,
    status: 'PENDING',
    location: 'Silk Board Junction, Outer Ring Road, Bengaluru',
    trafficPoliceUnit: 'Bengaluru Traffic Police (Madiwala Sub-Division)',
    cameraCode: 'BTP-ANPR-SB03',
    evidenceImageUrl: 'https://images.unsplash.com/photo-1492144534655-ae79c964c9d7?auto=format&fit=crop&w=400&q=80',
    dueDate: '2026-11-18',
    paymentDetails: null
  }
];

// Helper to search challans by vehicle registration number or challan number
export function getChallansForVehicle(regNo) {
  const cleanReg = regNo ? regNo.toUpperCase().replace(/[^A-Z0-9]/g, '') : '';
  const matched = CHALLAN_STORE.filter(c => c.regNo.replace(/[^A-Z0-9]/g, '') === cleanReg);

  if (matched.length > 0) {
    return matched;
  }

  // Generate deterministic realistic challans for test variety based on plate hash
  const hash = cleanReg.split('').reduce((acc, char) => acc + char.charCodeAt(0), 0);
  const hasChallan = hash % 3 !== 0; // ~66% vehicles have 1 or 2 challans

  if (!hasChallan) {
    return [];
  }

  const vIndex1 = hash % VIOLATION_TYPES.length;
  const violation1 = VIOLATION_TYPES[vIndex1];
  const isPending = (hash % 2 === 0);

  const genChallan1 = {
    challanNo: `${cleanReg.substring(0, 4)}26${String(hash * 37 % 900000 + 100000)}`,
    regNo: regNo.toUpperCase(),
    date: '2026-09-22 14:15 PM',
    violation: violation1.name,
    section: violation1.section,
    amount: violation1.fine,
    status: isPending ? 'PENDING' : 'PAID',
    location: `Major Traffic Corridor / Signal Junction, ${cleanReg.substring(0, 2)} State`,
    trafficPoliceUnit: `${cleanReg.substring(0, 2)} State Automated Traffic Enforcement Branch`,
    cameraCode: `ITMS-CAM-${hash % 90 + 10}`,
    evidenceImageUrl: 'https://images.unsplash.com/photo-1549399542-7e3f8b79c341?auto=format&fit=crop&w=400&q=80',
    dueDate: '2026-12-22',
    paymentDetails: isPending ? null : {
      transactionId: `TXN_${cleanReg}_${hash}771`,
      paidAt: '2026-09-25 11:20 AM',
      paymentMode: 'Net Banking / Parivahan ePay',
      receiptNo: `RCP-2026-${cleanReg.substring(0, 2)}-${hash}`
    }
  };

  // Add to store so subsequent queries see it
  CHALLAN_STORE.push(genChallan1);
  return [genChallan1];
}

// Find single challan by challan number
export function findChallanByNumber(challanNo) {
  const clean = challanNo ? challanNo.trim().toUpperCase() : '';
  return CHALLAN_STORE.find(c => c.challanNo === clean) || null;
}

// Simulate paying a challan online
export function payChallan(challanNo, paymentMode = 'UPI') {
  const challan = findChallanByNumber(challanNo);
  if (!challan) {
    return { success: false, message: 'Challan record not found' };
  }

  if (challan.status === 'PAID') {
    return { success: false, message: 'Challan is already paid', challan };
  }

  const now = new Date();
  challan.status = 'PAID';
  challan.paymentDetails = {
    transactionId: `TXN_PARIVAHAN_${Date.now()}`,
    paidAt: `${now.toISOString().split('T')[0]} ${now.toLocaleTimeString()}`,
    paymentMode: paymentMode,
    receiptNo: `RCP-${now.getFullYear()}-${Math.floor(100000 + Math.random() * 900000)}`
  };

  return {
    success: true,
    message: 'Challan payment successfully settled! Official receipt generated.',
    challan
  };
}
