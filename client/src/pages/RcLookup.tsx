import React, { useState, useEffect } from 'react';
import { NumberPlateInput } from '../components/NumberPlateInput';
import { DigitalRcCard } from '../components/DigitalRcCard';
import { VehicleDetails, SavedVehicle } from '../types';
import { fetchVehicleRc } from '../services/api';
import {
  ShieldCheck,
  Calendar,
  AlertTriangle,
  CheckCircle2,
  Bookmark,
  BookmarkCheck,
  AlertCircle,
  Building,
  Info,
  Car,
  FileText,
  Fuel,
  Banknote,
  Eye,
  EyeOff
} from 'lucide-react';

interface RcLookupProps {
  initialPlate?: string;
  onCheckChallans: (regNo: string) => void;
  savedVehicles: SavedVehicle[];
  onToggleSaveGarage: (v: VehicleDetails) => void;
}

export const RcLookup: React.FC<RcLookupProps> = ({
  initialPlate = '',
  onCheckChallans,
  savedVehicles,
  onToggleSaveGarage
}) => {
  const [plateInput, setPlateInput] = useState(initialPlate);
  const [vehicle, setVehicle] = useState<VehicleDetails | null>(null);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [unmaskSensitive, setUnmaskSensitive] = useState(false);
  const [activeTab, setActiveTab] = useState<'overview' | 'technical' | 'insurance' | 'tax'>('overview');

  const executeSearch = async (plate: string) => {
    if (!plate.trim()) return;
    setLoading(true);
    setError(null);
    try {
      const data = await fetchVehicleRc(plate);
      setVehicle(data);
    } catch (err: any) {
      setError(err.message || 'Unable to retrieve vehicle records. Please verify the registration number.');
      setVehicle(null);
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    if (initialPlate) {
      setPlateInput(initialPlate);
      executeSearch(initialPlate);
    }
  }, [initialPlate]);

  const isSaved = vehicle
    ? savedVehicles.some((s) => s.cleanRegNo === vehicle.cleanRegNo)
    : false;

  const handleShare = () => {
    if (!vehicle) return;
    if (navigator.share) {
      navigator.share({
        title: `Vehicle Details: ${vehicle.regNo}`,
        text: `Vehicle: ${vehicle.maker} ${vehicle.model} (${vehicle.regNo})\nFitness Upto: ${vehicle.fitnessUpto}\nInsurance: ${vehicle.insurance.status}`,
        url: window.location.href
      }).catch(() => {});
    } else {
      navigator.clipboard.writeText(
        `Vehicle: ${vehicle.maker} ${vehicle.model} (${vehicle.regNo}) | Fitness Upto: ${vehicle.fitnessUpto}`
      );
      alert('Vehicle summary copied to clipboard!');
    }
  };

  return (
    <div className="max-w-5xl mx-auto space-y-8 px-4">
      {/* Search Header */}
      <div className="text-center space-y-2">
        <h1 className="text-2xl sm:text-3xl font-extrabold text-slate-900 dark:text-white">
          Indian Vehicle Registration (RC) Details
        </h1>
        <p className="text-xs sm:text-sm text-slate-500 dark:text-slate-400">
          Search Parivahan Vahan registration certificate by entering registration number
        </p>

        <div className="pt-2">
          <NumberPlateInput
            value={plateInput}
            onChange={setPlateInput}
            onSearch={executeSearch}
            isLoading={loading}
            isElectricPlate={vehicle?.fuel === 'ELECTRIC'}
          />
        </div>
      </div>

      {/* Error state */}
      {error && (
        <div className="bg-red-50 dark:bg-red-950/40 border border-red-200 dark:border-red-900 p-4 rounded-2xl flex items-start gap-3 text-red-800 dark:text-red-300 text-sm max-w-2xl mx-auto animate-shake">
          <AlertCircle className="w-5 h-5 text-red-500 shrink-0 mt-0.5" />
          <div className="space-y-1">
            <p className="font-bold">Record Search Notice</p>
            <p className="text-xs">{error}</p>
          </div>
        </div>
      )}

      {/* Loading Skeleton */}
      {loading && (
        <div className="max-w-2xl mx-auto space-y-4 animate-pulse">
          <div className="h-64 bg-slate-200 dark:bg-slate-800 rounded-2xl"></div>
          <div className="h-28 bg-slate-200 dark:bg-slate-800 rounded-xl"></div>
        </div>
      )}

      {/* Vehicle Record View */}
      {vehicle && !loading && (
        <div className="space-y-6 animate-fadeIn">
          {/* Quick Action Bar */}
          <div className="flex flex-wrap items-center justify-between gap-3 bg-white dark:bg-slate-900 p-4 rounded-2xl border border-slate-200 dark:border-slate-800 shadow-sm">
            <div className="flex items-center gap-2">
              <span className="font-bold text-slate-900 dark:text-white text-base">
                {vehicle.maker} - {vehicle.model}
              </span>
              <span className="px-2 py-0.5 rounded text-[10px] font-bold bg-blue-100 dark:bg-blue-900/60 text-blue-700 dark:text-blue-300">
                {vehicle.ownershipSerial}
              </span>
            </div>

            <div className="flex items-center gap-2">
              <button
                onClick={() => onToggleSaveGarage(vehicle)}
                className={`flex items-center gap-1.5 px-3 py-1.5 rounded-xl text-xs font-semibold transition-all ${
                  isSaved
                    ? 'bg-amber-100 dark:bg-amber-950/80 text-amber-700 dark:text-amber-300 border border-amber-300 dark:border-amber-700'
                    : 'bg-slate-100 hover:bg-slate-200 dark:bg-slate-800 dark:hover:bg-slate-700 text-slate-700 dark:text-slate-300'
                }`}
              >
                {isSaved ? <BookmarkCheck className="w-4 h-4 text-amber-500" /> : <Bookmark className="w-4 h-4" />}
                <span>{isSaved ? 'In My Garage' : 'Add to Garage'}</span>
              </button>

              <button
                onClick={() => onCheckChallans(vehicle.cleanRegNo)}
                className="flex items-center gap-1.5 px-3.5 py-1.5 rounded-xl text-xs font-semibold bg-rose-600 hover:bg-rose-700 text-white shadow-sm transition-all"
              >
                <AlertCircle className="w-4 h-4" />
                <span>Check Challans</span>
              </button>
            </div>
          </div>

          {/* Digital Smart Card Display */}
          <DigitalRcCard vehicle={vehicle} onShare={handleShare} />

          {/* Tabs Navigation */}
          <div className="flex items-center gap-2 border-b border-slate-200 dark:border-slate-800 overflow-x-auto pb-1 text-xs font-bold">
            <button
              onClick={() => setActiveTab('overview')}
              className={`px-4 py-2 rounded-t-xl transition-colors ${
                activeTab === 'overview'
                  ? 'border-b-2 border-blue-600 text-blue-600 dark:text-blue-400 bg-blue-50/50 dark:bg-blue-950/30'
                  : 'text-slate-500 hover:text-slate-900 dark:hover:text-white'
              }`}
            >
              Overview & Status
            </button>
            <button
              onClick={() => setActiveTab('technical')}
              className={`px-4 py-2 rounded-t-xl transition-colors ${
                activeTab === 'technical'
                  ? 'border-b-2 border-blue-600 text-blue-600 dark:text-blue-400 bg-blue-50/50 dark:bg-blue-950/30'
                  : 'text-slate-500 hover:text-slate-900 dark:hover:text-white'
              }`}
            >
              Technical Specs
            </button>
            <button
              onClick={() => setActiveTab('insurance')}
              className={`px-4 py-2 rounded-t-xl transition-colors ${
                activeTab === 'insurance'
                  ? 'border-b-2 border-blue-600 text-blue-600 dark:text-blue-400 bg-blue-50/50 dark:bg-blue-950/30'
                  : 'text-slate-500 hover:text-slate-900 dark:hover:text-white'
              }`}
            >
              Insurance & PUC
            </button>
            <button
              onClick={() => setActiveTab('tax')}
              className={`px-4 py-2 rounded-t-xl transition-colors ${
                activeTab === 'tax'
                  ? 'border-b-2 border-blue-600 text-blue-600 dark:text-blue-400 bg-blue-50/50 dark:bg-blue-950/30'
                  : 'text-slate-500 hover:text-slate-900 dark:hover:text-white'
              }`}
            >
              Tax & Hypothecation
            </button>
          </div>

          {/* TAB 1: OVERVIEW */}
          {activeTab === 'overview' && (
            <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
              {/* Owner & Registration Info */}
              <div className="bg-white dark:bg-slate-900 rounded-2xl p-5 border border-slate-200 dark:border-slate-800 shadow-sm space-y-4">
                <div className="flex items-center gap-2 border-b border-slate-100 dark:border-slate-800 pb-3">
                  <Car className="w-5 h-5 text-blue-600" />
                  <h3 className="font-bold text-sm text-slate-900 dark:text-white">Registration Profile</h3>
                </div>

                <div className="grid grid-cols-2 gap-3 text-xs">
                  <div>
                    <span className="text-slate-400 block">Registration Number</span>
                    <span className="font-mono font-bold text-slate-900 dark:text-white">{vehicle.regNo}</span>
                  </div>
                  <div>
                    <span className="text-slate-400 block">Registration Date</span>
                    <span className="font-semibold text-slate-800 dark:text-slate-200">{vehicle.regDate}</span>
                  </div>
                  <div>
                    <span className="text-slate-400 block">Vehicle Age</span>
                    <span className="font-semibold text-slate-800 dark:text-slate-200">{vehicle.vehicleAge}</span>
                  </div>
                  <div>
                    <span className="text-slate-400 block">Fitness Valid Upto</span>
                    <span className="font-semibold text-emerald-600 dark:text-emerald-400">{vehicle.fitnessUpto}</span>
                  </div>
                  <div>
                    <span className="text-slate-400 block">Vehicle Class</span>
                    <span className="font-semibold text-slate-800 dark:text-slate-200">{vehicle.vehicleClass}</span>
                  </div>
                  <div>
                    <span className="text-slate-400 block">Fuel Type</span>
                    <span className="font-semibold text-slate-800 dark:text-slate-200">{vehicle.fuel}</span>
                  </div>
                </div>
              </div>

              {/* Owner & Address Details */}
              <div className="bg-white dark:bg-slate-900 rounded-2xl p-5 border border-slate-200 dark:border-slate-800 shadow-sm space-y-4">
                <div className="flex items-center justify-between border-b border-slate-100 dark:border-slate-800 pb-3">
                  <div className="flex items-center gap-2">
                    <FileText className="w-5 h-5 text-emerald-600" />
                    <h3 className="font-bold text-sm text-slate-900 dark:text-white">Owner & Authority</h3>
                  </div>
                  <button
                    onClick={() => setUnmaskSensitive(!unmaskSensitive)}
                    className="text-[11px] font-semibold text-blue-600 dark:text-blue-400 flex items-center gap-1"
                  >
                    {unmaskSensitive ? <EyeOff className="w-3.5 h-3.5" /> : <Eye className="w-3.5 h-3.5" />}
                    <span>{unmaskSensitive ? 'Mask Names' : 'Show Masked'}</span>
                  </button>
                </div>

                <div className="space-y-3 text-xs">
                  <div>
                    <span className="text-slate-400 block">Owner Name</span>
                    <span className="font-bold text-slate-900 dark:text-white">{vehicle.ownerName}</span>
                  </div>
                  <div>
                    <span className="text-slate-400 block">Father’s / Husband’s Name</span>
                    <span className="font-medium text-slate-700 dark:text-slate-300">{vehicle.fatherName}</span>
                  </div>
                  <div>
                    <span className="text-slate-400 block">Registered RTO Location</span>
                    <span className="font-semibold text-blue-600 dark:text-blue-400">
                      {vehicle.rto ? `${vehicle.rto.location} (${vehicle.rto.code})` : 'Regional Transport Authority'}
                    </span>
                    {vehicle.rto && (
                      <p className="text-[11px] text-slate-400 mt-0.5">{vehicle.rto.address}</p>
                    )}
                  </div>
                </div>
              </div>
            </div>
          )}

          {/* TAB 2: TECHNICAL SPECS */}
          {activeTab === 'technical' && (
            <div className="bg-white dark:bg-slate-900 rounded-2xl p-6 border border-slate-200 dark:border-slate-800 shadow-sm space-y-4">
              <h3 className="font-bold text-sm text-slate-900 dark:text-white border-b border-slate-100 dark:border-slate-800 pb-3">
                Vehicle Mechanical & Technical Specifications
              </h3>

              <div className="grid grid-cols-2 sm:grid-cols-3 gap-4 text-xs">
                <div>
                  <span className="text-slate-400 block">Maker / Manufacturer</span>
                  <span className="font-semibold text-slate-900 dark:text-white">{vehicle.maker}</span>
                </div>
                <div>
                  <span className="text-slate-400 block">Commercial Model</span>
                  <span className="font-semibold text-slate-900 dark:text-white">{vehicle.model}</span>
                </div>
                <div>
                  <span className="text-slate-400 block">Body Type</span>
                  <span className="font-medium text-slate-700 dark:text-slate-300">{vehicle.bodyType}</span>
                </div>
                <div>
                  <span className="text-slate-400 block">Color</span>
                  <span className="font-medium text-slate-700 dark:text-slate-300">{vehicle.color}</span>
                </div>
                <div>
                  <span className="text-slate-400 block">Emission Norms</span>
                  <span className="font-medium text-slate-700 dark:text-slate-300">{vehicle.emissionNorms}</span>
                </div>
                <div>
                  <span className="text-slate-400 block">Cubic Capacity / Power</span>
                  <span className="font-mono font-semibold text-slate-900 dark:text-white">{vehicle.cubicCapacity}</span>
                </div>
                <div>
                  <span className="text-slate-400 block">Engine Number</span>
                  <span className="font-mono text-slate-700 dark:text-slate-300">{vehicle.engineNo}</span>
                </div>
                <div>
                  <span className="text-slate-400 block">Chassis Number</span>
                  <span className="font-mono text-slate-700 dark:text-slate-300">{vehicle.chassisNo}</span>
                </div>
                <div>
                  <span className="text-slate-400 block">Seating Capacity</span>
                  <span className="font-medium text-slate-700 dark:text-slate-300">{vehicle.seatingCapacity} Persons</span>
                </div>
                <div>
                  <span className="text-slate-400 block">Unladen Weight</span>
                  <span className="font-medium text-slate-700 dark:text-slate-300">{vehicle.unladenWeight}</span>
                </div>
                <div>
                  <span className="text-slate-400 block">Gross Vehicle Weight</span>
                  <span className="font-medium text-slate-700 dark:text-slate-300">{vehicle.grossWeight}</span>
                </div>
                <div>
                  <span className="text-slate-400 block">Wheelbase</span>
                  <span className="font-medium text-slate-700 dark:text-slate-300">{vehicle.wheelbase}</span>
                </div>
              </div>
            </div>
          )}

          {/* TAB 3: INSURANCE & PUC */}
          {activeTab === 'insurance' && (
            <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
              {/* Insurance Card */}
              <div className="bg-white dark:bg-slate-900 rounded-2xl p-5 border border-slate-200 dark:border-slate-800 shadow-sm space-y-4">
                <div className="flex items-center justify-between border-b border-slate-100 dark:border-slate-800 pb-3">
                  <div className="flex items-center gap-2">
                    <ShieldCheck className="w-5 h-5 text-blue-600" />
                    <h3 className="font-bold text-sm text-slate-900 dark:text-white">Motor Insurance</h3>
                  </div>
                  <span
                    className={`px-2.5 py-0.5 rounded-full text-[10px] font-bold ${
                      vehicle.insurance.status === 'ACTIVE'
                        ? 'bg-emerald-100 dark:bg-emerald-950/80 text-emerald-700 dark:text-emerald-300'
                        : 'bg-rose-100 dark:bg-rose-950/80 text-rose-700 dark:text-rose-300 animate-pulse'
                    }`}
                  >
                    {vehicle.insurance.status}
                  </span>
                </div>

                <div className="space-y-3 text-xs">
                  <div>
                    <span className="text-slate-400 block">Insurance Provider</span>
                    <span className="font-semibold text-slate-900 dark:text-white">{vehicle.insurance.company}</span>
                  </div>
                  <div>
                    <span className="text-slate-400 block">Policy Number</span>
                    <span className="font-mono text-slate-700 dark:text-slate-300">{vehicle.insurance.policyNo}</span>
                  </div>
                  <div className="grid grid-cols-2 gap-2">
                    <div>
                      <span className="text-slate-400 block">Valid From</span>
                      <span className="font-medium text-slate-700 dark:text-slate-300">{vehicle.insurance.validFrom}</span>
                    </div>
                    <div>
                      <span className="text-slate-400 block">Valid Upto</span>
                      <span className="font-bold text-slate-900 dark:text-white">{vehicle.insurance.validUpto}</span>
                    </div>
                  </div>

                  <div className="pt-2">
                    {vehicle.insurance.status === 'ACTIVE' ? (
                      <div className="flex items-center gap-1.5 text-xs text-emerald-600 dark:text-emerald-400 bg-emerald-50 dark:bg-emerald-950/40 p-2.5 rounded-xl">
                        <CheckCircle2 className="w-4 h-4 shrink-0" />
                        <span>Valid policy. Safe for road usage under Section 146 MV Act.</span>
                      </div>
                    ) : (
                      <div className="flex items-center gap-1.5 text-xs text-rose-600 dark:text-rose-400 bg-rose-50 dark:bg-rose-950/40 p-2.5 rounded-xl">
                        <AlertTriangle className="w-4 h-4 shrink-0" />
                        <span>Expired policy! Driving without insurance carries a ₹2,000 fine.</span>
                      </div>
                    )}
                  </div>
                </div>
              </div>

              {/* PUC Card */}
              <div className="bg-white dark:bg-slate-900 rounded-2xl p-5 border border-slate-200 dark:border-slate-800 shadow-sm space-y-4">
                <div className="flex items-center justify-between border-b border-slate-100 dark:border-slate-800 pb-3">
                  <div className="flex items-center gap-2">
                    <Fuel className="w-5 h-5 text-amber-500" />
                    <h3 className="font-bold text-sm text-slate-900 dark:text-white">Pollution Under Control (PUC)</h3>
                  </div>
                  <span
                    className={`px-2.5 py-0.5 rounded-full text-[10px] font-bold ${
                      vehicle.puc.status === 'ACTIVE'
                        ? 'bg-emerald-100 dark:bg-emerald-950/80 text-emerald-700 dark:text-emerald-300'
                        : (vehicle.puc.status === 'EXEMPTED' ? 'bg-sky-100 dark:bg-sky-950/80 text-sky-700 dark:text-sky-300' : 'bg-rose-100 dark:bg-rose-950/80 text-rose-700 dark:text-rose-300')
                    }`}
                  >
                    {vehicle.puc.status}
                  </span>
                </div>

                <div className="space-y-3 text-xs">
                  <div>
                    <span className="text-slate-400 block">Certificate Number</span>
                    <span className="font-mono text-slate-700 dark:text-slate-300">{vehicle.puc.certificateNo}</span>
                  </div>
                  <div className="grid grid-cols-2 gap-2">
                    <div>
                      <span className="text-slate-400 block">Valid From</span>
                      <span className="font-medium text-slate-700 dark:text-slate-300">{vehicle.puc.validFrom}</span>
                    </div>
                    <div>
                      <span className="text-slate-400 block">Valid Upto</span>
                      <span className="font-bold text-slate-900 dark:text-white">{vehicle.puc.validUpto}</span>
                    </div>
                  </div>
                  <div>
                    <span className="text-slate-400 block">Testing Station</span>
                    <span className="font-medium text-slate-700 dark:text-slate-300">{vehicle.puc.testingCenter}</span>
                  </div>
                </div>
              </div>
            </div>
          )}

          {/* TAB 4: TAX & HYPOTHECATION */}
          {activeTab === 'tax' && (
            <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
              <div className="bg-white dark:bg-slate-900 rounded-2xl p-5 border border-slate-200 dark:border-slate-800 shadow-sm space-y-3 text-xs">
                <div className="flex items-center gap-2 border-b border-slate-100 dark:border-slate-800 pb-3">
                  <Banknote className="w-5 h-5 text-emerald-600" />
                  <h3 className="font-bold text-sm text-slate-900 dark:text-white">Road Tax Details</h3>
                </div>
                <div>
                  <span className="text-slate-400 block">Tax Status</span>
                  <span className="font-bold text-emerald-600 dark:text-emerald-400 text-sm">{vehicle.tax.status}</span>
                </div>
                <div>
                  <span className="text-slate-400 block">Paid Upto</span>
                  <span className="font-medium text-slate-800 dark:text-slate-200">{vehicle.tax.paidUpto}</span>
                </div>
                <div>
                  <span className="text-slate-400 block">Tax Receipt Number</span>
                  <span className="font-mono text-slate-700 dark:text-slate-300">{vehicle.tax.receiptNo}</span>
                </div>
              </div>

              <div className="bg-white dark:bg-slate-900 rounded-2xl p-5 border border-slate-200 dark:border-slate-800 shadow-sm space-y-3 text-xs">
                <div className="flex items-center gap-2 border-b border-slate-100 dark:border-slate-800 pb-3">
                  <Building className="w-5 h-5 text-indigo-600" />
                  <h3 className="font-bold text-sm text-slate-900 dark:text-white">Hypothecation (Loan Status)</h3>
                </div>
                <div>
                  <span className="text-slate-400 block">Financing Status</span>
                  <span className="font-bold text-slate-900 dark:text-white text-sm">{vehicle.hypothecation.status}</span>
                </div>
                {vehicle.hypothecation.isHypothecated && (
                  <>
                    <div>
                      <span className="text-slate-400 block">Financier / Bank Name</span>
                      <span className="font-bold text-blue-600 dark:text-blue-400">{vehicle.hypothecation.bank}</span>
                    </div>
                    <div>
                      <span className="text-slate-400 block">Lending Branch</span>
                      <span className="font-medium text-slate-700 dark:text-slate-300">{vehicle.hypothecation.branch}</span>
                    </div>
                  </>
                )}
              </div>
            </div>
          )}
        </div>
      )}
    </div>
  );
};
