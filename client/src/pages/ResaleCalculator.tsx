import React, { useState } from 'react';
import { calculateResaleValue, calculateLoanEmi } from '../services/api';
import { Calculator, TrendingDown, DollarSign, PieChart, ShieldAlert, CheckCircle2 } from 'lucide-react';

export const ResaleCalculator: React.FC = () => {
  const [activeTab, setActiveTab] = useState<'resale' | 'loan'>('resale');

  // Resale State
  const [vehicleType, setVehicleType] = useState('Car');
  const [originalPrice, setOriginalPrice] = useState(950000);
  const [purchaseYear, setPurchaseYear] = useState(2021);
  const [kmsDriven, setKmsDriven] = useState(42000);
  const [condition, setCondition] = useState('Good');
  const [owners, setOwners] = useState(1);
  const [resaleResult, setResaleResult] = useState<any>(null);
  const [loadingResale, setLoadingResale] = useState(false);

  // Loan State
  const [vehiclePrice, setVehiclePrice] = useState(1200000);
  const [downPayment, setDownPayment] = useState(250000);
  const [interestRate, setInterestRate] = useState(8.85);
  const [tenureYears, setTenureYears] = useState(5);
  const [loanResult, setLoanResult] = useState<any>(null);
  const [loadingLoan, setLoadingLoan] = useState(false);

  const handleComputeResale = async (e?: React.FormEvent) => {
    if (e) e.preventDefault();
    setLoadingResale(true);
    try {
      const data = await calculateResaleValue({
        vehicleType,
        originalPrice,
        purchaseYear,
        kmsDriven,
        condition,
        owners
      });
      setResaleResult(data);
    } catch (err) {
      console.error(err);
    } finally {
      setLoadingResale(false);
    }
  };

  const handleComputeLoan = async (e?: React.FormEvent) => {
    if (e) e.preventDefault();
    setLoadingLoan(true);
    try {
      const data = await calculateLoanEmi({
        vehiclePrice,
        downPayment,
        interestRate,
        tenureMonths: tenureYears * 12
      });
      setLoanResult(data);
    } catch (err) {
      console.error(err);
    } finally {
      setLoadingLoan(false);
    }
  };

  return (
    <div className="max-w-4xl mx-auto space-y-8 px-4">
      {/* Header */}
      <div className="text-center space-y-2">
        <div className="inline-flex items-center gap-1.5 px-3 py-1 rounded-full bg-purple-50 dark:bg-purple-950/80 border border-purple-200 dark:border-purple-800 text-purple-700 dark:text-purple-300 text-xs font-semibold">
          <Calculator className="w-3.5 h-3.5" />
          <span>Automotive Valuation & Financial Planning</span>
        </div>
        <h1 className="text-2xl sm:text-3xl font-extrabold text-slate-900 dark:text-white">
          Vehicle Resale & Loan EMI Calculator
        </h1>
        <p className="text-xs sm:text-sm text-slate-500 dark:text-slate-400">
          Estimate used car/bike market valuation and calculate auto loan monthly EMIs
        </p>
      </div>

      {/* Tab Switcher */}
      <div className="flex justify-center">
        <div className="bg-slate-100 dark:bg-slate-800 p-1 rounded-2xl inline-flex text-xs font-bold">
          <button
            onClick={() => setActiveTab('resale')}
            className={`px-6 py-2.5 rounded-xl transition-all ${
              activeTab === 'resale'
                ? 'bg-white dark:bg-slate-900 text-slate-900 dark:text-white shadow-sm'
                : 'text-slate-500 hover:text-slate-900 dark:hover:text-white'
            }`}
          >
            Used Vehicle Resale Valuation
          </button>
          <button
            onClick={() => {
              setActiveTab('loan');
              if (!loanResult) handleComputeLoan();
            }}
            className={`px-6 py-2.5 rounded-xl transition-all ${
              activeTab === 'loan'
                ? 'bg-white dark:bg-slate-900 text-slate-900 dark:text-white shadow-sm'
                : 'text-slate-500 hover:text-slate-900 dark:hover:text-white'
            }`}
          >
            Vehicle Loan & EMI Calculator
          </button>
        </div>
      </div>

      {/* SECTION 1: RESALE VALUATION */}
      {activeTab === 'resale' && (
        <div className="space-y-6">
          <div className="bg-white dark:bg-slate-900 border border-slate-200 dark:border-slate-800 rounded-3xl p-6 sm:p-8 shadow-sm">
            <form onSubmit={handleComputeResale} className="space-y-6">
              <div className="grid grid-cols-1 sm:grid-cols-3 gap-4">
                <div>
                  <label className="block text-xs font-bold text-slate-700 dark:text-slate-300 mb-1.5">
                    Vehicle Type
                  </label>
                  <select
                    value={vehicleType}
                    onChange={(e) => setVehicleType(e.target.value)}
                    className="w-full px-3 py-2.5 rounded-xl border border-slate-300 dark:border-slate-700 bg-slate-50 dark:bg-slate-800 text-xs font-medium focus:ring-2 focus:ring-blue-500 focus:outline-none"
                  >
                    <option value="Car">Car / SUV / Sedan</option>
                    <option value="Motorcycle">Motorcycle / Bike</option>
                    <option value="Scooter">Scooter / Electric 2W</option>
                    <option value="Commercial">Commercial / LCV</option>
                  </select>
                </div>

                <div>
                  <label className="block text-xs font-bold text-slate-700 dark:text-slate-300 mb-1.5">
                    Original Price (₹)
                  </label>
                  <input
                    type="number"
                    step="10000"
                    value={originalPrice}
                    onChange={(e) => setOriginalPrice(parseFloat(e.target.value) || 0)}
                    className="w-full px-3 py-2.5 rounded-xl border border-slate-300 dark:border-slate-700 bg-slate-50 dark:bg-slate-800 text-xs font-mono font-bold focus:ring-2 focus:ring-blue-500 focus:outline-none"
                  />
                </div>

                <div>
                  <label className="block text-xs font-bold text-slate-700 dark:text-slate-300 mb-1.5">
                    Purchase Year
                  </label>
                  <select
                    value={purchaseYear}
                    onChange={(e) => setPurchaseYear(parseInt(e.target.value, 10))}
                    className="w-full px-3 py-2.5 rounded-xl border border-slate-300 dark:border-slate-700 bg-slate-50 dark:bg-slate-800 text-xs font-medium focus:ring-2 focus:ring-blue-500 focus:outline-none"
                  >
                    {[2025, 2024, 2023, 2022, 2021, 2020, 2019, 2018, 2017, 2016, 2015].map((y) => (
                      <option key={y} value={y}>
                        {y}
                      </option>
                    ))}
                  </select>
                </div>

                <div>
                  <label className="block text-xs font-bold text-slate-700 dark:text-slate-300 mb-1.5">
                    Kilometers Driven
                  </label>
                  <input
                    type="number"
                    step="1000"
                    value={kmsDriven}
                    onChange={(e) => setKmsDriven(parseFloat(e.target.value) || 0)}
                    className="w-full px-3 py-2.5 rounded-xl border border-slate-300 dark:border-slate-700 bg-slate-50 dark:bg-slate-800 text-xs font-mono focus:ring-2 focus:ring-blue-500 focus:outline-none"
                  />
                </div>

                <div>
                  <label className="block text-xs font-bold text-slate-700 dark:text-slate-300 mb-1.5">
                    Vehicle Condition
                  </label>
                  <select
                    value={condition}
                    onChange={(e) => setCondition(e.target.value)}
                    className="w-full px-3 py-2.5 rounded-xl border border-slate-300 dark:border-slate-700 bg-slate-50 dark:bg-slate-800 text-xs font-medium focus:ring-2 focus:ring-blue-500 focus:outline-none"
                  >
                    <option value="Excellent">Excellent (Like New / Timely Serviced)</option>
                    <option value="Good">Good (Minor wear / Clean records)</option>
                    <option value="Fair">Fair (Scratches / Service pending)</option>
                    <option value="Poor">Poor (Accidental / High wear)</option>
                  </select>
                </div>

                <div>
                  <label className="block text-xs font-bold text-slate-700 dark:text-slate-300 mb-1.5">
                    Number of Owners
                  </label>
                  <select
                    value={owners}
                    onChange={(e) => setOwners(parseInt(e.target.value, 10))}
                    className="w-full px-3 py-2.5 rounded-xl border border-slate-300 dark:border-slate-700 bg-slate-50 dark:bg-slate-800 text-xs font-medium focus:ring-2 focus:ring-blue-500 focus:outline-none"
                  >
                    <option value={1}>1st Owner</option>
                    <option value={2}>2nd Owner</option>
                    <option value={3}>3rd or more</option>
                  </select>
                </div>
              </div>

              <button
                type="submit"
                disabled={loadingResale}
                className="w-full bg-blue-600 hover:bg-blue-700 text-white font-bold py-3.5 rounded-xl shadow-md transition-all text-xs"
              >
                {loadingResale ? 'Evaluating Market Valuation...' : 'Calculate Resale Valuation'}
              </button>
            </form>
          </div>

          {/* Resale Result Card */}
          {resaleResult && (
            <div className="bg-gradient-to-br from-slate-900 via-indigo-950 to-slate-900 text-white rounded-3xl p-6 sm:p-8 shadow-xl space-y-6 border border-slate-800 animate-fadeIn">
              <div className="flex items-center justify-between border-b border-white/10 pb-4">
                <div>
                  <span className="text-[10px] text-amber-400 uppercase tracking-widest font-bold">
                    Indian Used Vehicle Market Valuation
                  </span>
                  <h3 className="text-xl font-black text-white">Estimated Resale Price Range</h3>
                </div>
                <span className="px-3 py-1 rounded-full text-xs font-bold bg-emerald-500/20 text-emerald-300 border border-emerald-500/40">
                  {resaleResult.estimatedDemand}
                </span>
              </div>

              <div className="grid grid-cols-1 sm:grid-cols-3 gap-4 text-center">
                <div className="bg-white/10 p-4 rounded-2xl border border-white/5">
                  <span className="text-xs text-slate-300 block mb-1">Fair Market Value</span>
                  <span className="text-2xl sm:text-3xl font-black text-emerald-400 font-mono">
                    ₹{resaleResult.fairMarketValue.toLocaleString('en-IN')}
                  </span>
                  <span className="text-[10px] text-slate-400 block mt-1">Direct Buyer / P2P Sale</span>
                </div>

                <div className="bg-white/10 p-4 rounded-2xl border border-white/5">
                  <span className="text-xs text-slate-300 block mb-1">Dealer Resale Price</span>
                  <span className="text-2xl sm:text-3xl font-black text-amber-400 font-mono">
                    ₹{resaleResult.dealerResalePrice.toLocaleString('en-IN')}
                  </span>
                  <span className="text-[10px] text-slate-400 block mt-1">Certified Pre-owned Outlets</span>
                </div>

                <div className="bg-white/10 p-4 rounded-2xl border border-white/5">
                  <span className="text-xs text-slate-300 block mb-1">Instant Exchange Price</span>
                  <span className="text-2xl sm:text-3xl font-black text-sky-400 font-mono">
                    ₹{resaleResult.exchangePrice.toLocaleString('en-IN')}
                  </span>
                  <span className="text-[10px] text-slate-400 block mt-1">Immediate Dealership Trade-In</span>
                </div>
              </div>

              <div className="flex items-center justify-between text-xs text-slate-300 pt-2 border-t border-white/10">
                <span>Total Accumulated Depreciation: <strong>{resaleResult.depreciationPercentage}%</strong></span>
                <span>Price Range: <strong>₹{resaleResult.priceRange.min.toLocaleString('en-IN')} - ₹{resaleResult.priceRange.max.toLocaleString('en-IN')}</strong></span>
              </div>
            </div>
          )}
        </div>
      )}

      {/* SECTION 2: LOAN EMI CALCULATOR */}
      {activeTab === 'loan' && (
        <div className="space-y-6">
          <div className="bg-white dark:bg-slate-900 border border-slate-200 dark:border-slate-800 rounded-3xl p-6 sm:p-8 shadow-sm">
            <form onSubmit={handleComputeLoan} className="space-y-6">
              <div className="grid grid-cols-1 sm:grid-cols-2 gap-6">
                <div>
                  <div className="flex justify-between text-xs font-bold text-slate-700 dark:text-slate-300 mb-1.5">
                    <span>Vehicle On-Road Price</span>
                    <span className="font-mono text-blue-600 dark:text-blue-400">
                      ₹{vehiclePrice.toLocaleString('en-IN')}
                    </span>
                  </div>
                  <input
                    type="range"
                    min="100000"
                    max="5000000"
                    step="25000"
                    value={vehiclePrice}
                    onChange={(e) => setVehiclePrice(parseFloat(e.target.value))}
                    className="w-full accent-blue-600"
                  />
                </div>

                <div>
                  <div className="flex justify-between text-xs font-bold text-slate-700 dark:text-slate-300 mb-1.5">
                    <span>Down Payment Amount</span>
                    <span className="font-mono text-emerald-600 dark:text-emerald-400">
                      ₹{downPayment.toLocaleString('en-IN')}
                    </span>
                  </div>
                  <input
                    type="range"
                    min="0"
                    max={vehiclePrice * 0.8}
                    step="10000"
                    value={downPayment}
                    onChange={(e) => setDownPayment(parseFloat(e.target.value))}
                    className="w-full accent-emerald-600"
                  />
                </div>

                <div>
                  <div className="flex justify-between text-xs font-bold text-slate-700 dark:text-slate-300 mb-1.5">
                    <span>Interest Rate (% per annum)</span>
                    <span className="font-mono text-amber-600 dark:text-amber-400">{interestRate}%</span>
                  </div>
                  <input
                    type="range"
                    min="6.5"
                    max="18"
                    step="0.25"
                    value={interestRate}
                    onChange={(e) => setInterestRate(parseFloat(e.target.value))}
                    className="w-full accent-amber-600"
                  />
                </div>

                <div>
                  <div className="flex justify-between text-xs font-bold text-slate-700 dark:text-slate-300 mb-1.5">
                    <span>Loan Tenure</span>
                    <span className="font-mono text-purple-600 dark:text-purple-400">
                      {tenureYears} Years ({tenureYears * 12} Months)
                    </span>
                  </div>
                  <input
                    type="range"
                    min="1"
                    max="7"
                    step="1"
                    value={tenureYears}
                    onChange={(e) => setTenureYears(parseInt(e.target.value, 10))}
                    className="w-full accent-purple-600"
                  />
                </div>
              </div>

              <button
                type="submit"
                disabled={loadingLoan}
                className="w-full bg-blue-600 hover:bg-blue-700 text-white font-bold py-3.5 rounded-xl shadow-md transition-all text-xs"
              >
                {loadingLoan ? 'Calculating EMI...' : 'Calculate Monthly EMI'}
              </button>
            </form>
          </div>

          {/* Loan Output Card */}
          {loanResult && (
            <div className="bg-gradient-to-br from-slate-900 via-indigo-950 to-slate-900 text-white rounded-3xl p-6 sm:p-8 shadow-xl space-y-6 border border-slate-800 animate-fadeIn">
              <div className="text-center space-y-1">
                <span className="text-[10px] text-slate-400 uppercase tracking-widest font-bold">
                  Estimated Monthly Installment
                </span>
                <div className="text-3xl sm:text-5xl font-black text-amber-400 font-mono">
                  ₹{loanResult.monthlyEmi.toLocaleString('en-IN')}
                  <span className="text-sm font-normal text-slate-300"> /month</span>
                </div>
              </div>

              <div className="grid grid-cols-1 sm:grid-cols-3 gap-4 pt-4 border-t border-white/10 text-center">
                <div className="bg-white/10 p-4 rounded-2xl">
                  <span className="text-xs text-slate-400 block mb-1">Principal Loan Amount</span>
                  <span className="text-lg font-bold text-white font-mono">
                    ₹{loanResult.principalLoanAmount.toLocaleString('en-IN')}
                  </span>
                </div>
                <div className="bg-white/10 p-4 rounded-2xl">
                  <span className="text-xs text-slate-400 block mb-1">Total Interest Payable</span>
                  <span className="text-lg font-bold text-rose-400 font-mono">
                    ₹{loanResult.totalInterestPayable.toLocaleString('en-IN')}
                  </span>
                </div>
                <div className="bg-white/10 p-4 rounded-2xl">
                  <span className="text-xs text-slate-400 block mb-1">Total Amount (Principal + Int)</span>
                  <span className="text-lg font-bold text-emerald-400 font-mono">
                    ₹{loanResult.totalAmountPayable.toLocaleString('en-IN')}
                  </span>
                </div>
              </div>
            </div>
          )}
        </div>
      )}
    </div>
  );
};
