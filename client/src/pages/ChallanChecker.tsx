import React, { useState, useEffect } from 'react';
import { Challan } from '../types';
import { fetchChallans, payChallanOnline } from '../services/api';
import {
  AlertCircle,
  Search,
  CheckCircle2,
  Calendar,
  MapPin,
  Camera,
  CreditCard,
  Printer,
  X,
  ShieldCheck,
  Receipt,
  Download
} from 'lucide-react';

interface ChallanCheckerProps {
  initialRegNo?: string;
}

export const ChallanChecker: React.FC<ChallanCheckerProps> = ({ initialRegNo = '' }) => {
  const [searchTerm, setSearchTerm] = useState(initialRegNo);
  const [challans, setChallans] = useState<Challan[]>([]);
  const [meta, setMeta] = useState<{ totalChallans: number; pendingCount: number; pendingAmount: number } | null>(null);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);

  // Payment modal state
  const [activePaymentChallan, setActivePaymentChallan] = useState<Challan | null>(null);
  const [paymentMode, setPaymentMode] = useState<'UPI' | 'Card' | 'NetBanking'>('UPI');
  const [paying, setPaying] = useState(false);
  const [receiptChallan, setReceiptChallan] = useState<Challan | null>(null);

  const handleSearch = async (term?: string) => {
    const query = term !== undefined ? term : searchTerm;
    if (!query.trim()) return;

    setLoading(true);
    setError(null);
    try {
      const isChallanNo = query.toUpperCase().startsWith('DL') && query.length > 12;
      const res = await fetchChallans(isChallanNo ? { challanNo: query } : { regNo: query });
      setChallans(res.challans);
      setMeta(res.meta || null);
    } catch (err: any) {
      setError(err.message || 'No challan records found for given input.');
      setChallans([]);
      setMeta(null);
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    if (initialRegNo) {
      setSearchTerm(initialRegNo);
      handleSearch(initialRegNo);
    }
  }, [initialRegNo]);

  const handleProcessPayment = async () => {
    if (!activePaymentChallan) return;
    setPaying(true);
    try {
      const res = await payChallanOnline(activePaymentChallan.challanNo, paymentMode);
      // Update local state
      setChallans((prev) =>
        prev.map((c) => (c.challanNo === res.challan.challanNo ? res.challan : c))
      );
      if (meta) {
        setMeta({
          ...meta,
          pendingCount: Math.max(0, meta.pendingCount - 1),
          pendingAmount: Math.max(0, meta.pendingAmount - activePaymentChallan.amount)
        });
      }
      setReceiptChallan(res.challan);
      setActivePaymentChallan(null);
    } catch (err: any) {
      alert(err.message || 'Payment simulation failed');
    } finally {
      setPaying(false);
    }
  };

  return (
    <div className="max-w-4xl mx-auto space-y-8 px-4">
      {/* Header */}
      <div className="text-center space-y-2">
        <div className="inline-flex items-center gap-1.5 px-3 py-1 rounded-full bg-rose-50 dark:bg-rose-950/80 border border-rose-200 dark:border-rose-800 text-rose-700 dark:text-rose-300 text-xs font-semibold">
          <AlertCircle className="w-3.5 h-3.5" />
          <span>National e-Challan Citizen Portal</span>
        </div>
        <h1 className="text-2xl sm:text-3xl font-extrabold text-slate-900 dark:text-white">
          Indian Traffic e-Challan Status & Payment
        </h1>
        <p className="text-xs sm:text-sm text-slate-500 dark:text-slate-400">
          Check pending traffic violation challans, camera evidence, and settle fines online
        </p>
      </div>

      {/* Search Input Box */}
      <div className="bg-white dark:bg-slate-900 border border-slate-200 dark:border-slate-800 rounded-2xl p-4 shadow-sm max-w-xl mx-auto">
        <form
          onSubmit={(e) => {
            e.preventDefault();
            handleSearch();
          }}
          className="flex items-center gap-2"
        >
          <input
            type="text"
            value={searchTerm}
            onChange={(e) => setSearchTerm(e.target.value.toUpperCase())}
            placeholder="Vehicle No (e.g. DL01AB1234) or Challan No"
            className="flex-1 px-4 py-3 rounded-xl border border-slate-300 dark:border-slate-700 bg-slate-50 dark:bg-slate-800 text-slate-900 dark:text-white font-mono text-sm uppercase focus:ring-2 focus:ring-rose-500 focus:outline-none"
          />
          <button
            type="submit"
            disabled={loading || !searchTerm.trim()}
            className="bg-rose-600 hover:bg-rose-700 text-white font-bold px-5 py-3 rounded-xl shadow-md transition-all flex items-center gap-1.5 text-sm shrink-0 disabled:opacity-50"
          >
            {loading ? (
              <div className="w-4 h-4 border-2 border-white/30 border-t-white rounded-full animate-spin" />
            ) : (
              <>
                <Search className="w-4 h-4" />
                <span>Check</span>
              </>
            )}
          </button>
        </form>

        <div className="flex items-center gap-2 mt-3 pt-2 border-t border-slate-100 dark:border-slate-800 text-[11px] text-slate-500">
          <span>Quick checks:</span>
          <button
            onClick={() => {
              setSearchTerm('DL01AB1234');
              handleSearch('DL01AB1234');
            }}
            className="font-mono text-blue-600 dark:text-blue-400 hover:underline"
          >
            DL01AB1234
          </button>
          <span>•</span>
          <button
            onClick={() => {
              setSearchTerm('MH12DE1433');
              handleSearch('MH12DE1433');
            }}
            className="font-mono text-blue-600 dark:text-blue-400 hover:underline"
          >
            MH12DE1433
          </button>
          <span>•</span>
          <button
            onClick={() => {
              setSearchTerm('KA05MJ5005');
              handleSearch('KA05MJ5005');
            }}
            className="font-mono text-blue-600 dark:text-blue-400 hover:underline"
          >
            KA05MJ5005
          </button>
        </div>
      </div>

      {/* Error state */}
      {error && (
        <div className="bg-slate-50 dark:bg-slate-900 border border-slate-200 dark:border-slate-800 p-6 rounded-2xl text-center max-w-lg mx-auto space-y-2">
          <CheckCircle2 className="w-8 h-8 text-emerald-500 mx-auto" />
          <h4 className="font-bold text-slate-900 dark:text-white text-sm">No Pending Challans</h4>
          <p className="text-xs text-slate-500">{error}</p>
        </div>
      )}

      {/* Challan Results Overview */}
      {meta && (
        <div className="grid grid-cols-1 sm:grid-cols-3 gap-3">
          <div className="bg-white dark:bg-slate-900 p-4 rounded-xl border border-slate-200 dark:border-slate-800 text-center">
            <span className="text-[10px] text-slate-400 uppercase tracking-wider block font-bold">Total Records</span>
            <span className="text-2xl font-black text-slate-900 dark:text-white">{meta.totalChallans}</span>
          </div>
          <div className="bg-white dark:bg-slate-900 p-4 rounded-xl border border-slate-200 dark:border-slate-800 text-center">
            <span className="text-[10px] text-slate-400 uppercase tracking-wider block font-bold">Pending Challans</span>
            <span className="text-2xl font-black text-rose-600 dark:text-rose-400">{meta.pendingCount}</span>
          </div>
          <div className="bg-white dark:bg-slate-900 p-4 rounded-xl border border-slate-200 dark:border-slate-800 text-center">
            <span className="text-[10px] text-slate-400 uppercase tracking-wider block font-bold">Total Fine Due</span>
            <span className="text-2xl font-black text-rose-600 dark:text-rose-400 font-mono">
              ₹{meta.pendingAmount.toLocaleString('en-IN')}
            </span>
          </div>
        </div>
      )}

      {/* Challan Cards List */}
      <div className="space-y-4">
        {challans.map((challan) => (
          <div
            key={challan.challanNo}
            className="bg-white dark:bg-slate-900 border border-slate-200 dark:border-slate-800 rounded-2xl p-5 shadow-sm space-y-4 relative overflow-hidden"
          >
            {/* Top Bar with Status Badge */}
            <div className="flex items-start justify-between gap-3 border-b border-slate-100 dark:border-slate-800 pb-3">
              <div>
                <span className="text-[10px] font-mono text-slate-400 block">CHALLAN NUMBER</span>
                <span className="text-base font-bold font-mono text-slate-900 dark:text-white">
                  {challan.challanNo}
                </span>
                <span className="text-xs font-semibold text-blue-600 dark:text-blue-400 block mt-0.5">
                  Vehicle: {challan.regNo}
                </span>
              </div>

              <div className="text-right">
                <span
                  className={`inline-block px-3 py-1 rounded-full text-xs font-bold ${
                    challan.status === 'PAID'
                      ? 'bg-emerald-100 dark:bg-emerald-950/80 text-emerald-700 dark:text-emerald-300'
                      : 'bg-rose-100 dark:bg-rose-950/80 text-rose-700 dark:text-rose-300 animate-pulse'
                  }`}
                >
                  {challan.status}
                </span>
                <div className="text-lg font-black text-slate-900 dark:text-white font-mono mt-1">
                  ₹{challan.amount.toLocaleString('en-IN')}
                </div>
              </div>
            </div>

            {/* Violation & Offense Details */}
            <div className="grid grid-cols-1 md:grid-cols-2 gap-4 text-xs">
              <div className="space-y-2">
                <div>
                  <span className="text-slate-400 block">Violation Reason</span>
                  <span className="font-bold text-slate-900 dark:text-white text-sm">
                    {challan.violation}
                  </span>
                </div>
                <div>
                  <span className="text-slate-400 block">Act & Section</span>
                  <span className="font-semibold text-amber-600 dark:text-amber-400">
                    {challan.section}
                  </span>
                </div>
                <div>
                  <span className="text-slate-400 block">Enforcing Police Unit</span>
                  <span className="font-medium text-slate-700 dark:text-slate-300">
                    {challan.trafficPoliceUnit}
                  </span>
                </div>
              </div>

              <div className="space-y-2">
                <div className="flex items-start gap-1.5">
                  <MapPin className="w-3.5 h-3.5 text-slate-400 shrink-0 mt-0.5" />
                  <div>
                    <span className="text-slate-400 block">Location of Violation</span>
                    <span className="font-medium text-slate-800 dark:text-slate-200">
                      {challan.location}
                    </span>
                  </div>
                </div>
                <div className="flex items-center gap-1.5">
                  <Calendar className="w-3.5 h-3.5 text-slate-400" />
                  <div>
                    <span className="text-slate-400">Incident Date: </span>
                    <span className="font-medium text-slate-800 dark:text-slate-200">{challan.date}</span>
                  </div>
                </div>
                <div className="flex items-center gap-1.5">
                  <Camera className="w-3.5 h-3.5 text-slate-400" />
                  <div>
                    <span className="text-slate-400">ANPR Camera ID: </span>
                    <span className="font-mono text-slate-700 dark:text-slate-300">{challan.cameraCode}</span>
                  </div>
                </div>
              </div>
            </div>

            {/* Action buttons (Pay or Receipt) */}
            <div className="pt-3 border-t border-slate-100 dark:border-slate-800 flex items-center justify-between flex-wrap gap-2">
              <div className="text-[11px] text-slate-400">
                {challan.status === 'PENDING' ? (
                  <span>Payment Due Date: {challan.dueDate}</span>
                ) : (
                  <span className="text-emerald-600 dark:text-emerald-400 font-semibold">
                    Settled on {challan.paymentDetails?.paidAt}
                  </span>
                )}
              </div>

              <div>
                {challan.status === 'PENDING' ? (
                  <button
                    onClick={() => setActivePaymentChallan(challan)}
                    className="flex items-center gap-1.5 px-4 py-2 rounded-xl text-xs font-bold bg-rose-600 hover:bg-rose-700 text-white shadow-md transition-all active:scale-95"
                  >
                    <CreditCard className="w-4 h-4" />
                    <span>Pay Fine Online (₹{challan.amount})</span>
                  </button>
                ) : (
                  <button
                    onClick={() => setReceiptChallan(challan)}
                    className="flex items-center gap-1.5 px-3 py-1.5 rounded-xl text-xs font-semibold bg-emerald-100 hover:bg-emerald-200 dark:bg-emerald-950/80 dark:hover:bg-emerald-900 text-emerald-800 dark:text-emerald-200 transition-colors"
                  >
                    <Receipt className="w-4 h-4" />
                    <span>View Official Receipt</span>
                  </button>
                )}
              </div>
            </div>
          </div>
        ))}
      </div>

      {/* Simulated Payment Modal */}
      {activePaymentChallan && (
        <div className="fixed inset-0 z-50 bg-black/60 backdrop-blur-sm flex items-center justify-center p-4 animate-fadeIn">
          <div className="bg-white dark:bg-slate-900 border border-slate-200 dark:border-slate-800 rounded-2xl max-w-md w-full p-6 shadow-2xl space-y-4">
            <div className="flex items-center justify-between border-b border-slate-100 dark:border-slate-800 pb-3">
              <div className="flex items-center gap-2">
                <ShieldCheck className="w-5 h-5 text-emerald-600" />
                <h3 className="font-bold text-sm text-slate-900 dark:text-white">
                  Parivahan e-Pay Portal
                </h3>
              </div>
              <button
                onClick={() => setActivePaymentChallan(null)}
                className="text-slate-400 hover:text-slate-600 dark:hover:text-slate-200"
              >
                <X className="w-5 h-5" />
              </button>
            </div>

            <div className="bg-slate-50 dark:bg-slate-800/60 p-4 rounded-xl text-xs space-y-2">
              <div className="flex justify-between">
                <span className="text-slate-400">Challan No:</span>
                <span className="font-mono font-bold text-slate-900 dark:text-white">
                  {activePaymentChallan.challanNo}
                </span>
              </div>
              <div className="flex justify-between">
                <span className="text-slate-400">Violation:</span>
                <span className="font-medium text-slate-800 dark:text-slate-200">
                  {activePaymentChallan.violation}
                </span>
              </div>
              <div className="flex justify-between text-base font-black pt-2 border-t border-slate-200 dark:border-slate-700">
                <span className="text-slate-900 dark:text-white">Total Amount:</span>
                <span className="text-rose-600 dark:text-rose-400 font-mono">
                  ₹{activePaymentChallan.amount.toLocaleString('en-IN')}
                </span>
              </div>
            </div>

            {/* Payment Mode Selection */}
            <div className="space-y-2">
              <label className="text-xs font-bold text-slate-700 dark:text-slate-300 block">
                Select Payment Mode
              </label>
              <div className="grid grid-cols-3 gap-2 text-xs">
                {(['UPI', 'Card', 'NetBanking'] as const).map((mode) => (
                  <button
                    key={mode}
                    onClick={() => setPaymentMode(mode)}
                    className={`py-2 px-3 rounded-xl border text-center font-bold transition-all ${
                      paymentMode === mode
                        ? 'border-blue-600 bg-blue-50 dark:bg-blue-950/60 text-blue-600 dark:text-blue-400'
                        : 'border-slate-200 dark:border-slate-700 text-slate-600 dark:text-slate-400'
                    }`}
                  >
                    {mode === 'UPI' ? 'BHIM / UPI' : mode === 'Card' ? 'Debit/Credit' : 'Net Banking'}
                  </button>
                ))}
              </div>
            </div>

            <p className="text-[11px] text-slate-400 leading-relaxed">
              Upon successful settlement, a direct payment acknowledgement and legal receipt will be generated under the National Traffic Enforcement System.
            </p>

            <button
              onClick={handleProcessPayment}
              disabled={paying}
              className="w-full bg-emerald-600 hover:bg-emerald-700 text-white font-bold py-3.5 rounded-xl shadow-md transition-all flex items-center justify-center gap-2 text-sm disabled:opacity-50"
            >
              {paying ? (
                <div className="w-5 h-5 border-2 border-white/30 border-t-white rounded-full animate-spin" />
              ) : (
                <span>Authorize & Pay ₹{activePaymentChallan.amount}</span>
              )}
            </button>
          </div>
        </div>
      )}

      {/* Official Payment Receipt Modal */}
      {receiptChallan && receiptChallan.paymentDetails && (
        <div className="fixed inset-0 z-50 bg-black/60 backdrop-blur-sm flex items-center justify-center p-4 animate-fadeIn">
          <div className="bg-white dark:bg-slate-900 border border-slate-200 dark:border-slate-800 rounded-2xl max-w-md w-full p-6 shadow-2xl space-y-4">
            <div className="text-center space-y-1 border-b border-slate-100 dark:border-slate-800 pb-4">
              <CheckCircle2 className="w-10 h-10 text-emerald-500 mx-auto" />
              <h3 className="font-extrabold text-base text-slate-900 dark:text-white">
                PAYMENT RECEIPT (e-CHALLAN)
              </h3>
              <p className="text-[10px] text-slate-400 uppercase font-mono">
                Ministry of Road Transport and Highways
              </p>
            </div>

            <div className="bg-slate-50 dark:bg-slate-800/60 p-4 rounded-xl text-xs space-y-2.5">
              <div className="flex justify-between">
                <span className="text-slate-400">Receipt No:</span>
                <span className="font-mono font-bold text-slate-900 dark:text-white">
                  {receiptChallan.paymentDetails.receiptNo}
                </span>
              </div>
              <div className="flex justify-between">
                <span className="text-slate-400">Transaction ID:</span>
                <span className="font-mono text-slate-700 dark:text-slate-300">
                  {receiptChallan.paymentDetails.transactionId}
                </span>
              </div>
              <div className="flex justify-between">
                <span className="text-slate-400">Vehicle No:</span>
                <span className="font-mono font-bold text-slate-900 dark:text-white">
                  {receiptChallan.regNo}
                </span>
              </div>
              <div className="flex justify-between">
                <span className="text-slate-400">Challan No:</span>
                <span className="font-mono text-slate-700 dark:text-slate-300">
                  {receiptChallan.challanNo}
                </span>
              </div>
              <div className="flex justify-between">
                <span className="text-slate-400">Settled Amount:</span>
                <span className="font-mono font-black text-emerald-600 dark:text-emerald-400 text-sm">
                  ₹{receiptChallan.amount.toFixed(2)}
                </span>
              </div>
              <div className="flex justify-between">
                <span className="text-slate-400">Payment Date:</span>
                <span className="text-slate-800 dark:text-slate-200">
                  {receiptChallan.paymentDetails.paidAt}
                </span>
              </div>
            </div>

            <div className="flex items-center gap-2 pt-2">
              <button
                onClick={() => window.print()}
                className="flex-1 bg-slate-100 hover:bg-slate-200 dark:bg-slate-800 dark:hover:bg-slate-700 text-slate-700 dark:text-slate-300 font-bold py-2.5 rounded-xl text-xs flex items-center justify-center gap-1.5 transition-colors"
              >
                <Printer className="w-4 h-4" />
                <span>Print Receipt</span>
              </button>
              <button
                onClick={() => setReceiptChallan(null)}
                className="flex-1 bg-blue-600 hover:bg-blue-700 text-white font-bold py-2.5 rounded-xl text-xs transition-colors"
              >
                Done
              </button>
            </div>
          </div>
        </div>
      )}
    </div>
  );
};
