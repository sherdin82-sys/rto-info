export interface RtoOffice {
  code: string;
  stateCode: string;
  state: string;
  city: string;
  location: string;
  address: string;
  phone: string;
  email: string;
}

export interface VehicleInsurance {
  company: string;
  policyNo: string;
  validFrom: string;
  validUpto: string;
  status: 'ACTIVE' | 'EXPIRED' | 'EXPIRING_SOON';
  daysRemaining: number;
}

export interface VehiclePuc {
  certificateNo: string;
  validFrom: string;
  validUpto: string;
  status: 'ACTIVE' | 'EXPIRED' | 'EXEMPTED';
  testingCenter: string;
}

export interface VehicleTax {
  status: string;
  paidUpto: string;
  receiptNo: string;
}

export interface VehicleHypothecation {
  isHypothecated: boolean;
  bank: string | null;
  branch: string | null;
  status: string;
}

export interface VehicleDetails {
  regNo: string;
  cleanRegNo: string;
  ownerName: string;
  ownershipSerial: string;
  fatherName: string;
  presentAddress: string;
  permanentAddress: string;
  maker: string;
  model: string;
  vehicleClass: string;
  bodyType: string;
  color: string;
  fuel: string;
  emissionNorms: string;
  engineNo: string;
  chassisNo: string;
  cubicCapacity: string;
  seatingCapacity: number;
  standingCapacity: number;
  unladenWeight: string;
  grossWeight: string;
  wheelbase: string;
  regDate: string;
  vehicleAge: string;
  fitnessUpto: string;
  insurance: VehicleInsurance;
  puc: VehiclePuc;
  tax: VehicleTax;
  hypothecation: VehicleHypothecation;
  status: string;
  blacklisted: boolean;
  rto?: RtoOffice | null;
  permit?: {
    type: string;
    status: string;
  };
}

export interface CovDetail {
  covCode: string;
  covDescription: string;
  issueDate: string;
}

export interface DrivingLicence {
  dlNumber: string;
  cleanDlNumber: string;
  holderName: string;
  fatherName: string;
  dob: string;
  bloodGroup: string;
  issueDate: string;
  validityNonTransport: {
    from: string;
    to: string;
    status: string;
  };
  validityTransport: {
    from: string;
    to: string;
    status: string;
  };
  status: string;
  issuingAuthority: string;
  address: string;
  covDetails: CovDetail[];
  hazardEndorsement: string;
  hillEndorsement: string;
}

export interface ChallanPayment {
  transactionId: string;
  paidAt: string;
  paymentMode: string;
  receiptNo: string;
}

export interface Challan {
  challanNo: string;
  regNo: string;
  date: string;
  violation: string;
  section: string;
  amount: number;
  status: 'PENDING' | 'PAID' | 'COURT_DISPATCHED';
  location: string;
  trafficPoliceUnit: string;
  cameraCode: string;
  evidenceImageUrl: string;
  dueDate: string;
  paymentDetails: ChallanPayment | null;
}

export interface FuelPrice {
  city: string;
  state: string;
  petrol: number;
  diesel: number;
  cng: number;
  lpg: number;
  changePetrol: number;
  changeDiesel: number;
  lastUpdated: string;
}

export interface TrafficSign {
  id: string;
  category: 'Mandatory' | 'Cautionary' | 'Informatory';
  name: string;
  shape: string;
  color: string;
  meaning: string;
  iconName: string;
  fineUnderAct: string;
}

export interface ExamQuestion {
  id: number;
  question: string;
  options: string[];
}

export interface ExamResultItem {
  id: number;
  question: string;
  options: string[];
  selectedAnswer: number;
  correctAnswer: number;
  isCorrect: boolean;
  explanation: string;
}

export interface ExamEvaluation {
  score: number;
  total: number;
  percentage: number;
  passed: boolean;
  feedback: string;
  details: ExamResultItem[];
}

export interface SavedVehicle {
  regNo: string;
  cleanRegNo: string;
  maker: string;
  model: string;
  fuel: string;
  vehicleClass: string;
  savedAt: string;
  nickname?: string;
  insuranceValidUpto?: string;
  pucValidUpto?: string;
}
