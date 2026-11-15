import React, { useState, useEffect } from 'react';
import { RtoOffice } from '../types';
import { fetchRtoStates, fetchRtoOffices } from '../services/api';
import { Building2, Search, MapPin, Phone, Mail, Globe, ArrowRight } from 'lucide-react';

export const RtoDirectory: React.FC = () => {
  const [states, setStates] = useState<Array<{ code: string; name: string; capital: string }>>([]);
  const [selectedState, setSelectedState] = useState<string>('');
  const [searchTerm, setSearchTerm] = useState<string>('');
  const [offices, setOffices] = useState<RtoOffice[]>([]);
  const [loading, setLoading] = useState(false);

  useEffect(() => {
    fetchRtoStates().then(setStates).catch(console.error);
    loadOffices('', '');
  }, []);

  const loadOffices = (stateCode: string, search: string) => {
    setLoading(true);
    fetchRtoOffices(stateCode, search)
      .then(setOffices)
      .catch(console.error)
      .finally(() => setLoading(false));
  };

  const handleStateChange = (stateCode: string) => {
    setSelectedState(stateCode);
    loadOffices(stateCode, searchTerm);
  };

  const handleSearchChange = (q: string) => {
    setSearchTerm(q);
    loadOffices(selectedState, q);
  };

  return (
    <div className="max-w-5xl mx-auto space-y-8 px-4">
      {/* Header */}
      <div className="text-center space-y-2">
        <div className="inline-flex items-center gap-1.5 px-3 py-1 rounded-full bg-blue-50 dark:bg-blue-950/80 border border-blue-200 dark:border-blue-800 text-blue-700 dark:text-blue-300 text-xs font-semibold">
          <Building2 className="w-3.5 h-3.5" />
          <span>All-India Transport Department Directory</span>
        </div>
        <h1 className="text-2xl sm:text-3xl font-extrabold text-slate-900 dark:text-white">
          Regional Transport Offices (RTO) Directory
        </h1>
        <p className="text-xs sm:text-sm text-slate-500 dark:text-slate-400">
          Find RTO office locations, code designations, addresses, and contacts across India
        </p>
      </div>

      {/* Filter and Search Bar */}
      <div className="bg-white dark:bg-slate-900 border border-slate-200 dark:border-slate-800 rounded-2xl p-4 shadow-sm space-y-3">
        <div className="grid grid-cols-1 sm:grid-cols-3 gap-3">
          {/* State selector */}
          <div className="sm:col-span-1">
            <label className="block text-xs font-bold text-slate-700 dark:text-slate-300 mb-1">
              Filter by State / UT
            </label>
            <select
              value={selectedState}
              onChange={(e) => handleStateChange(e.target.value)}
              className="w-full px-3 py-2.5 rounded-xl border border-slate-300 dark:border-slate-700 bg-slate-50 dark:bg-slate-800 text-slate-900 dark:text-white text-xs font-medium focus:ring-2 focus:ring-blue-500 focus:outline-none"
            >
              <option value="">All States & UTs</option>
              {states.map((s) => (
                <option key={s.code} value={s.code}>
                  {s.name} ({s.code})
                </option>
              ))}
            </select>
          </div>

          {/* Keyword Search */}
          <div className="sm:col-span-2">
            <label className="block text-xs font-bold text-slate-700 dark:text-slate-300 mb-1">
              Search by Code or City
            </label>
            <div className="relative">
              <input
                type="text"
                value={searchTerm}
                onChange={(e) => handleSearchChange(e.target.value)}
                placeholder="e.g. MH-12, DL-01, Bangalore, Andheri, Pune..."
                className="w-full pl-9 pr-4 py-2.5 rounded-xl border border-slate-300 dark:border-slate-700 bg-slate-50 dark:bg-slate-800 text-slate-900 dark:text-white text-xs focus:ring-2 focus:ring-blue-500 focus:outline-none"
              />
              <Search className="w-4 h-4 text-slate-400 absolute left-3 top-3 pointer-events-none" />
            </div>
          </div>
        </div>

        {/* Quick State Chips */}
        <div className="flex items-center gap-1.5 flex-wrap pt-1 text-xs">
          <span className="text-slate-400 font-medium">Popular:</span>
          {['DL', 'MH', 'KA', 'TN', 'UP', 'GJ', 'HR'].map((code) => (
            <button
              key={code}
              onClick={() => handleStateChange(code)}
              className={`px-2.5 py-1 rounded-lg font-mono font-bold transition-colors ${
                selectedState === code
                  ? 'bg-blue-600 text-white'
                  : 'bg-slate-100 dark:bg-slate-800 text-slate-700 dark:text-slate-300 hover:bg-slate-200'
              }`}
            >
              {code}
            </button>
          ))}
          {selectedState && (
            <button
              onClick={() => handleStateChange('')}
              className="text-xs text-rose-500 hover:underline ml-2"
            >
              Clear filter
            </button>
          )}
        </div>
      </div>

      {/* Offices Count Indicator */}
      <div className="flex items-center justify-between text-xs text-slate-500">
        <span>Found {offices.length} RTO transport offices</span>
        {loading && <span className="text-blue-500 animate-pulse">Loading directory...</span>}
      </div>

      {/* Offices Grid */}
      <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
        {offices.map((office) => (
          <div
            key={office.code}
            className="bg-white dark:bg-slate-900 border border-slate-200 dark:border-slate-800 rounded-2xl p-5 shadow-sm space-y-3 hover:border-blue-500/50 transition-colors"
          >
            <div className="flex items-start justify-between gap-3 border-b border-slate-100 dark:border-slate-800 pb-3">
              <div>
                <span className="inline-block px-2.5 py-1 rounded-lg bg-blue-100 dark:bg-blue-950/80 text-blue-700 dark:text-blue-300 font-mono font-black text-sm border border-blue-200 dark:border-blue-800">
                  {office.code}
                </span>
                <h3 className="text-sm font-bold text-slate-900 dark:text-white mt-1.5">
                  {office.city} - {office.location}
                </h3>
                <span className="text-xs font-semibold text-slate-500">{office.state}</span>
              </div>
            </div>

            <div className="space-y-2 text-xs">
              <div className="flex items-start gap-2">
                <MapPin className="w-4 h-4 text-slate-400 shrink-0 mt-0.5" />
                <span className="text-slate-600 dark:text-slate-300">{office.address}</span>
              </div>

              {office.phone && (
                <div className="flex items-center gap-2">
                  <Phone className="w-4 h-4 text-emerald-500 shrink-0" />
                  <a
                    href={`tel:${office.phone}`}
                    className="text-slate-700 dark:text-slate-300 font-medium hover:text-blue-600"
                  >
                    {office.phone}
                  </a>
                </div>
              )}

              {office.email && (
                <div className="flex items-center gap-2">
                  <Mail className="w-4 h-4 text-sky-500 shrink-0" />
                  <a
                    href={`mailto:${office.email}`}
                    className="text-slate-700 dark:text-slate-300 font-mono text-[11px] hover:text-blue-600"
                  >
                    {office.email}
                  </a>
                </div>
              )}
            </div>
          </div>
        ))}
      </div>
    </div>
  );
};
