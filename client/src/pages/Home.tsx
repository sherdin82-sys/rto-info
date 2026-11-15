import React, { useState, useEffect } from 'react';
import { NumberPlateInput } from '../components/NumberPlateInput';
import { FuelPrice } from '../types';
import { fetchFuelPrices } from '../services/api';
import {
  ShieldCheck,
  FileCheck2,
  AlertCircle,
  Building2,
  Fuel,
  Calculator,
  GraduationCap,
  Signpost,
  CheckCircle,
  ArrowRight,
  TrendingDown,
  TrendingUp,
  Sparkles
} from 'lucide-react';

interface HomeProps {
  onSearchRc: (plate: string) => void;
  onNavigateTab: (tab: string) => void;
}

export const Home: React.FC<HomeProps> = ({ onSearchRc, onNavigateTab }) => {
  const [plateNumber, setPlateNumber] = useState('');
  const [fuelRates, setFuelRates] = useState<FuelPrice[]>([]);
  const [loadingFuel, setLoadingFuel] = useState(false);

  useEffect(() => {
    setLoadingFuel(true);
    fetchFuelPrices()
      .then((data) => setFuelRates(data.prices.slice(0, 4)))
      .catch((err) => console.error(err))
      .finally(() => setLoadingFuel(false));
  }, []);

  const featureCards = [
    {
      id: 'rc',
      title: 'Vehicle RC Details',
      desc: 'Owner details, insurance expiry, vehicle fitness, and registration age',
      icon: ShieldCheck,
      color: 'from-blue-600 to-indigo-600',
      badge: 'Popular'
    },
    {
      id: 'challan',
      title: 'e-Challan Status',
      desc: 'Check pending traffic violation fines, legal sections, and pay online',
      icon: AlertCircle,
      color: 'from-rose-600 to-red-600',
      badge: 'Fine Check'
    },
    {
      id: 'dl',
      title: 'Driving Licence Verification',
      desc: 'Verify DL validity, authorized vehicle classes, and issuing RTO authority',
      icon: FileCheck2,
      color: 'from-emerald-600 to-teal-600',
      badge: 'Sarathi'
    },
    {
      id: 'fuel',
      title: 'Daily Fuel Rates',
      desc: 'Real-time petrol, diesel, and CNG prices across major Indian cities',
      icon: Fuel,
      color: 'from-amber-600 to-orange-600',
      badge: 'Updated Today'
    },
    {
      id: 'resale',
      title: 'Resale & EMI Calculator',
      desc: 'Used vehicle market valuation and monthly loan EMI calculations',
      icon: Calculator,
      color: 'from-purple-600 to-indigo-600',
      badge: 'Finance'
    },
    {
      id: 'rto',
      title: 'All-India RTO Directory',
      desc: 'Addresses, contact numbers, and portal links for 100+ RTO offices',
      icon: Building2,
      color: 'from-sky-600 to-blue-600',
      badge: 'All States'
    },
    {
      id: 'exam',
      title: 'RTO Mock Exam',
      desc: 'Practice 150+ official Learner’s Licence test questions with scoring',
      icon: GraduationCap,
      color: 'from-teal-600 to-cyan-600',
      badge: 'Exam Prep'
    },
    {
      id: 'signs',
      title: 'Traffic Signs Guide',
      desc: 'Mandatory, Cautionary, and Informatory signs with penalties under MV Act',
      icon: Signpost,
      color: 'from-emerald-600 to-green-600',
      badge: 'Road Safety'
    }
  ];

  return (
    <div className="space-y-12">
      {/* Hero Section */}
      <section className="relative text-center pt-8 pb-4">
        {/* Decorative Indian Tricolor Aura */}
        <div className="absolute top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2 w-96 h-96 bg-gradient-to-tr from-orange-500/10 via-sky-500/10 to-green-500/10 blur-3xl rounded-full pointer-events-none"></div>

        <div className="relative z-10 max-w-3xl mx-auto space-y-4 px-4">
          <div className="inline-flex items-center gap-2 px-3 py-1 rounded-full bg-blue-50 dark:bg-blue-950/80 border border-blue-200 dark:border-blue-800 text-blue-700 dark:text-blue-300 text-xs font-semibold">
            <Sparkles className="w-3.5 h-3.5 text-amber-500" />
            <span>Fast, Reliable Indian Parivahan Vehicle Portal</span>
          </div>

          <h1 className="text-3xl sm:text-4xl md:text-5xl font-extrabold tracking-tight text-slate-900 dark:text-white leading-tight">
            Indian Vehicle & Transport Information at Your Fingertips
          </h1>

          <p className="text-sm sm:text-base text-slate-600 dark:text-slate-300 max-w-xl mx-auto">
            Instantly lookup Vehicle Registration (RC), Driving Licence details, pending e-Challan fines, and daily fuel prices across India.
          </p>

          {/* Interactive HSRP Plate Search Box */}
          <div className="pt-4">
            <NumberPlateInput
              value={plateNumber}
              onChange={setPlateNumber}
              onSearch={(plate) => {
                if (plate.trim()) {
                  onSearchRc(plate);
                }
              }}
              placeholder="ENTER VEHICLE NUMBER"
            />
          </div>
        </div>
      </section>

      {/* Live Metro Fuel Prices Ticker */}
      {fuelRates.length > 0 && (
        <section className="max-w-6xl mx-auto px-4">
          <div className="bg-white dark:bg-slate-900 border border-slate-200 dark:border-slate-800 rounded-2xl p-4 shadow-sm">
            <div className="flex items-center justify-between mb-3">
              <div className="flex items-center gap-2">
                <Fuel className="w-4 h-4 text-amber-500" />
                <h3 className="text-xs font-bold uppercase tracking-wider text-slate-700 dark:text-slate-200">
                  Live Fuel Rates Today (Metro Cities)
                </h3>
              </div>
              <button
                onClick={() => onNavigateTab('fuel')}
                className="text-xs font-semibold text-blue-600 dark:text-blue-400 hover:underline flex items-center gap-1"
              >
                <span>View All Cities</span>
                <ArrowRight className="w-3 h-3" />
              </button>
            </div>

            <div className="grid grid-cols-2 sm:grid-cols-4 gap-3">
              {fuelRates.map((f) => (
                <div
                  key={f.city}
                  className="bg-slate-50 dark:bg-slate-800/60 rounded-xl p-3 border border-slate-200/80 dark:border-slate-700/60"
                >
                  <div className="flex items-center justify-between text-xs font-bold text-slate-900 dark:text-white mb-1">
                    <span>{f.city}</span>
                    <span className="text-[10px] text-slate-400 font-normal">{f.state}</span>
                  </div>
                  <div className="flex items-baseline justify-between text-xs">
                    <span className="text-slate-500 dark:text-slate-400">Petrol:</span>
                    <span className="font-bold text-slate-900 dark:text-slate-100 font-mono">
                      ₹{f.petrol.toFixed(2)}/L
                    </span>
                  </div>
                  <div className="flex items-baseline justify-between text-xs mt-0.5">
                    <span className="text-slate-500 dark:text-slate-400">Diesel:</span>
                    <span className="font-bold text-slate-900 dark:text-slate-100 font-mono">
                      ₹{f.diesel.toFixed(2)}/L
                    </span>
                  </div>
                </div>
              ))}
            </div>
          </div>
        </section>
      )}

      {/* Feature Navigation Grid */}
      <section className="max-w-6xl mx-auto px-4">
        <div className="text-center mb-8">
          <h2 className="text-xl sm:text-2xl font-bold text-slate-900 dark:text-white">
            Essential RTO Tools & Services
          </h2>
          <p className="text-xs sm:text-sm text-slate-500 dark:text-slate-400 mt-1">
            Everything you need for vehicle management and compliance under Indian Motor Vehicles Act
          </p>
        </div>

        <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4">
          {featureCards.map((card) => {
            const Icon = card.icon;
            return (
              <div
                key={card.id}
                onClick={() => onNavigateTab(card.id)}
                className="group relative bg-white dark:bg-slate-900 border border-slate-200 dark:border-slate-800 hover:border-blue-500/50 dark:hover:border-blue-500/50 rounded-2xl p-5 shadow-sm hover:shadow-lg transition-all duration-200 cursor-pointer flex flex-col justify-between"
              >
                <div>
                  <div className="flex items-center justify-between mb-4">
                    <div
                      className={`w-11 h-11 rounded-xl bg-gradient-to-br ${card.color} text-white flex items-center justify-center shadow-md group-hover:scale-105 transition-transform`}
                    >
                      <Icon className="w-5 h-5" />
                    </div>
                    <span className="text-[10px] font-bold px-2 py-0.5 rounded-full bg-slate-100 dark:bg-slate-800 text-slate-600 dark:text-slate-300">
                      {card.badge}
                    </span>
                  </div>
                  <h3 className="text-sm font-bold text-slate-900 dark:text-white group-hover:text-blue-600 dark:group-hover:text-blue-400 transition-colors mb-1.5">
                    {card.title}
                  </h3>
                  <p className="text-xs text-slate-500 dark:text-slate-400 leading-relaxed">
                    {card.desc}
                  </p>
                </div>

                <div className="mt-4 pt-3 border-t border-slate-100 dark:border-slate-800 flex items-center justify-between text-xs font-semibold text-blue-600 dark:text-blue-400">
                  <span>Explore Now</span>
                  <ArrowRight className="w-3.5 h-3.5 group-hover:translate-x-1 transition-transform" />
                </div>
              </div>
            );
          })}
        </div>
      </section>

      {/* Compliance & Motor Vehicles Act Highlights */}
      <section className="max-w-6xl mx-auto px-4">
        <div className="bg-gradient-to-r from-blue-900 to-indigo-950 text-white rounded-3xl p-6 sm:p-8 shadow-xl relative overflow-hidden">
          <div className="relative z-10 grid grid-cols-1 md:grid-cols-3 gap-6">
            <div className="space-y-2">
              <div className="flex items-center gap-2 text-amber-400 font-bold text-xs uppercase tracking-wider">
                <CheckCircle className="w-4 h-4" />
                <span>Section 139 MV Act</span>
              </div>
              <h4 className="text-base font-bold text-white">Digital Document Validity</h4>
              <p className="text-xs text-slate-300 leading-relaxed">
                As per MoRTH notifications, digital Driving Licences and RC cards presented via DigiLocker or mParivahan are treated at par with physical original documents.
              </p>
            </div>

            <div className="space-y-2">
              <div className="flex items-center gap-2 text-emerald-400 font-bold text-xs uppercase tracking-wider">
                <CheckCircle className="w-4 h-4" />
                <span>Mandatory Third-Party</span>
              </div>
              <h4 className="text-base font-bold text-white">Motor Insurance Compliance</h4>
              <p className="text-xs text-slate-300 leading-relaxed">
                Driving without active third-party motor insurance is punishable under Section 196 with a fine of ₹2,000 and/or imprisonment for up to 3 months.
              </p>
            </div>

            <div className="space-y-2">
              <div className="flex items-center gap-2 text-sky-400 font-bold text-xs uppercase tracking-wider">
                <CheckCircle className="w-4 h-4" />
                <span>HSRP Guidelines</span>
              </div>
              <h4 className="text-base font-bold text-white">High Security Number Plates</h4>
              <p className="text-xs text-slate-300 leading-relaxed">
                All vehicles registered before April 2019 must mandatorily affix tamper-proof High Security Registration Plates with chromium-based hologram.
              </p>
            </div>
          </div>
        </div>
      </section>
    </div>
  );
};
