import React, { useState, useEffect } from 'react';
import { FuelPrice } from '../types';
import { fetchFuelPrices } from '../services/api';
import { Fuel, TrendingUp, TrendingDown, Search, Calculator, ArrowRight, Zap } from 'lucide-react';

export const FuelPrices: React.FC = () => {
  const [prices, setPrices] = useState<FuelPrice[]>([]);
  const [nationalAvg, setNationalAvg] = useState<{ petrol: number; diesel: number; cng: number; lpg: number } | null>(null);
  const [searchCity, setSearchCity] = useState('');
  const [loading, setLoading] = useState(false);

  // Trip Calculator State
  const [distanceKm, setDistanceKm] = useState<number>(200);
  const [mileageKmpl, setMileageKmpl] = useState<number>(18);
  const [calcFuelType, setCalcFuelType] = useState<'petrol' | 'diesel' | 'cng'>('petrol');
  const [selectedCalcCity, setSelectedCalcCity] = useState<string>('New Delhi');

  useEffect(() => {
    setLoading(true);
    fetchFuelPrices()
      .then((data) => {
        setPrices(data.prices);
        setNationalAvg(data.nationalAverage);
      })
      .catch(console.error)
      .finally(() => setLoading(false));
  }, []);

  const filteredPrices = prices.filter(
    (p) =>
      p.city.toLowerCase().includes(searchCity.toLowerCase()) ||
      p.state.toLowerCase().includes(searchCity.toLowerCase())
  );

  // Compute Trip Cost
  const activePriceObj = prices.find((p) => p.city === selectedCalcCity) || prices[0];
  const currentRate = activePriceObj ? (calcFuelType === 'petrol' ? activePriceObj.petrol : (calcFuelType === 'diesel' ? activePriceObj.diesel : activePriceObj.cng)) : 95.0;
  const fuelNeededLiters = distanceKm > 0 && mileageKmpl > 0 ? (distanceKm / mileageKmpl) : 0;
  const totalTripCost = fuelNeededLiters * currentRate;
  const costPerKm = distanceKm > 0 ? (totalTripCost / distanceKm) : 0;

  return (
    <div className="max-w-5xl mx-auto space-y-8 px-4">
      {/* Header */}
      <div className="text-center space-y-2">
        <div className="inline-flex items-center gap-1.5 px-3 py-1 rounded-full bg-amber-50 dark:bg-amber-950/80 border border-amber-200 dark:border-amber-800 text-amber-700 dark:text-amber-300 text-xs font-semibold">
          <Fuel className="w-3.5 h-3.5" />
          <span>Daily Revised Indian Fuel Rates</span>
        </div>
        <h1 className="text-2xl sm:text-3xl font-extrabold text-slate-900 dark:text-white">
          Petrol, Diesel & CNG Prices in India
        </h1>
        <p className="text-xs sm:text-sm text-slate-500 dark:text-slate-400">
          Check live fuel rates across major Indian metro cities and calculate travel fuel expenses
        </p>
      </div>

      {/* National Average Snapshot */}
      {nationalAvg && (
        <div className="grid grid-cols-2 sm:grid-cols-4 gap-3">
          <div className="bg-white dark:bg-slate-900 p-4 rounded-2xl border border-slate-200 dark:border-slate-800 text-center shadow-sm">
            <span className="text-[10px] font-bold text-slate-400 uppercase tracking-wider block">Petrol (Avg)</span>
            <span className="text-2xl font-black text-amber-500 font-mono">₹{nationalAvg.petrol.toFixed(2)}</span>
            <span className="text-[10px] text-slate-400 block mt-0.5">per Litre</span>
          </div>
          <div className="bg-white dark:bg-slate-900 p-4 rounded-2xl border border-slate-200 dark:border-slate-800 text-center shadow-sm">
            <span className="text-[10px] font-bold text-slate-400 uppercase tracking-wider block">Diesel (Avg)</span>
            <span className="text-2xl font-black text-blue-500 font-mono">₹{nationalAvg.diesel.toFixed(2)}</span>
            <span className="text-[10px] text-slate-400 block mt-0.5">per Litre</span>
          </div>
          <div className="bg-white dark:bg-slate-900 p-4 rounded-2xl border border-slate-200 dark:border-slate-800 text-center shadow-sm">
            <span className="text-[10px] font-bold text-slate-400 uppercase tracking-wider block">CNG (Avg)</span>
            <span className="text-2xl font-black text-emerald-500 font-mono">₹{nationalAvg.cng.toFixed(2)}</span>
            <span className="text-[10px] text-slate-400 block mt-0.5">per Kg</span>
          </div>
          <div className="bg-white dark:bg-slate-900 p-4 rounded-2xl border border-slate-200 dark:border-slate-800 text-center shadow-sm">
            <span className="text-[10px] font-bold text-slate-400 uppercase tracking-wider block">Auto LPG (Avg)</span>
            <span className="text-2xl font-black text-purple-500 font-mono">₹{nationalAvg.lpg.toFixed(2)}</span>
            <span className="text-[10px] text-slate-400 block mt-0.5">per Litre</span>
          </div>
        </div>
      )}

      {/* Trip Fuel Cost Calculator Card */}
      <div className="bg-gradient-to-br from-slate-900 via-indigo-950 to-slate-900 text-white rounded-3xl p-6 sm:p-8 shadow-xl border border-slate-800 space-y-6">
        <div className="flex items-center gap-2 border-b border-white/10 pb-4">
          <Calculator className="w-6 h-6 text-amber-400" />
          <div>
            <h3 className="font-bold text-base text-white">Trip Fuel Expense Estimator</h3>
            <p className="text-xs text-slate-400">Calculate total fuel budget based on distance, mileage, and city rates</p>
          </div>
        </div>

        <div className="grid grid-cols-1 sm:grid-cols-4 gap-4">
          <div>
            <label className="block text-xs font-bold text-slate-300 mb-1">One-Way / Round Distance (km)</label>
            <input
              type="number"
              value={distanceKm}
              onChange={(e) => setDistanceKm(Math.max(1, parseFloat(e.target.value) || 0))}
              className="w-full px-3 py-2 rounded-xl bg-slate-800 text-white font-mono text-sm border border-slate-700 focus:outline-none focus:border-amber-400"
            />
          </div>

          <div>
            <label className="block text-xs font-bold text-slate-300 mb-1">Vehicle Mileage (km/L or km/kg)</label>
            <input
              type="number"
              value={mileageKmpl}
              onChange={(e) => setMileageKmpl(Math.max(1, parseFloat(e.target.value) || 0))}
              className="w-full px-3 py-2 rounded-xl bg-slate-800 text-white font-mono text-sm border border-slate-700 focus:outline-none focus:border-amber-400"
            />
          </div>

          <div>
            <label className="block text-xs font-bold text-slate-300 mb-1">Fuel Type</label>
            <select
              value={calcFuelType}
              onChange={(e) => setCalcFuelType(e.target.value as any)}
              className="w-full px-3 py-2 rounded-xl bg-slate-800 text-white text-sm border border-slate-700 focus:outline-none focus:border-amber-400"
            >
              <option value="petrol">Petrol</option>
              <option value="diesel">Diesel</option>
              <option value="cng">CNG</option>
            </select>
          </div>

          <div>
            <label className="block text-xs font-bold text-slate-300 mb-1">Reference City</label>
            <select
              value={selectedCalcCity}
              onChange={(e) => setSelectedCalcCity(e.target.value)}
              className="w-full px-3 py-2 rounded-xl bg-slate-800 text-white text-sm border border-slate-700 focus:outline-none focus:border-amber-400"
            >
              {prices.map((p) => (
                <option key={p.city} value={p.city}>
                  {p.city}
                </option>
              ))}
            </select>
          </div>
        </div>

        {/* Calculation Result */}
        <div className="bg-white/10 rounded-2xl p-4 sm:p-6 grid grid-cols-1 sm:grid-cols-3 gap-4 text-center backdrop-blur-sm border border-white/5">
          <div>
            <span className="text-[10px] text-slate-400 uppercase tracking-wider block">Fuel Quantity</span>
            <span className="text-xl sm:text-2xl font-black text-white font-mono">
              {fuelNeededLiters.toFixed(1)} {calcFuelType === 'cng' ? 'Kg' : 'L'}
            </span>
          </div>
          <div>
            <span className="text-[10px] text-slate-400 uppercase tracking-wider block">Estimated Fuel Cost</span>
            <span className="text-2xl sm:text-3xl font-black text-amber-400 font-mono">
              ₹{Math.round(totalTripCost).toLocaleString('en-IN')}
            </span>
          </div>
          <div>
            <span className="text-[10px] text-slate-400 uppercase tracking-wider block">Running Cost</span>
            <span className="text-xl sm:text-2xl font-black text-emerald-400 font-mono">
              ₹{costPerKm.toFixed(2)}/km
            </span>
          </div>
        </div>
      </div>

      {/* City-wise Table & Search */}
      <div className="space-y-4">
        <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-3">
          <h3 className="font-bold text-lg text-slate-900 dark:text-white">City-wise Daily Fuel Rates</h3>
          <div className="relative max-w-xs w-full">
            <input
              type="text"
              value={searchCity}
              onChange={(e) => setSearchCity(e.target.value)}
              placeholder="Search city or state..."
              className="w-full pl-9 pr-3 py-2 rounded-xl border border-slate-300 dark:border-slate-700 bg-white dark:bg-slate-900 text-xs text-slate-900 dark:text-white focus:outline-none focus:ring-2 focus:ring-blue-500"
            />
            <Search className="w-4 h-4 text-slate-400 absolute left-3 top-2.5 pointer-events-none" />
          </div>
        </div>

        <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-4">
          {filteredPrices.map((item) => (
            <div
              key={item.city}
              className="bg-white dark:bg-slate-900 border border-slate-200 dark:border-slate-800 rounded-2xl p-5 shadow-sm space-y-3"
            >
              <div className="flex items-start justify-between border-b border-slate-100 dark:border-slate-800 pb-2">
                <div>
                  <h4 className="font-bold text-slate-900 dark:text-white text-base">{item.city}</h4>
                  <span className="text-xs text-slate-400">{item.state}</span>
                </div>
                <span className="text-[10px] font-mono text-slate-400 bg-slate-100 dark:bg-slate-800 px-2 py-0.5 rounded">
                  {item.lastUpdated}
                </span>
              </div>

              <div className="grid grid-cols-2 gap-3 text-xs">
                <div className="bg-amber-50 dark:bg-amber-950/30 p-2.5 rounded-xl border border-amber-200 dark:border-amber-900/40">
                  <span className="text-slate-500 dark:text-slate-400 block text-[10px]">Petrol</span>
                  <span className="text-base font-black text-slate-900 dark:text-white font-mono">
                    ₹{item.petrol.toFixed(2)}
                  </span>
                  <div className="flex items-center gap-1 text-[10px] mt-0.5">
                    {item.changePetrol < 0 ? (
                      <span className="text-emerald-600 flex items-center font-bold">
                        <TrendingDown className="w-3 h-3" /> {item.changePetrol.toFixed(2)}
                      </span>
                    ) : item.changePetrol > 0 ? (
                      <span className="text-rose-600 flex items-center font-bold">
                        <TrendingUp className="w-3 h-3" /> +{item.changePetrol.toFixed(2)}
                      </span>
                    ) : (
                      <span className="text-slate-400">No change</span>
                    )}
                  </div>
                </div>

                <div className="bg-blue-50 dark:bg-blue-950/30 p-2.5 rounded-xl border border-blue-200 dark:border-blue-900/40">
                  <span className="text-slate-500 dark:text-slate-400 block text-[10px]">Diesel</span>
                  <span className="text-base font-black text-slate-900 dark:text-white font-mono">
                    ₹{item.diesel.toFixed(2)}
                  </span>
                  <div className="flex items-center gap-1 text-[10px] mt-0.5">
                    {item.changeDiesel < 0 ? (
                      <span className="text-emerald-600 flex items-center font-bold">
                        <TrendingDown className="w-3 h-3" /> {item.changeDiesel.toFixed(2)}
                      </span>
                    ) : item.changeDiesel > 0 ? (
                      <span className="text-rose-600 flex items-center font-bold">
                        <TrendingUp className="w-3 h-3" /> +{item.changeDiesel.toFixed(2)}
                      </span>
                    ) : (
                      <span className="text-slate-400">No change</span>
                    )}
                  </div>
                </div>

                <div className="bg-slate-50 dark:bg-slate-800/60 p-2 rounded-xl">
                  <span className="text-slate-400 block text-[10px]">CNG Rate</span>
                  <span className="font-bold text-slate-800 dark:text-slate-200 font-mono">
                    ₹{item.cng.toFixed(2)}/kg
                  </span>
                </div>

                <div className="bg-slate-50 dark:bg-slate-800/60 p-2 rounded-xl">
                  <span className="text-slate-400 block text-[10px]">Auto LPG</span>
                  <span className="font-bold text-slate-800 dark:text-slate-200 font-mono">
                    ₹{item.lpg.toFixed(2)}/L
                  </span>
                </div>
              </div>
            </div>
          ))}
        </div>
      </div>
    </div>
  );
};
