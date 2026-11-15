import React, { useState, useEffect } from 'react';
import { TrafficSign } from '../types';
import { fetchTrafficSigns, fetchRtoServices } from '../services/api';
import {
  Signpost,
  OctagonAlert,
  Triangle,
  Ban,
  Gauge,
  CircleSlash2,
  CarFront,
  VolumeX,
  CornerUpRight,
  Footprints,
  Backpack,
  Activity,
  ArrowDownUp,
  TrendingUp,
  Cross,
  Fuel,
  BriefcaseMedical,
  FileText,
  Search,
  AlertTriangle
} from 'lucide-react';

export const TrafficSigns: React.FC = () => {
  const [signs, setSigns] = useState<TrafficSign[]>([]);
  const [services, setServices] = useState<any[]>([]);
  const [selectedCategory, setSelectedCategory] = useState<string>('All');
  const [activeView, setActiveView] = useState<'signs' | 'forms'>('signs');
  const [searchQuery, setSearchQuery] = useState('');

  useEffect(() => {
    fetchTrafficSigns().then(setSigns).catch(console.error);
    fetchRtoServices().then(setServices).catch(console.error);
  }, []);

  const getSignIcon = (iconName: string) => {
    const props = { className: 'w-7 h-7' };
    switch (iconName) {
      case 'OctagonAlert': return <OctagonAlert {...props} className="w-7 h-7 text-rose-600" />;
      case 'Triangle': return <Triangle {...props} className="w-7 h-7 text-amber-500" />;
      case 'Ban': return <Ban {...props} className="w-7 h-7 text-rose-600" />;
      case 'Gauge': return <Gauge {...props} className="w-7 h-7 text-rose-600" />;
      case 'CircleSlash2': return <CircleSlash2 {...props} className="w-7 h-7 text-rose-600" />;
      case 'CarFront': return <CarFront {...props} className="w-7 h-7 text-blue-600" />;
      case 'VolumeX': return <VolumeX {...props} className="w-7 h-7 text-rose-600" />;
      case 'CornerUpRight': return <CornerUpRight {...props} className="w-7 h-7 text-amber-500" />;
      case 'Footprints': return <Footprints {...props} className="w-7 h-7 text-amber-500" />;
      case 'Backpack': return <Backpack {...props} className="w-7 h-7 text-amber-500" />;
      case 'Activity': return <Activity {...props} className="w-7 h-7 text-amber-500" />;
      case 'ArrowDownUp': return <ArrowDownUp {...props} className="w-7 h-7 text-amber-500" />;
      case 'TrendingUp': return <TrendingUp {...props} className="w-7 h-7 text-amber-500" />;
      case 'Cross': return <Cross {...props} className="w-7 h-7 text-blue-500" />;
      case 'Fuel': return <Fuel {...props} className="w-7 h-7 text-blue-500" />;
      case 'BriefcaseMedical': return <BriefcaseMedical {...props} className="w-7 h-7 text-blue-500" />;
      default: return <Signpost {...props} className="w-7 h-7 text-slate-500" />;
    }
  };

  const filteredSigns = signs.filter((s) => {
    const matchesCat = selectedCategory === 'All' || s.category === selectedCategory;
    const matchesSearch = s.name.toLowerCase().includes(searchQuery.toLowerCase()) || s.meaning.toLowerCase().includes(searchQuery.toLowerCase());
    return matchesCat && matchesSearch;
  });

  return (
    <div className="max-w-5xl mx-auto space-y-8 px-4">
      {/* Header */}
      <div className="text-center space-y-2">
        <div className="inline-flex items-center gap-1.5 px-3 py-1 rounded-full bg-emerald-50 dark:bg-emerald-950/80 border border-emerald-200 dark:border-emerald-800 text-emerald-700 dark:text-emerald-300 text-xs font-semibold">
          <Signpost className="w-3.5 h-3.5" />
          <span>Indian Road Safety & Transport Manual</span>
        </div>
        <h1 className="text-2xl sm:text-3xl font-extrabold text-slate-900 dark:text-white">
          Traffic Signs & RTO Services Guide
        </h1>
        <p className="text-xs sm:text-sm text-slate-500 dark:text-slate-400">
          Learn mandatory, cautionary, and informatory road signs, standard fines, and RTO official forms
        </p>
      </div>

      {/* Main Switcher: Signs vs Forms */}
      <div className="flex justify-center">
        <div className="bg-slate-100 dark:bg-slate-800 p-1 rounded-2xl inline-flex text-xs font-bold">
          <button
            onClick={() => setActiveView('signs')}
            className={`px-6 py-2.5 rounded-xl transition-all ${
              activeView === 'signs'
                ? 'bg-white dark:bg-slate-900 text-slate-900 dark:text-white shadow-sm'
                : 'text-slate-500 hover:text-slate-900 dark:hover:text-white'
            }`}
          >
            Indian Traffic Signs & Penalties
          </button>
          <button
            onClick={() => setActiveView('forms')}
            className={`px-6 py-2.5 rounded-xl transition-all ${
              activeView === 'forms'
                ? 'bg-white dark:bg-slate-900 text-slate-900 dark:text-white shadow-sm'
                : 'text-slate-500 hover:text-slate-900 dark:hover:text-white'
            }`}
          >
            RTO Forms & Fee Schedule
          </button>
        </div>
      </div>

      {/* VIEW 1: TRAFFIC SIGNS */}
      {activeView === 'signs' && (
        <div className="space-y-6">
          {/* Category Tabs & Search Bar */}
          <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-3 bg-white dark:bg-slate-900 p-4 rounded-2xl border border-slate-200 dark:border-slate-800 shadow-sm">
            <div className="flex items-center gap-1.5 flex-wrap">
              {['All', 'Mandatory', 'Cautionary', 'Informatory'].map((cat) => (
                <button
                  key={cat}
                  onClick={() => setSelectedCategory(cat)}
                  className={`px-3 py-1.5 rounded-xl text-xs font-bold transition-all ${
                    selectedCategory === cat
                      ? 'bg-blue-600 text-white shadow-sm'
                      : 'bg-slate-100 dark:bg-slate-800 text-slate-600 dark:text-slate-300 hover:bg-slate-200'
                  }`}
                >
                  {cat === 'Mandatory' ? 'Mandatory (Red)' : cat === 'Cautionary' ? 'Cautionary (Warning)' : cat}
                </button>
              ))}
            </div>

            <div className="relative max-w-xs w-full">
              <input
                type="text"
                value={searchQuery}
                onChange={(e) => setSearchQuery(e.target.value)}
                placeholder="Search signs..."
                className="w-full pl-9 pr-3 py-2 rounded-xl border border-slate-300 dark:border-slate-700 bg-slate-50 dark:bg-slate-800 text-xs text-slate-900 dark:text-white focus:outline-none focus:ring-2 focus:ring-blue-500"
              />
              <Search className="w-4 h-4 text-slate-400 absolute left-3 top-2.5 pointer-events-none" />
            </div>
          </div>

          {/* Signs Cards Grid */}
          <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-4">
            {filteredSigns.map((sign) => (
              <div
                key={sign.id}
                className="bg-white dark:bg-slate-900 border border-slate-200 dark:border-slate-800 rounded-2xl p-5 shadow-sm space-y-3 hover:shadow-md transition-shadow"
              >
                <div className="flex items-center gap-3">
                  <div
                    className={`w-14 h-14 rounded-2xl flex items-center justify-center shrink-0 border-2 ${
                      sign.category === 'Mandatory'
                        ? 'border-rose-500 bg-rose-50 dark:bg-rose-950/30'
                        : sign.category === 'Cautionary'
                        ? 'border-amber-500 bg-amber-50 dark:bg-amber-950/30'
                        : 'border-blue-500 bg-blue-50 dark:bg-blue-950/30'
                    }`}
                  >
                    {getSignIcon(sign.iconName)}
                  </div>

                  <div>
                    <span
                      className={`text-[9px] font-bold uppercase tracking-wider px-2 py-0.5 rounded-full ${
                        sign.category === 'Mandatory'
                          ? 'bg-rose-100 text-rose-700 dark:bg-rose-950/80 dark:text-rose-300'
                          : sign.category === 'Cautionary'
                          ? 'bg-amber-100 text-amber-700 dark:bg-amber-950/80 dark:text-amber-300'
                          : 'bg-blue-100 text-blue-700 dark:bg-blue-950/80 dark:text-blue-300'
                      }`}
                    >
                      {sign.category} Sign
                    </span>
                    <h4 className="font-bold text-slate-900 dark:text-white text-sm mt-1">
                      {sign.name}
                    </h4>
                  </div>
                </div>

                <p className="text-xs text-slate-600 dark:text-slate-300 leading-relaxed">
                  {sign.meaning}
                </p>

                <div className="pt-2 border-t border-slate-100 dark:border-slate-800 flex items-center justify-between text-xs">
                  <span className="text-slate-400">Penalty under MV Act:</span>
                  <span className="font-bold font-mono text-rose-600 dark:text-rose-400">
                    {sign.fineUnderAct}
                  </span>
                </div>
              </div>
            ))}
          </div>
        </div>
      )}

      {/* VIEW 2: RTO FORMS & FEES */}
      {activeView === 'forms' && (
        <div className="space-y-4">
          <div className="bg-blue-50 dark:bg-blue-950/40 border border-blue-200 dark:border-blue-900 p-4 rounded-2xl flex items-start gap-3 text-blue-900 dark:text-blue-200 text-xs leading-relaxed">
            <FileText className="w-5 h-5 text-blue-600 shrink-0 mt-0.5" />
            <p>
              Standard government fees prescribed under Rule 81 of the Central Motor Vehicles Rules. All applications can be initiated online through the official Parivahan citizen portal without physical middleman fees.
            </p>
          </div>

          <div className="space-y-3">
            {services.map((srv) => (
              <div
                key={srv.id}
                className="bg-white dark:bg-slate-900 border border-slate-200 dark:border-slate-800 rounded-2xl p-5 shadow-sm space-y-3"
              >
                <div className="flex items-start justify-between gap-3 border-b border-slate-100 dark:border-slate-800 pb-3">
                  <div>
                    <span className="px-2 py-0.5 rounded bg-blue-100 dark:bg-blue-950/80 text-blue-700 dark:text-blue-300 font-mono font-bold text-xs">
                      {srv.form}
                    </span>
                    <h3 className="text-base font-bold text-slate-900 dark:text-white mt-1">
                      {srv.name}
                    </h3>
                  </div>

                  <div className="text-right">
                    <span className="text-[10px] text-slate-400 uppercase tracking-wider block">Official Govt Fee</span>
                    <span className="text-sm font-bold text-emerald-600 dark:text-emerald-400">
                      {srv.govtFee}
                    </span>
                  </div>
                </div>

                <div className="text-xs space-y-1.5">
                  <span className="font-bold text-slate-700 dark:text-slate-300 block">
                    Required Documents Checklist:
                  </span>
                  <ul className="list-disc pl-5 space-y-1 text-slate-500 dark:text-slate-400">
                    {srv.documents.map((doc: string, i: number) => (
                      <li key={i}>{doc}</li>
                    ))}
                  </ul>
                </div>

                <div className="pt-2 border-t border-slate-100 dark:border-slate-800 flex items-center justify-between text-xs text-slate-400">
                  <span>Standard Processing Time:</span>
                  <span className="font-semibold text-slate-700 dark:text-slate-200">{srv.timeline}</span>
                </div>
              </div>
            ))}
          </div>
        </div>
      )}
    </div>
  );
};
