import React, { useState } from 'react';
import { Search, Sparkles, Zap } from 'lucide-react';

interface NumberPlateInputProps {
  value: string;
  onChange: (val: string) => void;
  onSearch: (val: string) => void;
  isLoading?: boolean;
  placeholder?: string;
  isElectricPlate?: boolean;
}

export const NumberPlateInput: React.FC<NumberPlateInputProps> = ({
  value,
  onChange,
  onSearch,
  isLoading = false,
  placeholder = 'e.g. DL 01 AB 1234',
  isElectricPlate = false
}) => {
  const [electricTheme, setElectricTheme] = useState(isElectricPlate);

  const samplePlates = [
    { plate: 'DL 01 AB 1234', desc: 'Maruti Swift (Delhi)', ev: false },
    { plate: 'MH 12 DE 1433', desc: 'Hyundai Creta (Pune)', ev: false },
    { plate: 'KA 05 MJ 5005', desc: 'Nexon EV (Bengaluru)', ev: true },
    { plate: 'HR 26 DQ 5551', desc: 'Royal Enfield (Gurugram)', ev: false }
  ];

  const handleInputChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    let clean = e.target.value.toUpperCase();
    onChange(clean);
  };

  const handleKeyDown = (e: React.KeyboardEvent<HTMLInputElement>) => {
    if (e.key === 'Enter') {
      e.preventDefault();
      onSearch(value);
    }
  };

  const selectSample = (plate: string, ev: boolean) => {
    onChange(plate);
    setElectricTheme(ev);
    onSearch(plate);
  };

  return (
    <div className="w-full max-w-2xl mx-auto space-y-3">
      {/* HSRP Number Plate Container */}
      <div className="relative group">
        <div
          className={`relative flex items-center border-4 rounded-2xl shadow-xl transition-all duration-300 overflow-hidden ${
            electricTheme
              ? 'bg-emerald-600 border-slate-900 shadow-emerald-500/20'
              : 'bg-white border-slate-900 dark:border-slate-700 shadow-blue-500/10'
          }`}
        >
          {/* Blue IND Strip */}
          <div className="bg-blue-700 text-white px-3.5 py-4 flex flex-col items-center justify-center shrink-0 border-r-2 border-blue-900 select-none">
            {/* Ashoka wheel dot simulation */}
            <div className="w-4 h-4 rounded-full border-2 border-amber-300 flex items-center justify-center mb-0.5 animate-spin-slow">
              <div className="w-1.5 h-1.5 bg-amber-300 rounded-full"></div>
            </div>
            <span className="text-xs font-black tracking-widest font-mono text-white leading-none">
              IND
            </span>
          </div>

          {/* Number Plate Input Area */}
          <div className="flex-1 relative flex items-center px-4">
            <input
              type="text"
              value={value}
              onChange={handleInputChange}
              onKeyDown={handleKeyDown}
              placeholder={placeholder}
              maxLength={15}
              className={`w-full py-4 bg-transparent font-mono-plate font-black text-xl sm:text-2xl md:text-3xl tracking-widest focus:outline-none uppercase ${
                electricTheme ? 'text-white placeholder-emerald-200' : 'text-slate-900 placeholder-slate-400'
              }`}
            />
          </div>

          {/* Search Action Button */}
          <div className="pr-3">
            <button
              onClick={() => onSearch(value)}
              disabled={isLoading || !value.trim()}
              className="bg-blue-600 hover:bg-blue-700 active:scale-95 disabled:opacity-50 text-white px-5 py-3 rounded-xl font-bold flex items-center gap-2 shadow-md transition-all text-sm shrink-0"
            >
              {isLoading ? (
                <div className="w-5 h-5 border-2 border-white/30 border-t-white rounded-full animate-spin" />
              ) : (
                <>
                  <Search className="w-4 h-4" />
                  <span className="hidden sm:inline">Search</span>
                </>
              )}
            </button>
          </div>
        </div>

        {/* Hologram security stamp badge */}
        <div className="absolute top-2 right-20 pointer-events-none opacity-40 hidden sm:flex items-center gap-1">
          <div className="w-4 h-4 rounded-full bg-gradient-to-tr from-amber-400 to-yellow-200 border border-amber-500 flex items-center justify-center">
            <Sparkles className="w-2.5 h-2.5 text-amber-900" />
          </div>
          <span className="text-[8px] font-mono font-bold text-slate-500 uppercase">HSRP</span>
        </div>
      </div>

      {/* Plate Type Quick Switch & Sample Plate Badges */}
      <div className="flex flex-wrap items-center justify-between gap-2 pt-1 text-xs">
        <div className="flex items-center gap-1.5 flex-wrap">
          <span className="text-slate-500 dark:text-slate-400 font-medium">Quick Test:</span>
          {samplePlates.map((s) => (
            <button
              key={s.plate}
              onClick={() => selectSample(s.plate, s.ev)}
              className="px-2.5 py-1 rounded-lg bg-slate-100 hover:bg-slate-200 dark:bg-slate-800 dark:hover:bg-slate-700 text-slate-700 dark:text-slate-300 font-mono font-semibold transition-colors border border-slate-200 dark:border-slate-700 flex items-center gap-1"
            >
              {s.ev && <Zap className="w-3 h-3 text-emerald-500" />}
              <span>{s.plate}</span>
            </button>
          ))}
        </div>

        <button
          onClick={() => setElectricTheme(!electricTheme)}
          className={`flex items-center gap-1 px-2.5 py-1 rounded-lg font-medium transition-colors ${
            electricTheme
              ? 'bg-emerald-100 dark:bg-emerald-950/80 text-emerald-700 dark:text-emerald-300 border border-emerald-300 dark:border-emerald-700'
              : 'text-slate-500 dark:text-slate-400 hover:text-slate-800 dark:hover:text-slate-200'
          }`}
          title="Toggle Green EV Plate styling"
        >
          <Zap className="w-3.5 h-3.5" />
          <span>{electricTheme ? 'Green Plate (EV)' : 'Switch to EV Plate'}</span>
        </button>
      </div>
    </div>
  );
};
