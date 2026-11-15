import React, { useState } from 'react';
import { DrivingLicence } from '../types';
import { fetchDrivingLicence, fetchSampleDls } from '../services/api';
import {
  FileCheck2,
  Search,
  Calendar,
  ShieldCheck,
  User,
  Heart,
  Car,
  Bike,
  Truck,
  CheckCircle2,
  AlertCircle
} from 'lucide-react';

export const DlVerification: React.FC = () => {
  const [dlNumber, setDlNumber] = useState('');
  const [dob, setDob] = useState('1990-05-14');
  const [licence, setLicence] = useState<DrivingLicence | null>(null);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);

  const sampleDls = [
    { label: 'Delhi (Car & Bike)', dl: 'DL-0420110149632', dob: '1990-05-14' },
    { label: 'Maharashtra (Pune)', dl: 'MH-1420190012345', dob: '1995-11-22' }
  ];

  const handleVerify = async (e?: React.FormEvent) => {
    if (e) e.preventDefault();
    if (!dlNumber.trim()) return;

    setLoading(true);
    setError(null);
    try {
      const data = await fetchDrivingLicence(dlNumber, dob);
      setLicence(data);
    } catch (err: any) {
      setError(err.message || 'Driving Licence verification failed. Please check the details.');
      setLicence(null);
    } finally {
      setLoading(false);
    }
  };

  const selectSample = (sample: typeof sampleDls[0]) => {
    setDlNumber(sample.dl);
    setDob(sample.dob);
    setLoading(true);
    setError(null);
    fetchDrivingLicence(sample.dl, sample.dob)
      .then((data) => setLicence(data))
      .catch((err) => setError(err.message))
      .finally(() => setLoading(false));
  };

  return (
    <div className="max-w-4xl mx-auto space-y-8 px-4">
      {/* Header */}
      <div className="text-center space-y-2">
        <div className="inline-flex items-center gap-1.5 px-3 py-1 rounded-full bg-emerald-50 dark:bg-emerald-950/80 border border-emerald-200 dark:border-emerald-800 text-emerald-700 dark:text-emerald-300 text-xs font-semibold">
          <ShieldCheck className="w-3.5 h-3.5" />
          <span>Sarathi Parivahan Verification Portal</span>
        </div>
        <h1 className="text-2xl sm:text-3xl font-extrabold text-slate-900 dark:text-white">
          Indian Driving Licence (DL) Verification
        </h1>
        <p className="text-xs sm:text-sm text-slate-500 dark:text-slate-400">
          Check licence status, authorized vehicle classes, and validity period
        </p>
      </div>

      {/* Verification Form Card */}
      <div className="bg-white dark:bg-slate-900 border border-slate-200 dark:border-slate-800 rounded-2xl p-6 shadow-sm max-w-2xl mx-auto space-y-4">
        <form onSubmit={handleVerify} className="space-y-4">
          <div>
            <label className="block text-xs font-bold text-slate-700 dark:text-slate-300 uppercase tracking-wider mb-1.5">
              Driving Licence Number
            </label>
            <div className="relative">
              <input
                type="text"
                value={dlNumber}
                onChange={(e) => setDlNumber(e.target.value.toUpperCase())}
                placeholder="e.g. DL-0420110149632 or MH1420190012345"
                className="w-full pl-4 pr-10 py-3 rounded-xl border border-slate-300 dark:border-slate-700 bg-slate-50 dark:bg-slate-800 text-slate-900 dark:text-white font-mono text-sm uppercase focus:ring-2 focus:ring-blue-500 focus:outline-none"
              />
              <FileCheck2 className="w-5 h-5 text-slate-400 absolute right-3 top-3.5 pointer-events-none" />
            </div>
          </div>

          <div>
            <label className="block text-xs font-bold text-slate-700 dark:text-slate-300 uppercase tracking-wider mb-1.5">
              Date of Birth (as per Licence)
            </label>
            <div className="relative">
              <input
                type="date"
                value={dob}
                onChange={(e) => setDob(e.target.value)}
                className="w-full px-4 py-3 rounded-xl border border-slate-300 dark:border-slate-700 bg-slate-50 dark:bg-slate-800 text-slate-900 dark:text-white text-sm focus:ring-2 focus:ring-blue-500 focus:outline-none"
              />
            </div>
          </div>

          <button
            type="submit"
            disabled={loading || !dlNumber.trim()}
            className="w-full bg-emerald-600 hover:bg-emerald-700 text-white font-bold py-3.5 rounded-xl shadow-md transition-all flex items-center justify-center gap-2 text-sm disabled:opacity-50"
          >
            {loading ? (
              <div className="w-5 h-5 border-2 border-white/30 border-t-white rounded-full animate-spin" />
            ) : (
              <>
                <Search className="w-4 h-4" />
                <span>Verify Driving Licence</span>
              </>
            )}
          </button>
        </form>

        {/* Quick Sample Selector */}
        <div className="pt-2 border-t border-slate-100 dark:border-slate-800 flex items-center gap-2 flex-wrap text-xs">
          <span className="text-slate-400 font-medium">Test Samples:</span>
          {sampleDls.map((s) => (
            <button
              key={s.dl}
              onClick={() => selectSample(s)}
              className="px-2.5 py-1 rounded-lg bg-slate-100 hover:bg-slate-200 dark:bg-slate-800 dark:hover:bg-slate-700 font-mono text-slate-700 dark:text-slate-300 transition-colors"
            >
              {s.label}
            </button>
          ))}
        </div>
      </div>

      {/* Error Notice */}
      {error && (
        <div className="bg-red-50 dark:bg-red-950/40 border border-red-200 dark:border-red-900 p-4 rounded-2xl flex items-start gap-3 text-red-800 dark:text-red-300 text-sm max-w-2xl mx-auto">
          <AlertCircle className="w-5 h-5 text-red-500 shrink-0 mt-0.5" />
          <p className="text-xs">{error}</p>
        </div>
      )}

      {/* Verified Licence Card View */}
      {licence && !loading && (
        <div className="max-w-2xl mx-auto space-y-4 animate-fadeIn">
          {/* Smart DL Card Visual */}
          <div className="bg-gradient-to-br from-emerald-900 via-slate-900 to-teal-950 rounded-2xl p-6 text-white border-2 border-emerald-500/40 shadow-2xl relative overflow-hidden">
            <div className="flex items-start justify-between border-b border-white/10 pb-4 mb-4">
              <div>
                <span className="text-[10px] tracking-widest uppercase font-bold text-emerald-400">
                  Union of India • Driving Licence
                </span>
                <h3 className="text-lg font-black tracking-tight text-white">FORM 7 SMART CARD</h3>
                <span className="text-xs font-mono text-amber-300 font-bold block mt-0.5">
                  {licence.dlNumber}
                </span>
              </div>
              <span className="px-2.5 py-1 rounded-full text-[10px] font-bold bg-emerald-500/20 text-emerald-300 border border-emerald-500/40">
                {licence.status}
              </span>
            </div>

            <div className="grid grid-cols-2 gap-4 text-xs mb-4">
              <div>
                <span className="text-[10px] text-slate-400 uppercase tracking-wider block">Licence Holder</span>
                <span className="font-bold text-white text-sm">{licence.holderName}</span>
              </div>
              <div>
                <span className="text-[10px] text-slate-400 uppercase tracking-wider block">Son / Daughter of</span>
                <span className="font-semibold text-slate-200">{licence.fatherName}</span>
              </div>
              <div>
                <span className="text-[10px] text-slate-400 uppercase tracking-wider block">Date of Birth</span>
                <span className="font-medium text-slate-200">{licence.dob}</span>
              </div>
              <div>
                <span className="text-[10px] text-slate-400 uppercase tracking-wider block">Blood Group</span>
                <span className="font-bold text-rose-400">{licence.bloodGroup}</span>
              </div>
            </div>

            {/* Validity Timeline */}
            <div className="bg-black/30 p-3 rounded-xl border border-white/5 space-y-2 text-xs mb-4">
              <div className="flex items-center justify-between">
                <span className="text-slate-400">Non-Transport Validity:</span>
                <span className="font-bold text-emerald-300 font-mono">
                  {licence.validityNonTransport.from} to {licence.validityNonTransport.to}
                </span>
              </div>
              <div className="flex items-center justify-between">
                <span className="text-slate-400">Transport Validity:</span>
                <span className="font-mono text-slate-300">{licence.validityTransport.status}</span>
              </div>
            </div>

            {/* Vehicle Classes Endorsed */}
            <div className="space-y-2">
              <span className="text-[10px] text-slate-400 uppercase tracking-wider block">
                Class of Vehicle (COV) Endorsements
              </span>
              <div className="grid grid-cols-1 sm:grid-cols-2 gap-2">
                {licence.covDetails.map((cov) => (
                  <div
                    key={cov.covCode}
                    className="flex items-center gap-2 bg-white/10 px-3 py-2 rounded-lg text-xs"
                  >
                    {cov.covCode === 'MCWG' ? (
                      <Bike className="w-4 h-4 text-amber-400" />
                    ) : cov.covCode === 'LMV' ? (
                      <Car className="w-4 h-4 text-sky-400" />
                    ) : (
                      <Truck className="w-4 h-4 text-emerald-400" />
                    )}
                    <div>
                      <span className="font-bold font-mono text-white mr-1.5">{cov.covCode}</span>
                      <span className="text-[10px] text-slate-300">{cov.covDescription}</span>
                    </div>
                  </div>
                ))}
              </div>
            </div>

            {/* Issuing Authority */}
            <div className="mt-4 pt-3 border-t border-white/10 text-[10px] text-slate-400">
              <span>Issuing Authority: </span>
              <span className="text-white font-medium">{licence.issuingAuthority}</span>
            </div>
          </div>
        </div>
      )}
    </div>
  );
};
