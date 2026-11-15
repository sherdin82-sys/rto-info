import {
  VehicleDetails,
  DrivingLicence,
  Challan,
  RtoOffice,
  FuelPrice,
  TrafficSign,
  ExamQuestion,
  ExamEvaluation
} from '../types';

const API_BASE = '/api';

export async function fetchVehicleRc(regNo: string): Promise<VehicleDetails> {
  const clean = regNo.replace(/[^A-Za-z0-9]/g, '');
  const res = await fetch(`${API_BASE}/rc/search?regNo=${encodeURIComponent(clean)}`);
  const data = await res.json();
  if (!res.ok) {
    throw new Error(data.error || 'Failed to fetch vehicle registration details');
  }
  return data.data;
}

export async function fetchSampleVehicles(): Promise<Array<{
  regNo: string;
  cleanRegNo: string;
  maker: string;
  model: string;
  fuel: string;
  vehicleClass: string;
  insuranceStatus: string;
}>> {
  const res = await fetch(`${API_BASE}/rc/samples`);
  const data = await res.json();
  return data.data || [];
}

export async function fetchDrivingLicence(dlNumber: string, dob?: string): Promise<DrivingLicence> {
  const params = new URLSearchParams({ dlNumber });
  if (dob) params.append('dob', dob);
  const res = await fetch(`${API_BASE}/dl/verify?${params.toString()}`);
  const data = await res.json();
  if (!res.ok) {
    throw new Error(data.error || 'Failed to verify Driving Licence');
  }
  return data.data;
}

export async function fetchSampleDls(): Promise<Array<{
  dlNumber: string;
  holderName: string;
  dob: string;
  status: string;
  issuingAuthority: string;
}>> {
  const res = await fetch(`${API_BASE}/dl/samples`);
  const data = await res.json();
  return data.data || [];
}

export async function fetchChallans(query: { regNo?: string; challanNo?: string }): Promise<{
  challans: Challan[];
  meta?: { totalChallans: number; pendingCount: number; pendingAmount: number };
}> {
  const params = new URLSearchParams();
  if (query.regNo) params.append('regNo', query.regNo);
  if (query.challanNo) params.append('challanNo', query.challanNo);

  const res = await fetch(`${API_BASE}/challan/search?${params.toString()}`);
  const data = await res.json();
  if (!res.ok) {
    throw new Error(data.error || 'Failed to search challan records');
  }
  return {
    challans: data.data || [],
    meta: data.meta
  };
}

export async function payChallanOnline(challanNo: string, paymentMode: string = 'UPI'): Promise<{
  success: boolean;
  message: string;
  challan: Challan;
}> {
  const res = await fetch(`${API_BASE}/challan/pay`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ challanNo, paymentMode })
  });
  const data = await res.json();
  if (!res.ok) {
    throw new Error(data.error || data.message || 'Payment processing failed');
  }
  return data;
}

export async function fetchRtoStates(): Promise<Array<{ code: string; name: string; capital: string }>> {
  const res = await fetch(`${API_BASE}/rto/states`);
  const data = await res.json();
  return data.data || [];
}

export async function fetchRtoOffices(state?: string, search?: string): Promise<RtoOffice[]> {
  const params = new URLSearchParams();
  if (state) params.append('state', state);
  if (search) params.append('search', search);

  const res = await fetch(`${API_BASE}/rto/offices?${params.toString()}`);
  const data = await res.json();
  return data.data || [];
}

export async function fetchFuelPrices(): Promise<{
  prices: FuelPrice[];
  nationalAverage: { petrol: number; diesel: number; cng: number; lpg: number };
}> {
  const res = await fetch(`${API_BASE}/fuel/all`);
  const data = await res.json();
  return {
    prices: data.data || [],
    nationalAverage: data.nationalAverage
  };
}

export async function calculateResaleValue(payload: {
  vehicleType: string;
  originalPrice: number;
  purchaseYear: number;
  kmsDriven: number;
  condition: string;
  fuelType?: string;
  owners?: number;
}): Promise<any> {
  const res = await fetch(`${API_BASE}/resale/calculate`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(payload)
  });
  const data = await res.json();
  return data.data;
}

export async function calculateLoanEmi(payload: {
  vehiclePrice: number;
  downPayment: number;
  interestRate: number;
  tenureMonths: number;
}): Promise<any> {
  const res = await fetch(`${API_BASE}/resale/loan`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(payload)
  });
  const data = await res.json();
  return data.data;
}

export async function fetchExamQuestions(count: number = 10): Promise<ExamQuestion[]> {
  const res = await fetch(`${API_BASE}/rules/exam/questions?count=${count}`);
  const data = await res.json();
  return data.data || [];
}

export async function submitExamAnswers(answers: Record<number, number>): Promise<ExamEvaluation> {
  const res = await fetch(`${API_BASE}/rules/exam/evaluate`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ answers })
  });
  const data = await res.json();
  return data.data;
}

export async function fetchTrafficSigns(category?: string): Promise<TrafficSign[]> {
  const url = category ? `${API_BASE}/rules/traffic-signs?category=${encodeURIComponent(category)}` : `${API_BASE}/rules/traffic-signs`;
  const res = await fetch(url);
  const data = await res.json();
  return data.data || [];
}

export async function fetchRtoServices(): Promise<any[]> {
  const res = await fetch(`${API_BASE}/rules/services`);
  const data = await res.json();
  return data.data || [];
}
